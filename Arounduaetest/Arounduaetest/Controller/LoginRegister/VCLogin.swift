//
//  VCLogin.swift
//  AroundUAE
//
//  Created by Apple on 10/09/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

class VCLogin: BaseController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    var bgColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0)
    var User = SharedData.sharedUserInfo
    let defaults = UserDefaults.standard
    var ishownBackBtn = true
    
    @IBOutlet weak var txtEmail: UITextFieldCustom!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButtonMain!
    @IBOutlet weak var btnForgetYourPassword: UIButton!
    @IBOutlet weak var lblOR: UILabel!
    @IBOutlet weak var lblContinueWithFaceBook: UILabel!
    @IBOutlet weak var lblContinueWithGmail: UILabel!
    @IBOutlet weak var lblDontHaveAnAccount: UILabel!
    @IBOutlet weak var btnRegisterNow: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool){
        self.setNavigationBar()
        if ishownBackBtn{
            if lang == "ar"{
                self.showArabicBackButton()
            }else if lang == "en"{
                addBackButton()
            }
        }
        self.setupLocalization()
        self.TxtFfieldLocalaiz()
        if let myImage = UIImage(named: "Username"){
            txtEmail.withImage(direction: .Left, image: myImage, colorSeparator: UIColor.black, colorBorder: UIColor.lightGray)
        }
        
        if let myImage1 = UIImage(named: "Password"){
            txtPassword.withImage(direction: .Left, image: myImage1, colorSeparator: UIColor.black, colorBorder: UIColor.lightGray)
        }
    }
    
    func TxtFfieldLocalaiz(){
        let passwordimg = UIImage(named: "Password")
        let userimg = UIImage(named: "Username")
        
        if (lang == "ar"){
            txtEmail.setPadding(left: 0, right: 15)
            txtPassword.setPadding(left: 0, right: 15)
            self.txtPassword.withImage(direction: .Right, image: passwordimg!, colorSeparator: bgColor, colorBorder: bgColor)
            self.txtEmail.withImage(direction: .Right, image: userimg!, colorSeparator: bgColor, colorBorder: bgColor)
        } else if(lang == "en"){
            txtEmail.setPadding(left: 0, right: 0)
            txtPassword.setPadding(left: 0, right: 0)
            self.txtEmail.withImage(direction: .Left, image: userimg!, colorSeparator: bgColor, colorBorder: bgColor)
            self.txtPassword.withImage(direction: .Left, image: passwordimg!, colorSeparator: bgColor, colorBorder: bgColor)
        }
    }
    
    private func setupLocalization(){
        self.title = "Login".localized
        self.txtEmail.placeholder = "Username".localized
        self.txtPassword.placeholder = "Password".localized
        self.btnLogin.setTitle("Login".localized, for: .normal)
        self.btnForgetYourPassword.setTitle("Forgot your password?".localized, for: .normal)
        self.lblOR.text = "OR".localized
        self.lblContinueWithFaceBook.text = "Login with facebook".localized
        self.lblContinueWithGmail.text = "Login with gmail".localized
        self.lblDontHaveAnAccount.text = "Don't have an account?".localized
    }
    
    private func isCheck()->Bool{
        
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
        
        guard let password = txtPassword.text, password.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert", message: "Please Enter Password", okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    @IBAction func btnLoginClick(_ sender: Any){
        if isCheck(){
            loginUser(useremail:txtEmail.text!, userpassword:txtPassword.text!)
        }
    }
    
    @IBAction func btnForgetPasswordClick(_ sender: Any){
        guard let vcForgotpassword = self.getControllerRef(controller: VCForgotPassword.identifier,
        storyboard: Storyboards.Main) as? VCForgotPassword else {return}
        self.navigationController?.pushViewController(vcForgotpassword, animated: true)
    }
    
    @IBAction func btnFacebookClick(_ sender: Any){
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["email", "public_profile"], from: self)
        {[weak self](result, error) in
            if error != nil{
                print(error?.localizedDescription ?? "Nothing")
            }else if (result?.isCancelled)!{
                print("Cancel")
            }
            else{
                if(result?.grantedPermissions.contains("email"))!{
                     self?.logInFromFacebook()
                }
            }
        }
    }
    
    @IBAction func btnGoogleClick(_ sender: Any){
        let googleSignIn = GIDSignIn.sharedInstance()
        googleSignIn?.shouldFetchBasicProfile = true
        googleSignIn?.scopes = ["profile", "email"]
        googleSignIn?.delegate = self
        googleSignIn?.signIn()
    }
    
    @IBAction func btnRegisterNowClick(_ sender: Any){
        guard let vcRegister = self.getControllerRef(controller: VCRegister.identifier,
                                                     storyboard: Storyboards.Main) as? VCRegister else {return}
        self.navigationController?.pushViewController(vcRegister, animated: true)
    }
    
    private func loginUser(useremail:String,userpassword:String){
        startLoading("")
        AuthManager().loginUser((useremail,userpassword),
        successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    if let loginResponse = response{
                        
                        if(loginResponse.success!){
                            
                            AppSettings.sharedSettings.user = loginResponse.data!
                            let accountType =  loginResponse.data?.accountType ?? ""
                            let authToken  = loginResponse.data?.authorization ?? ""
                            AppSettings.sharedSettings.authToken = authToken
                            AppSettings.sharedSettings.accountType = accountType
                            
                            if(loginResponse.data?.isEmailVerified! == true){
                                
                                AppSettings.sharedSettings.userEmail = self?.txtEmail.text!
                                AppSettings.sharedSettings.userPassword = self?.txtPassword.text!
                                AppSettings.sharedSettings.isAutoLogin = true
                                AppSettings.sharedSettings.loginMethod = "local"
                                
                                if(accountType == "buyer"){
                                    self?.appDelegate.moveToHome()
                                }
                                else{
                                    self?.appDelegate.moveToHome()
                                }
                            }else{
                                self?.moveToVCEmail()
                            }
                        }else{
                            self?.alertMessage(message: loginResponse.message?.en ?? "", completionHandler: nil)
                        }
                    }else{
                        self?.alertMessage(message: "Error".localized, completionHandler: nil)
                    }
                }
            },failureCallback:
            {[weak self](error) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    self?.alertMessage(message: error.message, completionHandler: nil)
                }
        })
    }
}

