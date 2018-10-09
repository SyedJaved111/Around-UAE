//
//  User.swift
//  AroundUAE
//
//  Created by Apple on 19/09/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

class User : Decodable{
    var userType : String? = nil
    var accountType : String? = nil
    var stores : [String]? = nil
    let favouritePlaces : [String]? = nil
    let favouriteProducts : [String]? = nil
    var gender : String? = nil
    var image : String? = nil
    let isCartProcessing : Bool? = nil
    var nic : String? = nil
    let isActive : Bool? = nil
    var isEmailVerified : Bool? = nil
    let verificationCode : Int? = nil
    let _id : String? = nil
    var fullName : String? = nil
    var email : String? = nil
    var phone : String? = nil
    var password : String? = nil
    var address : String? = nil
    let createdAt : String? = nil
    let updatedAt : String? = nil
    let addresses : [Addresses]? = nil
    var authorization: String? = nil
}

struct Language : Decodable {
    
}

struct Google : Decodable {
    let id : String?
    let accessToken : String?
}

struct Facebook : Decodable {
    let id : String?
    let accessToken : String?
}

class Addresses : Decodable {
    let email : String? = nil
    let phone : String? = nil
    let address1 : String? = nil
    let address2 : String? = nil
    let address3 : String? = nil
    let addressType : String? = nil
    let _id : String? = nil
    let fullName : String? = nil
}
