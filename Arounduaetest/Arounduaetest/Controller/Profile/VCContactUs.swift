//
//  VCContactUs.swift
//  AroundUAE
//
//  Created by Apple on 12/09/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import DropDown

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
    @IBOutlet weak var dropdown: UIButton!
    let menudropDown = DropDown()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        menudropDown.anchorView = dropdown
        menudropDown.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        menudropDown.selectionBackgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        menudropDown.dataSource = ["App Feedback".localized,"Complaint".localized]
        menudropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.appFeedBack.text = item
        }
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
    
    @IBAction func dropDown(_ sender: Any){
       menudropDown.show()
    }
    
    @IBAction func btnSubmitClick(_ sender: Any){
        if isCheck(){
            contactUs(name: txtName.text!, email: txtEmail.text!, comment: txtComment.text!)
        }
    }
    
    private func contactUs(name:String,email:String,comment:String){
        startLoading("")
        IndexManager().contactUs((name,email,self.appFeedBack.text!,comment),
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
