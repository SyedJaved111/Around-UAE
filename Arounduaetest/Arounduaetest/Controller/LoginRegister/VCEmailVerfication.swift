//
//  VCEmailVerfication.swift
//  AroundUAE
//
//  Created by Apple on 12/09/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class VCEmailVerfication: BaseController {

    @IBOutlet weak var lblVerficationCodeText: UILabel!
    @IBOutlet weak var txtEnterCode: UITextField!
    @IBOutlet weak var btnResend: UIButtonMain!
    @IBOutlet weak var btnSubmit: UIButtonMain!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let email = AppSettings.sharedSettings.user.email ?? ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool){
        self.setNavigationBar()
        self.addBackButton()
        self.setupLocalization()
    }
    
    private func setupLocalization(){
        self.title = "Email Verfication".localized
        self.lblVerficationCodeText.text = "A verfication code is send to your email, please check your email and enter the verfication code below".localized
        self.txtEnterCode.placeholder = "Enter Code".localized
        self.btnResend.setTitle("Resend".localized, for: .normal)
        self.btnSubmit.setTitle("Submit".localized, for: .normal)
    }

    @IBAction func btnSubmitClick(_ sender: Any){
        guard let code = txtEnterCode.text, code.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter Verfication Code", okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return
        }
        
        if code.count < 4 {
            let alertView = AlertView.prepare(title: "Error".localized, message: "Please Enter Correct Code".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return
        }
        
        verifyCode(email: email, code: code)
    }
    
    private func verifyCode(email:String,code:String){
        startLoading("")
        AuthManager().emailverificationPassword((email,code),
        successCallback:
        {[weak self](response) in
             DispatchQueue.main.async{
                self?.finishLoading()
                if let loginResponse = response{
                    if(loginResponse.success!){
                        self?.alertMessage(message: loginResponse.message?.en ?? "",  completionHandler:
                        {self?.verified()})
                    }else{
                      self?.alertMessage(message: loginResponse.message?.en ?? "",  completionHandler: nil)
                    }
                }else{
                    self?.alertMessage(message: "Error".localized,  completionHandler: nil)
                }
            }
        }){[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.alertMessage(message: error.message, completionHandler: nil)
            }
        }
    }
    
    private func verified(){
        AppSettings.sharedSettings.user.isEmailVerified = true
        if let type = AppSettings.sharedSettings.user.accountType, type == "buyer"{
            self.appDelegate.moveToHome()
        }else{
            self.appDelegate.moveToHome()
        }
    }

    @IBAction func btnResendClick(_ sender: Any){
        startLoading("")
        AuthManager().ResendverificationCode(email,
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async{
                self?.finishLoading()
                if let loginResponse = response{
                    if(loginResponse.success!){
                        self?.alertMessage(message: loginResponse.message?.en ?? "",  completionHandler: nil)
                    }else{
                        self?.alertMessage(message: loginResponse.message?.en ?? "",  completionHandler: nil)
                    }
                }else{
                  self?.alertMessage(message: "Error".localized,  completionHandler: nil)
             }
        }
        }){[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.alertMessage(message: error.message, completionHandler: nil)
            }
        }
    }
}
