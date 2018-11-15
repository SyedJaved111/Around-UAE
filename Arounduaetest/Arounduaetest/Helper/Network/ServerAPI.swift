

//
//  NetworkManager.swift
//  BOOSTane
//
//  Created by Mohsin Raza on 30/01/2018.
//  Copyright © 2018 SDSol Technologies. All rights reserved.
//

import Foundation
import Moya

enum ServerAPI {
    
    //Auth API's
    case UserLogin(LoginParams)
    case ForgotPassword(userEmail:String)
    case RegisterUser(RegisterUserParams, userImage:UIImage)
    case EmailVerification(EmailverificationParams)
    case ResendVerification(userEmail: String)
    case ResetPassword(resetPasswordParams)
    
    //Store API's
    case GetStores(pageNo:String)
    case StoreDetail(storeId:String)
    case GetResturants(pageNo:String)
    case StoreReview(StoreReviewParams)
    
    //Profile API's
    case GetUserProfile
    case ChangePassword(changePasswordParams)
    case UpdateProfile(updateProfileParams)
    case UploadImage(userImage:UIImage)
    case RemoveImage
    case AboutPage(AboutPageParams)
    case UserStores(pageNo:String)
    
    //Product API's
    case ProductDetail(productId: String)
    case StoreProducts(pageNo:String, storeId:String)
    case EditProduct(productId: String)
    case DeleteProduct(productId: String)
    case DeleteProductImage(DeleteProductImageParams)
    case SetDefaultProductImage(DeleteProductImageParams)
    case GetStoreSGDS
    case GetFeaturesCharacters(FeaturesAndCharacteristicsParams)
    case MakeProductFavourite(productId:String)
    case GetFavouriteProducts(pageNo:String)
    case ProductReview(ProductReviewParams)
    case SearchProduct(SearchParams)
    
    //Index API's
    case GetSiteSettings
    case GetSliders
    case ContactUs(ContactUSParams)
    case SearchFilter(SearchFilterParams)
    
    //Cart API's
    case GetCartProducts
    case AddProdcutsCart(dict:[String:Any])
    case DeleteProductCart(DeleteProductCartParams)
    case CartQuantityUpdate(CartQuantityUpdateParams)
    case Payment(payerId:String ,billingAddressId: String,shippingAddressId: String)
    
    //Cities & Places
    case GetCities(pageNo:String)
    case CitiesPlaces(CitiesPlacesParams)
    case PlaceDetail(placeId:String)
    case SubmitPlaceReview(SubmitPlaceReviewParams)
    case PlaceReviewsListing(PlaceReviewsListingParams)
    case MakePlaceFavourite(placeId:String)
    case FavouritePlacesList(pageNo:String)
    
    //GDS API's
    case GetGroups
    case GetGroupWithDivision
    case GetGroupsDivision(groupId:String)
    
    //ORDER API's
    case ShowConfirmedShippedCompletedOrders(storeid:String,status:String)
    case ShipOrderProduct(orderDetailid:String,storeid:String)
    case OrderDetail(orderid:String)
    case MakeProductComplete(orderDetailid:String)
    case UpdateBillingShipping(BillingShippingAddressParams)
    
    //Social API's
    case SocialLogin(SocialParams)
    
    //Selfie API's
    case StoreUploadSelfie(StoreUploadSelfieParams)
    case PlaceUploadSelfie(PlaceUploadSelfieParams)
    case GetSelfieList(_ id: String)
    case SetSelfieactive(_ storeid:String, selfieid:String)
    case DeleteGallery(_ storeid:String, selfieid:String)
    
    //Parser API's
    static func parseServerResponse<T>(_ type: T.Type, from data: Data)-> T? where T : Decodable{
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch(let error) {
            print(error.localizedDescription)
            return nil
        }
    }
}

extension ServerAPI: TargetType,AccessTokenAuthorizable {
    
    var headers: [String : String]? {
        return ["Accept": "application/json"]
    }
    
    var baseURL: URL {
        return URL(string: APIURL.mainURL.rawValue)!
    }
    
