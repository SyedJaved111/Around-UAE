//
//  ProfileManager.swift
//  AroundUAE
//
//  Created by Apple on 18/09/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class ProfileManager{
    
    //MARK: - GetUserProfile
    func getUserProfile(successCallback : @escaping (UserModel?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .GetUserProfile,
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
    
    //MARK: - ChangePassword
    func changePassword(_ params:changePasswordParams,successCallback : @escaping (UserModel?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
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
    
    //MARK: - UpdateProfile
    func updateProfile(_ params:updateProfileParams,successCallback : @escaping (UserModel?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .UpdateProfile(params),
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
    
    //MARK: - UploadImage
    func uploadImage(_ image:UIImage,successCallback : @escaping (UserModel?) -> Void,failureCallback : @escaping (NetworkError) -> Void, progressCallBack: @escaping (Double) -> Void){
        NetworkManager.request(target: .UploadImage(userImage: image),
        success:
        {(response) in
            let someDictionaryFromJSON = try! JSONSerialization.jsonObject(with: response, options: .allowFragments) as! [String: Any]
            let json4Swift_Base = UserModel(dictionary: someDictionaryFromJSON as NSDictionary)
            successCallback(json4Swift_Base)
        },
        failure:
        {(error) in
            failureCallback(error)
        }){(progress) in
            progressCallBack(progress)
        }
    }
    
    //MARK: - RemoveImage
    func removeImage(successCallback : @escaping (UserModel?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .RemoveImage,
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
    
    //MARK: - AboutPage
    func aboutPage(_ params:AboutPageParams,successCallback : @escaping (UserModel?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .AboutPage(params),
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
    
    //MARK: - UserStores
    func UserStores(_ pageNo:String,successCallback : @escaping (UserModel?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .UserStores(pageNo: pageNo),
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
