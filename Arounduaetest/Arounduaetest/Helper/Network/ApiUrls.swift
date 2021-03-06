//
//  ApiUrls.swift
//  BOOSTane
//
//  Created by Mohsin Raza on 26/02/2018.
//  Copyright © 2018 SDSol Technologies. All rights reserved.
//

import Foundation

//MARK: - Urls
enum APIURL: String{
    
    case mainURL                   = "http://216.200.116.25/around-uae/api/"
    case loginURL                  = "login"
    case forgotpasswordURL         = "forgot/password"
    case registrationURL           = "register"
    case emailverificationURL      = "email-verification"
    case resendverificationURL     = "resend-verification-code"
    case resetPasswordURL          = "reset/password"
    case facebookURL               = "user/social-login?facebook_id="
    case googleURL                 = "user/social-login?google_id="
    
    case getStoreURL               = "stores"
    case storeDetailURL            = "store/detail"
    case getResturantsURL          = "restaurants"
    case storeReviewURL            = "auth/store/review"
    
    case getUserProfileURL         = "auth/user-profile"
    case changePasswordURL         = "auth/change-password"
    case updateProfileURL          = "auth/update-profile"
    case uploadImageURL            = "auth/upload-image"
    case removeImageURL            = "auth/remove-image"
    case aboutPageURL              = "manage/about-page"
    case userStoresURL             = "auth/user/stores"

    case productDetailURL          = "product/detail"
    case storeProductsURL          = "auth/products"
    
    //skipping right now
    //case addProductURL             = "auth/products/store"
    
    case editProductURL            = "auth/products/edit"
    
    //skipping right now
    //case updateProductURL          = "auth/products/update"
    
    case deleteProductURL          = "auth/products/delete"
    case deleteProductImageURL     = "auth/products/delete/image"
    case setDefaultProductImageURL = "auth/products/default/image"
    case getStoreSGDS              = "auth/products/get/data"
    case getFeaturesCharacters     = "auth/products/get/features/charateristics"
    
    case getSiteSettingsURL        = "settings"
    case getSlidersURL             = "sliders"
    case contactUsURL              = "contact-us"
    
    //skipping right now
    //case addToCartURL            = "auth/cart/add-product"
    case getCartProductsURL        = "auth/cart"
    case getCitiesURL              = "cities"
    case citiesPlacesURL           = "city/places"
    case cityPlaceDetailURL        = "city/place/detail"
    case submitPlaceReviewURL      = "auth/place/review"
    case placeReviewListingURL     = "place/reviews"
    case makePlaceFavouriteURL     = "auth/place/favourite"
    case favouritePlaceListURL     = "auth/place/favourite/list"
    case getGroupsURL              = "groups"
    case getGroupWithDivisionURL   = "groups/divisions"
    case makeProductFavouriteURL   = "product/favourite"
    case getFavouriteProductsURL   = "auth/favourite/products"
    case productReviewURL          = "auth/product/review"
}
