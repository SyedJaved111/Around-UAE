//
//  CartManager.swift
//  AroundUAE
//
//  Created by Apple on 18/09/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

class CartManager{

    //MARK: - GetCartProducts
    func getCartProducts(successCallback : @escaping (Response<[Product]>?) -> Void,
        failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .GetCartProducts,
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<[Product]>.self, from: response){
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