extension VCLogin: GIDSignInUIDelegate, GIDSignInDelegate{
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error{
            print(error.localizedDescription)
        }
        if error == nil{
            self.User.socialName = user.profile.name
            self.User.socialEmail = user.profile.email
            self.User.socialId = user.userID
            self.User.isSocialLogin = 1
            checkIsSocialLogin(check: 1,ID: user.userID)
        }
    }
    
    func checkIsSocialLogin(check: Int,ID: String){
        startLoading("")
        AuthManager().checkIsSocialLogin(check: check, socialID: ID,
                                         successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    if let socialResponse = response{
                        if (socialResponse.success!){
                            self?.User.socialName = nil
                            self?.User.socialEmail = nil
                            self?.User.socialId = nil
                            self?.User.isSocialLogin = -1
                            self?.userProfileData(check: check, successResponse: socialResponse)
                        }
                        else{
                            self?.appDelegate.moveToLogin()
                        }
                    }else{
                       self?.alertMessage(message: response?.message?.en ?? "", completionHandler: nil)
                    }
                }
        }){[weak self](error) in
            DispatchQueue.main.async {
                self?.alertMessage(message: error.message, completionHandler: nil)
            }
        }
    }
    
    private func userProfileData(check : Int, successResponse : Response<User>){
        
        AppSettings.sharedSettings.user = successResponse.data!
        let accountType = successResponse.data?.accountType ?? ""
        let authToken = successResponse.data?.authorization ?? ""
        AppSettings.sharedSettings.authToken = authToken
        AppSettings.sharedSettings.accountType = accountType
        
        if(successResponse.data?.isEmailVerified! == true){
            AppSettings.sharedSettings.isAutoLogin = true
            AppSettings.sharedSettings.loginMethod = (check == 0) ? "local0" : "local1"
    
            if(accountType == "buyer"){
                self.appDelegate.moveToHome()
            }
            else{
                self.appDelegate.moveToHome()
            }
        }else{
            self.moveToVCEmail()
        }
    }
    
    private func moveToVCEmail(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCEmailVerfication") as! VCEmailVerfication
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension VCLogin{
    
    func logInFromFacebook() {
        if (FBSDKAccessToken.current() != nil) {
            self.startLoading("")
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, first_name, last_name, email, gender, picture.type(large)"]).start { (connection, result, error) in
                
                if error != nil{
                    print(error?.localizedDescription ?? "Nothing")
                    return
                }
                else{
                    guard let results = result as? NSDictionary else { return }
                    print(results)
                    guard let facebookId = results["id"] as? String,
                        let email = results["email"] as? String,
                        let fullName = results["name"] as? String else {
                            return
                    }
                }
            }
        }
    }
}
