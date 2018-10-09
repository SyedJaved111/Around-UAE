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
    
    //MARK: - Add Products In Cart
    func addCartProducts(_ params:[String:Any] ,successCallback : @escaping (Response<CombinatonData>?) -> Void,
        failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .AddProdcutsCart(dict: params),
        success:
        {(response) in
            if let parsedResponse = ServerAPI.parseServerResponse(Response<CombinatonData>.self, from: response){
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
    
    //MARK: - Delete Products In Cart
    func deleteCartProducts(_ params:DeleteProductCartParams ,successCallback : @escaping (Response<[Product]>?) -> Void,
        failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .DeleteProductCart(params),
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
    
    //MARK: - Payment In Cart
    func Payment(_ params:PaymentParams ,successCallback : @escaping (Response<[Product]>?) -> Void,
        failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .Payment(params),
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

