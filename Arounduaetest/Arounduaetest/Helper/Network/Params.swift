//
//  Params.swift
//  BOOSTane
//
//  Created by Mohsin Raza on 23/02/2018.
//  Copyright © 2018 SDSol Technologies. All rights reserved.
//

import UIKit

//MARK: - Custom Param's
typealias LoginParams = (
    useremail:String,
    userpassword:String
)

typealias RegisterUserParams = (
    userfullname:String,
    useremail: String,
    userphoneno: String,
    userpassword: String,
    userconfirmpassword: String,
    useraddress: String,
    usernic: Data,
    usergender: String
)

typealias EmailverificationParams = (
    email: String,
    verificationCode: String
)

typealias resetPasswordParams = (
    email: String,
    verificationCode: String,
    password: String,
    passwordConfirmation: String
)

typealias changePasswordParams = (
    oldPassword: String,
    password: String,
    passwordConfirmation: String
)

typealias updateProfileParams = (
    fullName:String,
    email:String,
    phone:String,
    address:String,
    gender:String,
    nic:UIImage?
)

typealias AboutPageParams = (
    description_en:String,
    description_ar:String,
    location:String,
    latitude:String,
    longitude:String,
    image:UIImage,
    id:String
)

typealias ContactUSParams = (
    name:String,
    email:String,
    subject:String,
    message:String
)

typealias DeleteProductImageParams = (
    productid:String,
    imageId:String
)

typealias CitiesPlacesParams = (
    cityid:String,
    page:String,
    longitude:String,
    latitude:String
)

typealias SubmitPlaceReviewParams = (
    place:String,
    rating:String,
    comment:String
)

typealias PlaceReviewsListingParams = (
    page:String,
    place:String
)

typealias ProductReviewParams = (
    productid:String,
    rating:String,
    comment:String
)

typealias StoreReviewParams = (
    store:String,
    rating:String,
    comment:String
)

typealias AddCartproductsParams = (
    productid:String,
    quantity:String,
    features:[String],
    characteristics:[String]
)

typealias DeleteProductCartParams = (
    product:String,
    combination:String
)

typealias CartQuantityUpdateParams = (
    quantity:String,
    product:String,
    combination:String
)

