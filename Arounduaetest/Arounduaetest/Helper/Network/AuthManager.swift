//
//  AuthManager.swift
//  AroundUAE
//
//  Created by Apple on 18/09/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Moya

class AuthManager{
    
    //MARK: - LOGIN USER
    func loginUser(_ params:LoginParams, successCallback : @escaping (UserModel?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .UserLogin(params),
        success:
        {(response) in
            let someDictionaryFromJSON = try! JSONSerialization.jsonObject(with: response, options: .allowFragments) as! [String: Any]
            let json4Swift_Base = UserModel(dictionary: someDictionaryFromJSON as NSDictionary)
            successCallback(json4Swift_Base)
        },
        failure:
        {(error) in
            failureCallback(error)
        })
    }
    
    //MARK: - REGISTER USER
    func registerUser(_ params:RegisterUserParams, userImage: UIImage, successCallback : @escaping (UserModel?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .RegisterUser(params, userImage: userImage),
        success:
        {(response) in
            let someDictionaryFromJSON = try! JSONSerialization.jsonObject(with: response, options: .allowFragments) as! [String: Any]
            let json4Swift_Base = UserModel(dictionary: someDictionaryFromJSON as NSDictionary)
            successCallback(json4Swift_Base)
        },
        failure:
        {(error) in
            failureCallback(error)
        })
    }
    
    //MARK: - FORGOTPASSWORD USER
    func forgotPassword(_ userEmail:String, successCallback : @escaping (UserModel?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .ForgotPassword(userEmail: userEmail),
        success:
        {(response) in
            let someDictionaryFromJSON = try! JSONSerialization.jsonObject(with: response, options: .allowFragments) as! [String: Any]
            let json4Swift_Base = UserModel(dictionary: someDictionaryFromJSON as NSDictionary)
            successCallback(json4Swift_Base)
        },
        failure:
        {(error) in
            failureCallback(error)
        })
    }
    
    //MARK: - CHANGE PASSWORD USER
    func changePassword(_ params:changePasswordParams, successCallback : @escaping (UserModel?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .ChangePassword(params),
        success:
        {(response) in
            let someDictionaryFromJSON = try! JSONSerialization.jsonObject(with: response, options: .allowFragments) as! [String: Any]
            let json4Swift_Base = UserModel(dictionary: someDictionaryFromJSON as NSDictionary)
            successCallback(json4Swift_Base)
        },
       failure:
        {(error) in
            failureCallback(error)
        })
    }
    
    //MARK: - EMAIL_VERIFICATION USER
    func emailverificationPassword(_ params:EmailverificationParams, successCallback : @escaping (UserModel?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .EmailVerification(params),
        success:
        {(response) in
            let someDictionaryFromJSON = try! JSONSerialization.jsonObject(with: response, options: .allowFragments) as! [String: Any]
            let json4Swift_Base = UserModel(dictionary: someDictionaryFromJSON as NSDictionary)
            successCallback(json4Swift_Base)
        },
        failure:
        {(error) in
            failureCallback(error)
        })
    }
    
    //MARK: - RESEND_VERIFICATION_CODE USER
    func ResendverificationCode(_ userEmail:String, successCallback : @escaping (UserModel?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .ResendVerification(userEmail: userEmail),
        success:
        {(response) in
            let someDictionaryFromJSON = try! JSONSerialization.jsonObject(with: response, options: .allowFragments) as! [String: Any]
            let json4Swift_Base = UserModel(dictionary: someDictionaryFromJSON as NSDictionary)
            successCallback(json4Swift_Base)
        },
        failure:
        {(error) in
            failureCallback(error)
        })
     }
    
     //MARK: - SOCIAL_LOGIN
    func SocialLogin(_ params:SocialParams, successCallback : @escaping (UserModel?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .SocialLogin(params),
        success:
        {(response) in
            let someDictionaryFromJSON = try! JSONSerialization.jsonObject(with: response, options: .allowFragments) as! [String: Any]
            let json4Swift_Base = UserModel(dictionary: someDictionaryFromJSON as NSDictionary)
            successCallback(json4Swift_Base)
        },
        failure:
        {(error) in
            failureCallback(error)
        })
    }
}
