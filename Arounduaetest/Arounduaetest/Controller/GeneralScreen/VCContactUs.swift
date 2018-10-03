//
//  VCContactUs.swift
//  AroundUAE
//
//  Created by Apple on 12/09/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class VCContactUs: UIViewController{
    
    @IBOutlet weak var appFeedBack: UILabel!
    @IBOutlet weak var txtAppFeedback: UICustomTextView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblYourComment: UILabel!
    @IBOutlet weak var txtComment: UITextView!
    @IBOutlet weak var btnSubmit: UIButtonMain!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool){
        self.setNavigationBar()
        self.addBackButton()
        self.title = "Contact Us".localized
        self.appFeedBack.text = "App Feedback".localized
        self.txtAppFeedback.text = "   Comments...".localized
        self.lblName.text = "Name".localized
        self.txtName.placeholder = "Name".localized
        self.lblEmail.text = "Email".localized
        self.txtEmail.placeholder = "Email".localized
        self.lblYourComment.text = "Your Comment".localized
        self.txtComment.text = "Comment".localized
        self.btnSubmit.setTitle("Submit".localized, for: .normal)
    }
    
    private func isCheck()->Bool{
        
        guard let Name = txtName.text, Name.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert", message: "Please Enter Your Name", okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        guard let email = txtEmail.text, email.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert", message: "Please Enter Email!", okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        if !email.isValidEmail{
            let alertView = AlertView.prepare(title: "Alert", message: "Please Enter Valid Email!", okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    @IBAction func btnSubmitClick(_ sender: Any){
        if isCheck(){
            contactUs(name: txtName.text!, email: txtEmail.text!, comment: txtComment.text!)
        }
    }
    
    private func contactUs(name:String,email:String,comment:String){
        startLoading("")
        IndexManager().contactUs((name,email,"AppFeedBack",comment),
        successCallback:
        {[weak self](response) in
            self?.finishLoading()
            if let contactResponse = response{
                if contactResponse.success!{
                   self?.alertMessage(message: contactResponse.message?.en ?? "", completionHandler: nil)
                }else{
                    self?.alertMessage(message: contactResponse.message?.en ?? "", completionHandler: nil)
                }
            }else{
                self?.alertMessage(message: response?.message?.en ?? "", completionHandler: nil)
            }
        })
        {[weak self](error) in
            self?.finishLoading()
            self?.alertMessage(message: error.message.localized, completionHandler: nil)
        }
    }
}
