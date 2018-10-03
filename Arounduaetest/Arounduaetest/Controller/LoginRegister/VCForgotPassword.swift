//
//  VCForgotPassword.swift
//  AroundUAE
//
//  Created by Apple on 12/09/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class VCForgotPassword: BaseController{
    
    @IBOutlet weak var lblForgotPassword: UILabel!
    @IBOutlet weak var txtEnterEmail: UITextField!
    @IBOutlet weak var btnSubmit: UIButtonMain!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationBar()
        self.addBackButton()
        self.title = "Forgot Password".localized
        self.lblForgotPassword.text = "Forgot your password? Enter your email below ".localized
        self.txtEnterEmail.placeholder = "Enter Email".localized
        self.btnSubmit.setTitle("Submit".localized, for: .normal)
    }
    
    private func isCheck()->Bool{
        guard let email = txtEnterEmail.text, email.count > 0 else {
            let alertView = AlertView.prepare(title: "Alert", message: "Please Enter email", okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        if !email.isValidEmail{
            let alertView = AlertView.prepare(title: "Alert", message: "Please Enter Valid Email", okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    @IBAction func btnSubmitClick(_ sender: Any){
        if isCheck(){
            forgotPassword(useremail: txtEnterEmail.text!)
        }
    }
    
    private func forgotPassword(useremail: String){
        startLoading("")
        AuthManager().forgotPassword(useremail,
        successCallback:
        {[weak self](resposne) in
             DispatchQueue.main.async {
                if let forgetesponse = resposne{
                    if(forgetesponse.success ?? false == true){
                        self?.finishLoading()
                        self?.alertMessage(message: forgetesponse.message?.en ?? "", completionHandler: {
                            self?.moveToChangePassword()
                        })
                    }else{
                        self?.finishLoading()
                        self?.alertMessage(message: forgetesponse.message?.en ?? "", completionHandler: nil)
                    }
                }else{
                    self?.finishLoading()
                    self?.alertMessage(message: "Error",  completionHandler: nil)
                }
            }
        }){[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.alertMessage(message: error.message,  completionHandler: nil)
            }
        }
    }
    
    private func moveToChangePassword(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCChangePassword") as! VCChangePassword
        vc.email = txtEnterEmail.text!
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
