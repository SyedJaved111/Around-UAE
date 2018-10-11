//
//  CitiesPlacesManager.swift
//  Arounduaetest
//
//  Created by mohsin raza on 23/09/2018.
//  Copyright © 2018 MyComedy. All rights reserved.
//

import Foundation

class CitiesPlacesManager{
    
    //MARK: - GetCities
    func getCities(_ pageno:String,successCallback : @escaping (Response<CitiesData>?) -> Void,
        failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .GetCities(pageNo: pageno),
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<CitiesData>.self, from: response){
                successCallback(parsedResponse)
            }else{
                failureCallback(NetworkManager.networkError)
            }
        },
        failure:
        {(error) in
            failureCallback(error)
        })
    }
    
    //MARK: - GetCitiesPlaces
    func getCitiesPlaces(_ params:CitiesPlacesParams,successCallback : @escaping (Response<PlacesData>?) -> Void,
       failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .CitiesPlaces(params),
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<PlacesData>.self, from: response){
                successCallback(parsedResponse)
            }else{
                failureCallback(NetworkManager.networkError)
            }
        },
        failure:
        {(error) in
            failureCallback(error)
        })
    }
    
    //MARK: - GetFavouritePlacesList
    func getFavouritePlacesList(_ pageno:String ,successCallback : @escaping (Response<PlacesData>?) -> Void,
        failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .FavouritePlacesList(pageNo: pageno),
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<PlacesData>.self, from: response){
                successCallback(parsedResponse)
            }else{
                failureCallback(NetworkManager.networkError)
            }
        },
        failure:
        {(error) in
            failureCallback(error)
        })
    }
    
    //MARK: - MAKE PLACE FAVOURITE
    func makePlaceFavourite(_ placeid:String ,successCallback : @escaping (UserModel?) -> Void,
        failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .MakePlaceFavourite(placeId: placeid),
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
    
    //MARK: - MAKE PLACE FAVOURITE
    func getPlaceDetail(_ placeid:String ,successCallback : @escaping (Response<Places>?) -> Void,
        failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .PlaceDetail(placeId: placeid),
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<Places>.self, from: response){
                successCallback(parsedResponse)
            }else{
                failureCallback(NetworkManager.networkError)
            }
        },
        failure:
        {(error) in
            failureCallback(error)
        })
    }
    
    //MARK: - SubmitPlaceReview
    func submitPlaceReview(_ params:SubmitPlaceReviewParams ,successCallback : @escaping (Response<placeReview>?) -> Void,
        failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .SubmitPlaceReview(params),
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<placeReview>.self, from: response){
                successCallback(parsedResponse)
            }else{
                failureCallback(NetworkManager.networkError)
            }
        },
        failure:
        {(error) in
            failureCallback(error)
        })
    }
}
