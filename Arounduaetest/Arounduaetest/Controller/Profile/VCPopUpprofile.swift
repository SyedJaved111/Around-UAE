//
//  VCPopUp.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 21/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit

class VCPopUpprofile: UIViewController {
    
    @IBOutlet weak var headinglbl: UILabel!
    @IBOutlet weak var TxtFiledName: UITextField!
    @IBOutlet weak var titlelbl: UILabel!
    
    var titlefield = ""
    var placeholdertxt = ""
    var headertxt = ""
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.TxtFiledName.setPadding(left: 15, right: 0)
        titlelbl.text = titlefield
        headinglbl.text = headertxt
        
        switch placeholdertxt {
            case "Name":
               TxtFiledName.text = AppSettings.sharedSettings.user.fullName
            case "Email":
               TxtFiledName.text = AppSettings.sharedSettings.user.email
            case "Gender":
               TxtFiledName.text = AppSettings.sharedSettings.user.gender
            case "Address":
                TxtFiledName.text = AppSettings.sharedSettings.user.address
            case "PhoneNo":
               TxtFiledName.text = AppSettings.sharedSettings.user.phone
            default:
                break
        }
    }

    @IBAction func cancelClick(_ sender: Any) {
        dismiss(animated: true , completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    @IBAction func submitclick(_ sender: Any){
        
        switch placeholdertxt {
            case "Name":
                
                guard let value = TxtFiledName.text,value.count > 0 else{
                    self.alertMessage(message: "Please Enter Name", completionHandler: nil)
                    return
                }
                AppSettings.sharedSettings.user.fullName = value
            case "Email":
                
                guard let value = TxtFiledName.text,value.count > 0 else{
                    self.alertMessage(message: "Please Enter Email", completionHandler: nil)
                    return
                }
                
                if !value.isValidEmail{
                    let alertView = AlertView.prepare(title: "Alert", message: "Please Enter Valid Email", okAction: {
                    })
                    self.present(alertView, animated: true, completion: nil)
                    return
                }
                
                AppSettings.sharedSettings.user.email = value
            case "Password":
                guard let value = TxtFiledName.text,value.count > 0 else{
                    self.alertMessage(message: "Please Enter Password", completionHandler: nil)
                    return
                }
                
                if value.count < 6 {
                    let alertView = AlertView.prepare(title: "Error".localized, message: "Please Enter Password Below 6 Characters".localized, okAction: {
                    })
                    self.present(alertView, animated: true, completion: nil)
                    return
                }
            case "CNIC":
                guard let value = TxtFiledName.text,value.count > 0 else{
                    self.alertMessage(message: "Please Enter CNIC", completionHandler: nil)
                    return
                }
                AppSettings.sharedSettings.user.nic = value
            case "Gender":
                guard let value = TxtFiledName.text,value.count > 0 else{
                    self.alertMessage(message: "Please Enter Gender", completionHandler: nil)
                    return
                }
                AppSettings.sharedSettings.user.gender = value
            case "City":
                guard let value = TxtFiledName.text,value.count > 0 else{
                    self.alertMessage(message: "Please Enter City", completionHandler: nil)
                    return
                }
            case "Address":
                guard let value = TxtFiledName.text,value.count > 0 else{
                    self.alertMessage(message: "Please Enter Address", completionHandler: nil)
                    return
                }
                AppSettings.sharedSettings.user.address = value
            case "PhoneNo":
                guard let value = TxtFiledName.text,value.count > 0 else{
                    self.alertMessage(message: "Please Enter Phone No", completionHandler: nil)
                    return
                }
                AppSettings.sharedSettings.user.phone = value
            default:
                break
        }
        
        updateProfile(AppSettings.sharedSettings.user)
    }
    
    @IBAction func resend(_ sender: UIButton){
        dismiss(animated: true , completion: nil)
    }

    private func updateProfile(_ user:User){
     
        let uiimage = UIImage(named: "def")
        let params = (user.fullName!,user.email!,user.phone!,user.address!,user.gender!,uiimage)
        startLoading("")
        ProfileManager().updateProfile(params, successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    if let profileResponse = response{
                        if profileResponse.success!{
                            AppSettings.sharedSettings.user = profileResponse.data!
                            NotificationCenter.default.post(name: Notification.Name("ProfileUpdated"), object: nil)
                            self?.dismiss(animated: true , completion: nil)
                        }else{
                            self?.alertMessage(message: response?.message?.en ?? "", completionHandler: {
                                self?.dismiss(animated: true , completion: nil)
                            })
                        }
                    }else{
                        self?.alertMessage(message: response?.message?.en ?? "", completionHandler: {
                            self?.dismiss(animated: true , completion: nil)
                        })
                    }
                }
            })
        {[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.alertMessage(message: error.message.localized, completionHandler: {
                    self?.dismiss(animated: true , completion: nil)
                })
            }
        }
    }
}
