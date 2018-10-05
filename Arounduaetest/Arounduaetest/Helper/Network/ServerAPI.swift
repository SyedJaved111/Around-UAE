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
    
    //Social API's
    case checkIsSocialLogin(check:Int ,SocialId:String)
    
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
    case GetFeaturesCharacters
    case MakeProductFavourite(productId:String)
    case GetFavouriteProducts(pageNo:String)
    case ProductReview(ProductReviewParams)
    case SearchProduct(searchtxt:String)
    
    //Index API's
    case GetSiteSettings
    case GetSliders
    case ContactUs(ContactUSParams)
    
    //Cart API's
    case GetCartProducts
    case AddProdcutsCart([String:Any])
    case DeleteProductCart(DeleteProductCartParams)
    case CartQuantityUpdate(CartQuantityUpdateParams)
    case Payment(PaymentParams)
    
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

    //Parser API's
    static func parseServerResponse<T>(_ type: T.Type, from data: Data)-> T? where T : Decodable{
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
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
             .ResetPassword,.CitiesPlaces,.SearchProduct:
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
            case .checkIsSocialLogin(let check, let id):
                switch check{
                    case 0:
                        return APIURL.facebookURL.rawValue + id
                    case 1:
                        return APIURL.googleURL.rawValue + id
                    default:
                        return ""
                }
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
               .Payment,.SearchProduct:
                return .post
          case .checkIsSocialLogin,.GetUserProfile,.RemoveImage,
               .GetStoreSGDS,.GetFeaturesCharacters,.GetSiteSettings,
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
            
            case .Payment(let params):
                parameters[PaymentKey.payerId.rawValue] = params.payerId
                parameters[PaymentKey.token.rawValue] = params.token
                return parameters
            
            case .SearchProduct(let searchTxt):
                parameters["locale"] = searchTxt
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
               .Payment,.SearchProduct:
            return .requestParameters(parameters: parameters!, encoding: parameterEncoding)
            
          case .RegisterUser,.UpdateProfile,.UploadImage,.AboutPage:
            return .uploadMultipart(multipartBody ?? [])
            
          case .checkIsSocialLogin,.GetUserProfile,.RemoveImage,
               .GetFeaturesCharacters,.GetStoreSGDS,.GetSiteSettings,
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
            
            if let image = parameters.nic,let profileImageData = UIImageJPEGRepresentation(image, 0.8){
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
        multipartFormDataArray.append(MultipartFormData(provider: .data((parameters.location).data(using: .utf8)!), name: AboutPageKey.LOCATION.rawValue))
        multipartFormDataArray.append(MultipartFormData(provider: .data((parameters.latitude).data(using: .utf8)!), name: AboutPageKey.LATITUDE.rawValue))
        multipartFormDataArray.append(MultipartFormData(provider: .data((parameters.longitude).data(using: .utf8)!), name: AboutPageKey.LONGITUDE.rawValue))
        multipartFormDataArray.append(MultipartFormData(provider: .data((parameters.id).data(using: .utf8)!), name: AboutPageKey.ID.rawValue))
        multipartFormDataArray.append(MultipartFormData(provider: .data(profileImageData),
            name: "image", fileName: "nicimage.png", mimeType: "image/jpeg"))
            
            return multipartFormDataArray
            
        default:
            return nil
        }
    }
}

