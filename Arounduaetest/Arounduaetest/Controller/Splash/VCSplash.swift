//
//  VCSplash.swift
//  AroundUAE
//
//  Created by Apple on 10/09/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
let currency = UserDefaults.standard.string(forKey: "currency")
class VCSplash: BaseController {
    
    @IBOutlet weak var lblSplashScreen: UILabel!
    
    var isVarified = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var User = SharedData.sharedUserInfo
    let defaults = UserDefaults.standard
    var fcmToken = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(currency == nil){
            UserDefaults.standard.set("aed", forKey: "currency")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        self.loadSettingData()
        if lang == "ar"{
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }else if lang == "en"{
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        lblSplashScreen.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's".localized
    }
    
    private func loadSettingData(){
        startLoading("")
        IndexManager().getSiteSettings(successCallback:
        {[weak self](response) in
                self?.finishLoading()
                if let settingResposne = response{
                    if(settingResposne.success!){
                        self?.User.index = settingResposne.data!
                        self?.User.setting = (settingResposne.data?.settings!)!
                        self?.User.pages = (settingResposne.data?.pages!)!
                        self?.User.sliders = (settingResposne.data?.sliders!)!
                        self?.goToNext()
                    }else{
                        self?.showAlert((lang == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", tryAgainClouser: {_ in self?.loadSettingData()})
                    }
                }else{
                    self?.showAlert((lang == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", tryAgainClouser: {_ in self?.loadSettingData()})
                }
        }){[weak self](error) in
                self?.finishLoading()
                self?.showAlert(error.message, tryAgainClouser:
                {_ in self?.loadSettingData()})
           }
       }
    
    private func goToNext(){
        if lang == nil{
           self.appDelegate.moveToSelectlanguage()
        }else{
            if let autologin = AppSettings.sharedSettings.isAutoLogin, autologin == true {
                if let value = AppSettings.sharedSettings.loginMethod{
                    if value == "local"{
                        logInFromEmail()
                    }else if value == "google"{
                        checkIsSocialLogin(check: 0)
                    }else if value == "facebook"{
                        checkIsSocialLogin(check: 1)
                    }else{
                       self.appDelegate.moveToLogin()
                    }
                }
            }else{
                self.appDelegate.moveToLogin()
            }
        }
    }
    
     private func logInFromEmail(){
        startLoading("")
        
        if let userpassword = AppSettings.sharedSettings.userPassword,
           let useremail = AppSettings.sharedSettings.userEmail{
    
            AuthManager().loginUser((useremail,userpassword),
            successCallback:
            {[weak self](response) in
                self?.finishLoading()
                if let loginResponse = response{
                    if(loginResponse.success!){
                        AppSettings.sharedSettings.user = loginResponse.data!
                        let accountType = loginResponse.data?.accountType!
                        let authToken = loginResponse.data?.authorization!
                        AppSettings.sharedSettings.authToken = authToken
                        AppSettings.sharedSettings.loginMethod = "local"
                        AppSettings.sharedSettings.accountType = accountType
                        self?.appDelegate.moveToHome()
                    
                    }else{
                        self?.alertMessage(message: (lang == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: {
                            self?.logInFromEmail()
                        })
                    }
                }else{
                    self?.alertMessage(message: "Error".localized, completionHandler: {
                        self?.logInFromEmail()
                    })
                 }
            },failureCallback:
               {[weak self](error) in
                self?.finishLoading()
                self?.alertMessage(message: error.message.localized, completionHandler: {
                    self?.logInFromEmail()
                })
            })
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "VCLogin") as! VCLogin
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func checkIsSocialLogin(check: Int){
        
        guard let id = AppSettings.sharedSettings.socialId, let acesstoken = AppSettings.sharedSettings.socialAccessToken,
            let email = AppSettings.sharedSettings.userEmail, let name = AppSettings.sharedSettings.fullName,
            let authmethod = AppSettings.sharedSettings.loginMethod else{
                return
        }
        let param = (id,acesstoken,email,authmethod,name)
        startLoading("")
        AuthManager().SocialLogin((id,acesstoken,email,authmethod,name),
        successCallback:
        {[weak self](response) in
            self?.finishLoading()
            if let socialResponse = response{
                if(socialResponse.success!){
                    self?.userProfileData(check : check, params: param, successResponse : socialResponse)
                }else{
                    self?.alertMessage(message: (lang == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: {
                        self?.checkIsSocialLogin(check: check)
                    })
                }
            }else{
                self?.alertMessage(message: (lang == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: {
                    self?.checkIsSocialLogin(check: check)
                })
            }
        })
        {[weak self](error) in
            self?.alertMessage(message: error.message.localized, completionHandler: {
                self?.checkIsSocialLogin(check: check)
            })
        }
    }
    
    private func userProfileData(check : Int, params:SocialParams ,successResponse : Response<User>){
        AppSettings.sharedSettings.user = successResponse.data!
        let accountType = successResponse.data?.accountType!
        let authToken = successResponse.data?.authorization!
        AppSettings.sharedSettings.authToken = authToken
        AppSettings.sharedSettings.accountType = accountType
        AppSettings.sharedSettings.loginMethod = (check == 0) ? "google" : "facebook"
        AppSettings.sharedSettings.socialId = params.id
        AppSettings.sharedSettings.socialAccessToken = params.accessToken
        AppSettings.sharedSettings.userEmail = params.email
        AppSettings.sharedSettings.fullName = params.fullName
        self.appDelegate.moveToHome()
    }
}
