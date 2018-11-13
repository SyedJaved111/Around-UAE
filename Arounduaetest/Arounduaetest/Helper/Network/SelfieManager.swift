//
//  SelfieManager.swift
//  Arounduaetest
//
//  Created by Apple on 13/11/2018.
//  Copyright © 2018 MyComedy. All rights reserved.
//

import Foundation

class SelfieManager{
    
    //MARK: - StoreUploadSelfie
    func storeUploadSelfie(_ params:StoreUploadSelfieParams ,successCallback : @escaping (Response<Index>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .StoreUploadSelfie(params),
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<Index>.self, from: response){
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
    
    //MARK: - StoreUploadSelfie
    func placeUploadSelfie(_ params:PlaceUploadSelfieParams ,successCallback : @escaping (Response<Index>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .PlaceUploadSelfie(params),
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<Index>.self, from: response){
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
