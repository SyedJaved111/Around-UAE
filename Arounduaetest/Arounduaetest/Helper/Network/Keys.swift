//
//  Keys.swift
//  BOOSTane
//
//  Created by Mohsin Raza on 23/02/2018.
//  Copyright © 2018 SDSol Technologies. All rights reserved.
//

import Foundation

//MARK: - Auth Key's
enum LoginKey: String{
    case USER_EMAIL       = "email"
    case USER_PASSWORD    = "password"
}

enum ForgotpasswordKey: String{
    case USER_EMAIL  = "email"
}

enum RegisterUserKey: String{
    case USER_FULLNAME = "fullName"
    case USER_EMAIL = "email"
    case USER_PHONE = "phone"
    case USER_PASSWORD = "password"
    case USER_CONFIRMATION = "passwordConfirmation"
    case USER_ADDRESS = "address"
    case USER_NIC = "nic"
    case USER_GENDER = "gender"
}

enum EmailverificationKey: String{
    case EMAIL = "email"
    case VERIFICATION_CODE = "verificationCode"
}

enum resendverificationKey: String{
    case EMAIL = "email"
}

enum resetpasswordKey: String{
    case EMAIL = "email"
    case VERIFICATION_CODE = "verificationCode"
    case PASSWORD = "password"
    case PASSWORD_CONFIRMATION = "passwordConfirmation"
}

//MARK: - Store Key's
enum pageKey: String{
    case PAGE = "page"
}

enum storeDetilKey: String{
    case STORE_ID = "storeId"
}

//MARK: - Profile Key's
enum changePasswordKey:String{
    case OLD_PASSWORD = "oldPassword"
    case PASSWORD = "password"
    case CONFIRMATION_PASSWORD = "passwordConfirmation"
}

enum updateProfileKey:String{
    case FULLNAME = "fullName"
    case EMAIL = "email"
    case PHONE = "phone"
    case ADDRESS = "address"
    case GENDER = "gender"
    case NIC = "nic"
}

enum AboutPageKey:String{
    case DESCRIPTION_EN = "description[en]"
    case DESCRIPTION_AR = "description[ar]"
    case LOCATION = "location"
    case LATITUDE = "latitude"
    case LONGITUDE = "longitude"
    case IMAGE = "image"
    case ID = "id"
}

enum ProductDetailKey:String{
    case PRODUCT_ID = "productId"
}

enum StoreProductKey:String{
    case STORE_ID = "storeid"
    case PAGENO = "page"
}

enum EditProductKey:String{
    case PRODUCT_ID = "id"
}

enum DeleteProductImageKey:String{
    case PRODUCT_ID = "id"
    case IMAGE_ID = "imageId"
}

enum ContactUsKey:String{
    case NAME = "name"
    case EMAIL = "email"
    case SUBJECT = "subject"
    case MESSAGE = "message"
}

enum CitiesPlacesKey:String{
    case CITY_ID = "cityId"
    case PAGE = "page"
    case LONGITUDE = "longitude"
    case LATITUDE = "latitude"
}

enum SubmitPlaceReviewKey:String{
    case PLACE = "place"
    case RATING = "rating"
    case COMMENT = "comment"
}

enum PlaceReviewsListingkey:String{
    case PAGE = "page"
    case PLACE = "place"
}

enum PlaceKey:String{
    case PLACE_ID = "placeId"
}

enum GroupKey:String{
    case GROUP_ID = "groupId"
}

enum ProductKey:String{
    case PRODUCT_ID = "productId"
}

enum ProductReviewKey:String{
    case PRODUCT_ID = "product"
    case RATING = "rating"
    case COMMENT = "comment"
}

enum StoreReviewKey:String{
    case STORE = "store"
    case RATING = "rating"
    case COMMENT = "comment"
}

enum AddToCartKey:String{
    case product = "product"
    case quantity = "quantity"
    case featureszero = "features[0]"
    case characteristicsone = "characteristics[0]"
}

enum DeleteProductCartKey:String{
    case product = "product"
    case combination = "combination"
}

enum CartQuantityUpdateKey:String{
    case quantity = "quantity"
    case product = "product"
    case combination = "combination"
}

enum PaymentKey:String{
    case payerId = "paymentId"
    case token = "token"
}

enum SocialKey:String{
    case id = "id"
    case accessToken = "accessToken"
    case email = "email"
    case authMethod = "authMethod"
    case fullName = "fullName"
}

enum SearchKey:String{
    case locale = "locale"
    case minPrice = "minPrice"
    case maxPrice = "maxPrice"
    case location = "location"
    case key = "keyword"
}