    var authorizationType: AuthorizationType {
        switch self {
        case .UserLogin,.ForgotPassword,.RegisterUser,
             .EmailVerification,.ResendVerification,
             .ResetPassword,.CitiesPlaces,.SearchProduct,.SocialLogin,
             .SearchFilter:
            return .none
        default:
            return .basic
        }
    }
    
    var path: String {
        switch self {
        case .UserLogin:
            return APIURL.loginURL.rawValue
        case .ForgotPassword:
            return APIURL.forgotpasswordURL.rawValue
        case .RegisterUser:
            return APIURL.registrationURL.rawValue
        case .EmailVerification:
            return APIURL.emailverificationURL.rawValue
        case .ResendVerification:
            return APIURL.resendverificationURL.rawValue
        case .ResetPassword:
            return APIURL.resetPasswordURL.rawValue
        case .SocialLogin:
            return APIURL.socialLoginURL.rawValue
        case .GetStores:
            return APIURL.getStoreURL.rawValue
        case .StoreDetail:
            return APIURL.storeDetailURL.rawValue
        case .GetResturants:
            return APIURL.getResturantsURL.rawValue
        case .GetUserProfile:
            return APIURL.getUserProfileURL.rawValue
        case .ChangePassword:
            return APIURL.changePasswordURL.rawValue
        case .UpdateProfile:
            return APIURL.updateProfileURL.rawValue
        case .UploadImage:
            return APIURL.uploadImageURL.rawValue
        case .RemoveImage:
            return APIURL.removeImageURL.rawValue
        case .AboutPage:
            return APIURL.aboutPageURL.rawValue
        case .UserStores:
            return APIURL.userStoresURL.rawValue
        case .ProductDetail:
            return APIURL.productDetailURL.rawValue
        case .StoreProducts:
            return APIURL.storeProductsURL.rawValue
        case .EditProduct:
            return APIURL.editProductURL.rawValue
        case .DeleteProduct:
            return APIURL.deleteProductURL.rawValue
        case .DeleteProductImage:
            return APIURL.deleteProductImageURL.rawValue
        case .SetDefaultProductImage:
            return APIURL.setDefaultProductImageURL.rawValue
        case .GetStoreSGDS:
            return APIURL.getStoreSGDS.rawValue
        case .GetFeaturesCharacters:
            return APIURL.getFeaturesCharacters.rawValue
        case .GetSiteSettings:
            return APIURL.getSiteSettingsURL.rawValue
        case .GetSliders:
            return APIURL.getSlidersURL.rawValue
        case .ContactUs:
            return APIURL.contactUsURL.rawValue
        case .GetCartProducts:
            return APIURL.getCartProductsURL.rawValue
        case .GetCities:
            return APIURL.getCitiesURL.rawValue
        case .CitiesPlaces:
            return APIURL.citiesPlacesURL.rawValue
        case .PlaceDetail:
            return APIURL.cityPlaceDetailURL.rawValue
        case .SubmitPlaceReview:
            return APIURL.submitPlaceReviewURL.rawValue
        case .PlaceReviewsListing:
            return APIURL.placeReviewListingURL.rawValue
        case .MakePlaceFavourite:
            return APIURL.makePlaceFavouriteURL.rawValue
        case .FavouritePlacesList:
            return APIURL.favouritePlaceListURL.rawValue
        case.GetGroups:
            return APIURL.getGroupsURL.rawValue
        case.GetGroupWithDivision,.GetGroupsDivision:
            return APIURL.getGroupWithDivisionURL.rawValue
        case .MakeProductFavourite:
            return APIURL.makeProductFavouriteURL.rawValue
        case .GetFavouriteProducts:
            return APIURL.getFavouriteProductsURL.rawValue
        case .ProductReview:
            return APIURL.productReviewURL.rawValue
        case .StoreReview:
            return APIURL.storeReviewURL.rawValue
        case .AddProdcutsCart:
            return APIURL.addToCartURL.rawValue
        case .DeleteProductCart:
            return APIURL.deleteCarProductURL.rawValue
        case .CartQuantityUpdate:
            return APIURL.cartQuantityUpdateURL.rawValue
        case .Payment:
            return APIURL.paymentURL.rawValue
        case .SearchProduct:
            return APIURL.searchProductURL.rawValue
        case .SearchFilter:
            return APIURL.filterURL.rawValue
        case .ShowConfirmedShippedCompletedOrders:
            return APIURL.showConfirmedShippedCompletedOrdersURL.rawValue
        case .ShipOrderProduct:
            return APIURL.shipOrderProductURL.rawValue
        case .OrderDetail:
            return APIURL.OrderDetailURL.rawValue
        case .MakeProductComplete:
            return APIURL.MakeProductCompleteURL.rawValue
        case .UpdateBillingShipping:
            return APIURL.UpdateBillingShippingURL.rawValue
        case .StoreUploadSelfie:
            return APIURL.StoreUploadURL.rawValue
        case .PlaceUploadSelfie:
            return APIURL.PlaceUploadURL.rawValue
        case .GetSelfieList:
            return APIURL.GetSelfieURL.rawValue
        case .SetSelfieactive:
            return APIURL.SetSelfieactiveURL.rawValue
        case .DeleteGallery:
            return APIURL.DeleteGalleryURL.rawValue
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .UserLogin,.ForgotPassword,.RegisterUser,
             .EmailVerification,.ResendVerification,
             .ResetPassword,.GetStores,.StoreDetail,.GetResturants,
             .ChangePassword,.UpdateProfile,.UploadImage,
             .AboutPage,.UserStores,.ProductDetail,.StoreProducts,
             .EditProduct,.DeleteProduct,.DeleteProductImage,.ContactUs,
             .SetDefaultProductImage,.GetCities,.CitiesPlaces,.PlaceDetail,
             .SubmitPlaceReview,.PlaceReviewsListing,.MakePlaceFavourite,
             .FavouritePlacesList,.GetGroupsDivision,.MakeProductFavourite,
             .GetFavouriteProducts,.ProductReview,.StoreReview,
             .AddProdcutsCart,.DeleteProductCart,.CartQuantityUpdate,
             .Payment,.SearchProduct,.SocialLogin,.ShowConfirmedShippedCompletedOrders,
             .ShipOrderProduct,.OrderDetail,.MakeProductComplete,.SearchFilter,.GetFeaturesCharacters,
             .UpdateBillingShipping,.StoreUploadSelfie,.PlaceUploadSelfie,.GetSelfieList,.SetSelfieactive,.DeleteGallery:
            return .post
        case .GetUserProfile,.RemoveImage,
             .GetStoreSGDS,.GetSiteSettings,
             .GetSliders,.GetCartProducts,
             .GetGroups,.GetGroupWithDivision:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        var parameters = [String: Any]()
        switch self {
            
        case .UserLogin(let params):
            parameters[LoginKey.USER_EMAIL.rawValue] = params.useremail
            parameters[LoginKey.USER_PASSWORD.rawValue] = params.userpassword
            return parameters
            
        case .ForgotPassword(let email):
            parameters[ForgotpasswordKey.USER_EMAIL.rawValue] = email
            return parameters
            
        case .EmailVerification(let params):
            parameters[EmailverificationKey.EMAIL.rawValue] = params.email
            parameters[EmailverificationKey.VERIFICATION_CODE.rawValue] = params.verificationCode
            return parameters
            
        case .ResendVerification(let email):
            parameters[resendverificationKey.EMAIL.rawValue] = email
            return parameters
            
        case .ResetPassword(let params):
            parameters[resetpasswordKey.EMAIL.rawValue] = params.email
            parameters[resetpasswordKey.VERIFICATION_CODE.rawValue] = params.verificationCode
            parameters[resetpasswordKey.PASSWORD.rawValue] = params.password
            parameters[resetpasswordKey.PASSWORD_CONFIRMATION.rawValue] = params.passwordConfirmation
            return parameters
            
        case .GetStores(let pageno),.GetResturants(let pageno),.GetCities(let pageno),
             .UserStores(let pageno),.FavouritePlacesList(let pageno),.GetFavouriteProducts(let pageno):
            parameters[pageKey.PAGE.rawValue] = pageno
            return parameters
            
        case .StoreDetail(let storeid):
            parameters[storeDetilKey.STORE_ID.rawValue] = storeid
            return parameters
            
        case .ChangePassword(let params):
            parameters[changePasswordKey.OLD_PASSWORD.rawValue] = params.oldPassword
            parameters[changePasswordKey.PASSWORD.rawValue] = params.password
            parameters[changePasswordKey.CONFIRMATION_PASSWORD.rawValue] = params.passwordConfirmation
            return parameters
            
        case .ProductDetail(let productid):
            parameters[ProductDetailKey.PRODUCT_ID.rawValue] = productid
            return parameters
            
        case .StoreProducts(let pageno, let storeid):
            parameters[StoreProductKey.STORE_ID.rawValue] = storeid
            parameters[StoreProductKey.PAGENO.rawValue] = pageno
            return parameters
            
        case .EditProduct(let productid),.DeleteProduct(let productid):
            parameters[EditProductKey.PRODUCT_ID.rawValue] = productid
            return parameters
            
        case .DeleteProductImage(let params),.SetDefaultProductImage(let params):
            parameters[DeleteProductImageKey.PRODUCT_ID.rawValue] = params.productid
            parameters[DeleteProductImageKey.IMAGE_ID.rawValue] = params.imageId
            return parameters
            
        case .ContactUs(let params):
            parameters[ContactUsKey.NAME.rawValue] = params.name
            parameters[ContactUsKey.EMAIL.rawValue] = params.email
            parameters[ContactUsKey.SUBJECT.rawValue] = params.subject
            parameters[ContactUsKey.MESSAGE.rawValue] = params.message
            return parameters
            
        case .GetGroupsDivision(let groupId):
            parameters[GroupKey.GROUP_ID.rawValue] = groupId
            return parameters
            
        case .MakeProductFavourite(let productId):
            parameters[ProductKey.PRODUCT_ID.rawValue] = productId
            return parameters
            
        case .CitiesPlaces(let params):
            parameters[CitiesPlacesKey.CITY_ID.rawValue] = params.cityid
            parameters[CitiesPlacesKey.PAGE.rawValue] = params.page
            if params.latitude != "" && params.longitude != ""{
                parameters[CitiesPlacesKey.LATITUDE.rawValue] = params.latitude
                parameters[CitiesPlacesKey.LONGITUDE.rawValue] = params.longitude
            }
            return parameters
            
        case .MakePlaceFavourite(let placeid),.PlaceDetail(let placeid):
            parameters[PlaceKey.PLACE_ID.rawValue] = placeid
            return parameters
            
        case .SubmitPlaceReview(let params):
            parameters[SubmitPlaceReviewKey.PLACE.rawValue] = params.place
            parameters[SubmitPlaceReviewKey.RATING.rawValue] = params.rating
            parameters[SubmitPlaceReviewKey.COMMENT.rawValue] = params.comment
            return parameters
            
        case .ProductReview(let params):
            parameters[ProductReviewKey.PRODUCT_ID.rawValue] = params.productid
            parameters[ProductReviewKey.RATING.rawValue] = params.rating
            parameters[ProductReviewKey.COMMENT.rawValue] = params.comment
            return parameters
            
        case .StoreReview(let params):
            parameters[StoreReviewKey.STORE.rawValue] = params.store
            parameters[StoreReviewKey.RATING.rawValue] = params.rating
            parameters[StoreReviewKey.COMMENT.rawValue] = params.comment
            return parameters
            
        case .AddProdcutsCart(let params):
            return params
            
        case .Payment(let payerid , let billingid, let shippingid):
            parameters["shippingAddressId"] = shippingid
            parameters["billingAddressId"] = billingid
            parameters[PaymentKey.payerId.rawValue] = payerid
            return parameters
            
        case .SearchProduct(let params):
            parameters[SearchKey.locale.rawValue] = "en"
            if params.maxPrice != -1 {
                parameters[SearchKey.maxPrice.rawValue] = params.maxPrice
            }
            if params.minPrice != -1 {
                parameters[SearchKey.minPrice.rawValue] = params.minPrice
            }
            if params.location.count != 0{
                parameters[SearchKey.location.rawValue] = params.location
            }
            if params.key != ""{
                parameters[SearchKey.key.rawValue] = params.key
            }
            if params.manufacturers != [""]{
                 parameters["manufacturers[0]"] = params.manufacturers
            }
            if params.groups != [""]{
                parameters["groups"] = params.groups
            }
            if params.divisions != [""]{
                parameters["divisions"] = params.divisions
            }
            if params.sections != [""]{
                parameters["sections"] = params.sections
            }
            if params.manufacturers != [""]{
                parameters["characteristics"] = params.characterisrics
            }
            return parameters
            
        case .SocialLogin(let params):
            parameters[SocialKey.id.rawValue] = params.id
            parameters[SocialKey.accessToken.rawValue] = params.accessToken
            parameters[SocialKey.email.rawValue] = params.email
            parameters[SocialKey.authMethod.rawValue] = params.authMethod
            parameters[SocialKey.fullName.rawValue] = params.fullName
            return parameters
            
        case .DeleteProductCart(let params):
            parameters[DeleteProductCartKey.product.rawValue] = params.product
            if params.combination != ""{
                parameters[DeleteProductCartKey.combination.rawValue] = params.combination
            }
            return parameters
            
        case .CartQuantityUpdate(let params):
            parameters[CartQuantityUpdateKey.product.rawValue] = params.product
            parameters[CartQuantityUpdateKey.quantity.rawValue] = params.quantity
            if params.combination != ""{
                parameters[CartQuantityUpdateKey.combination.rawValue] = params.combination
            }
            return parameters
            
        case .ShowConfirmedShippedCompletedOrders(let storeid,let status):
            if storeid != ""{
                parameters["store"] = storeid
            }
            parameters["status"] = status
            return parameters
            
        case .ShipOrderProduct(let orderDetail,let store):
            parameters["orderDetailId"] = orderDetail
            parameters["store"] = store
            return parameters
            
        case .OrderDetail(let orderid):
            parameters["order"] = orderid
            return parameters
            
        case .MakeProductComplete(let orderDetailid):
            parameters["orderDetailId"] = orderDetailid
            return parameters
            
        case .SearchFilter(let params):
            parameters["groupId"] = params.groupid
            parameters["divisionId"] = params.divisionid
            return parameters
            
        case .GetFeaturesCharacters(let params):
            parameters["divisions"] = params.divisions
            parameters["sections"] = params.sections
            return parameters
            
        case .UpdateBillingShipping(let params):
            parameters[UpdateBillingShippingKey.fullName.rawValue] = params.fullname
            parameters[UpdateBillingShippingKey.email.rawValue] = params.email
            parameters[UpdateBillingShippingKey.phone.rawValue] = params.phone
            parameters[UpdateBillingShippingKey.address1.rawValue] = params.addressone
            
            if params.addressthree != ""{
                 parameters[UpdateBillingShippingKey.address3.rawValue] = params.addressthree
            }

            if params.addresstwo != ""{
                 parameters[UpdateBillingShippingKey.address2.rawValue] = params.addresstwo
            }
            
            parameters[UpdateBillingShippingKey.addressType.rawValue] = params.addresstype
            
            return parameters
            
        case .GetSelfieList(let id):
            parameters["id"] = id
            return parameters
            
        case .SetSelfieactive(let storeid, let selfieid):
                parameters["storeId"] = storeid
                parameters["selfieId"] = selfieid
                return parameters
        case .DeleteGallery(let storeid, let selfieid):
            parameters["storeId"] = storeid
            parameters["fileId"] = selfieid
            return parameters
        default:
            return nil
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .UserLogin,.ForgotPassword,.EmailVerification,
             .ResendVerification,.ResetPassword,.GetStores,
             .StoreDetail,.GetResturants,.ChangePassword,
             .UserStores,.ProductDetail,.StoreProducts,.EditProduct,
             .DeleteProduct,.DeleteProductImage,.SetDefaultProductImage,
             .ContactUs,.GetCities,.CitiesPlaces,.PlaceDetail,.SubmitPlaceReview,
             .PlaceReviewsListing,.MakePlaceFavourite,
             .FavouritePlacesList,.GetGroupsDivision,.MakeProductFavourite,
             .GetFavouriteProducts,.ProductReview,.StoreReview,
             .AddProdcutsCart,.DeleteProductCart,.CartQuantityUpdate,
             .Payment,.SearchProduct,.SocialLogin,.ShowConfirmedShippedCompletedOrders,
             .ShipOrderProduct,.OrderDetail,.MakeProductComplete,.SearchFilter,.GetFeaturesCharacters
            ,.UpdateBillingShipping,.GetSelfieList,.SetSelfieactive,.DeleteGallery:
            return .requestParameters(parameters: parameters!, encoding: parameterEncoding)
        case .RegisterUser,.UpdateProfile,.UploadImage,.AboutPage,.StoreUploadSelfie,.PlaceUploadSelfie:
            return .uploadMultipart(multipartBody ?? [])
            
        case .GetUserProfile,.RemoveImage,.GetStoreSGDS,.GetSiteSettings,
             .GetSliders,.GetCartProducts,.GetGroups,.GetGroupWithDivision:
            return .requestPlain
        }
    }
    
    var multipartBody: [MultipartFormData]? {
        switch self {
        case .RegisterUser(let parameters, let userimage):
            let profileImageData = UIImageJPEGRepresentation(userimage, 1.0)!
            var multipartFormDataArray = [MultipartFormData]()
            multipartFormDataArray.append(MultipartFormData(provider: .data((parameters.userfullname).data(using: .utf8)!), name: RegisterUserKey.USER_FULLNAME.rawValue))
            multipartFormDataArray.append(MultipartFormData(provider: .data((parameters.useremail).data(using: .utf8)!), name: RegisterUserKey.USER_EMAIL.rawValue))
            multipartFormDataArray.append(MultipartFormData(provider: .data((parameters.userphoneno).data(using: .utf8)!), name: RegisterUserKey.USER_PHONE.rawValue))
            multipartFormDataArray.append(MultipartFormData(provider: .data((parameters.userpassword).data(using: .utf8)!), name: RegisterUserKey.USER_PASSWORD.rawValue))
            multipartFormDataArray.append(MultipartFormData(provider: .data((parameters.userconfirmpassword).data(using: .utf8)!), name: RegisterUserKey.USER_CONFIRMATION.rawValue))
            multipartFormDataArray.append(MultipartFormData(provider: .data((parameters.useraddress).data(using: .utf8)!), name: RegisterUserKey.USER_ADDRESS.rawValue))
            multipartFormDataArray.append(MultipartFormData(provider: .data((parameters.usergender).data(using: .utf8)!), name: RegisterUserKey.USER_GENDER.rawValue))
            multipartFormDataArray.append(MultipartFormData(provider: .data(profileImageData),
                name: "nic", fileName: "nicimage.png", mimeType: "image/jpeg"))
            
            return multipartFormDataArray
            
        case .UpdateProfile(let parameters):
            var multipartFormDataArray = [MultipartFormData]()
            multipartFormDataArray.append(MultipartFormData(provider: .data((parameters.fullName).data(using: .utf8)!), name: updateProfileKey.FULLNAME.rawValue))
            multipartFormDataArray.append(MultipartFormData(provider: .data((parameters.email).data(using: .utf8)!), name: updateProfileKey.EMAIL.rawValue))
            multipartFormDataArray.append(MultipartFormData(provider: .data((parameters.phone).data(using: .utf8)!), name: updateProfileKey.PHONE.rawValue))
            multipartFormDataArray.append(MultipartFormData(provider: .data((parameters.address).data(using: .utf8)!), name: updateProfileKey.ADDRESS.rawValue))
            multipartFormDataArray.append(MultipartFormData(provider: .data((parameters.gender).data(using: .utf8)!), name: updateProfileKey.GENDER.rawValue))
            
            if let profileImageData = UIImageJPEGRepresentation(parameters.nic, 0.8){
                multipartFormDataArray.append(MultipartFormData(provider: .data(profileImageData),
                name: "nic", fileName: "nicimage.png", mimeType: "image/jpeg"))
            }
            
            return multipartFormDataArray
            
        case .UploadImage(let image):
            let profileImageData = UIImageJPEGRepresentation(image, 1.0)!
            var multipartFormDataArray = [MultipartFormData]()
            multipartFormDataArray.append(MultipartFormData(provider: .data(profileImageData),
            name: "image", fileName: "nicimage.png", mimeType: "image/jpeg"))
            return multipartFormDataArray
            
        case .AboutPage(let parameters):
            let profileImageData = UIImageJPEGRepresentation(parameters.image, 1.0)!
            var multipartFormDataArray = [MultipartFormData]()
            multipartFormDataArray.append(MultipartFormData(provider: .data((parameters.description_en).data(using: .utf8)!), name: AboutPageKey.DESCRIPTION_EN.rawValue))
            multipartFormDataArray.append(MultipartFormData(provider: .data((parameters.description_ar).data(using: .utf8)!), name: AboutPageKey.DESCRIPTION_AR.rawValue))
            multipartFormDataArray.append(MultipartFormData(provider: .data((parameters.id).data(using: .utf8)!), name: AboutPageKey.ID.rawValue))
            multipartFormDataArray.append(MultipartFormData(provider: .data(profileImageData),
            name: "image", fileName: "store.png", mimeType: "image/jpeg"))
            return multipartFormDataArray
            
        case .StoreUploadSelfie(let parameters):
            let profileImageData = parameters.selfieData
            var multipartFormDataArray = [MultipartFormData]()
            multipartFormDataArray.append(MultipartFormData(provider: .data((parameters.caption).data(using: .utf8)!), name: StoreUploadSelfieKey.caption.rawValue))
            multipartFormDataArray.append(MultipartFormData(provider: .data((parameters.storeid).data(using: .utf8)!), name: StoreUploadSelfieKey.storeid.rawValue))
            
            if parameters.mintype == "image"{
                multipartFormDataArray.append(MultipartFormData(provider: .data(profileImageData),
                name: "file", fileName: "store.png", mimeType: "image/jpeg"))
            }else{
                multipartFormDataArray.append(MultipartFormData(provider: .data(profileImageData),
                name: "file", fileName: "upload.mov", mimeType: "video/mov"))
                multipartFormDataArray.append(MultipartFormData(provider: .data(profileImageData),
                name: "thumbnail", fileName:"store.png", mimeType: "image/jpeg"))
            }
           
            return multipartFormDataArray
            
        case .PlaceUploadSelfie(let parameters):
            let profileImageData = parameters.selfieData
            var multipartFormDataArray = [MultipartFormData]()
            multipartFormDataArray.append(MultipartFormData(provider: .data((parameters.caption).data(using: .utf8)!), name: PlaceUploadSelfieKey.caption.rawValue))
            multipartFormDataArray.append(MultipartFormData(provider: .data((parameters.placeId).data(using: .utf8)!), name: PlaceUploadSelfieKey.placeid.rawValue))
            
            if parameters.mintype == "image"{
                multipartFormDataArray.append(MultipartFormData(provider: .data(profileImageData),
                name: "file", fileName: "place.png", mimeType: "image/jpeg"))
            }else{
                multipartFormDataArray.append(MultipartFormData(provider: .data(profileImageData),
                name: "file", fileName: "upload.mov", mimeType: "video/mov"))
                multipartFormDataArray.append(MultipartFormData(provider: .data(profileImageData),
                name: "thumbnail", fileName:"place.png", mimeType: "image/jpeg"))
            }
            
            return multipartFormDataArray
            
        default:
            return nil
        }
    }
}
