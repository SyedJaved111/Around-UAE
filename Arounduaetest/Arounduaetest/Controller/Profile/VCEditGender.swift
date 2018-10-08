//
//  VCEditGender.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 02/10/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import DLRadioButton

class VCEditGender: UIViewController {
    
    @IBOutlet weak var btnupdate: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lbldata: UILabel!
    @IBOutlet weak var lblheading: UILabel!
    @IBOutlet var backView: UIView!
    @IBOutlet weak var maleRadio: DLRadioButton!
    @IBOutlet weak var femaleRadio: DLRadioButton!
    var gender = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        self.backView.addGestureRecognizer(tap)
        
        if gender == "male"{
            maleRadio.isSelected = true
        }else{
            femaleRadio.isSelected = true
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.lblheading.text = "Edit Gender".localized
        self.lbldata.text = "Please Select your Gender".localized
        self.btnCancel.setTitle("CANCEL".localized, for: .normal)
       self.btnupdate.setTitle("UPDATE".localized, for: .normal)
        self.maleRadio.setTitle("Male".localized, for: .normal)
        self.femaleRadio.setTitle("Female".localized, for: .normal)
    }
    @IBAction func female(_ sender: DLRadioButton) {
        femaleRadio.isSelected = true
        maleRadio.isSelected = false
    }
    
    @IBAction func male(_ sender: DLRadioButton) {
        femaleRadio.isSelected = false
        maleRadio.isSelected = true
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func update(_ sender: Any){
        if maleRadio.isSelected{
            AppSettings.sharedSettings.user.gender = "male"
        }else{
            AppSettings.sharedSettings.user.gender = "female"
        }
        updateProfile(AppSettings.sharedSettings.user)
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
