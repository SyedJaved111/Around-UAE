//
//  SharedData.swift
//  AroundUAE
//
//  Created by Apple on 19/09/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

class SharedData{
    static let sharedUserInfo = SharedData()
    var index = Index.getDefaultObject()
    var setting = Settings.getDefaultObject()
    var pages = [Pages]()
    var sliders = [Sliders]()
    var placesDataObj:PlacesData!
    var isSocialLogin : Int!
    var socialId : String!
    var socialName : String!
    var socialEmail : String!
}
