//
//  StoreManager.swift
//  AroundUAE
//
//  Created by Apple on 18/09/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Moya

class StoreManager{
    
    //MARK: - STORES
    func getStores(_ pageNo:String, successCallback : @escaping (Response<Store>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .GetStores(pageNo: pageNo),
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<Store>.self, from: response){
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
    
    //MARK: - STORE DETAIL
    func getStoreDetail(_ storeID:String, successCallback : @escaping (Response<StoreDetail>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .StoreDetail(storeId: storeID),
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<StoreDetail>.self, from: response){
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
    
    //MARK: - RESTURANTS
    func getResturants(_ pageNo:String, successCallback : @escaping (Response<Resturants>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .GetResturants(pageNo: pageNo),
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<Resturants>.self, from: response){
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
    
    //MARK: - Store Review
    func storeReview(_ params:StoreReviewParams, successCallback : @escaping (Response<Resturants>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .StoreReview(params),
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<Resturants>.self, from: response){
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
