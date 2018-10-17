//
//  OrderManager.swift
//  Arounduaetest
//
//  Created by Apple on 17/10/2018.
//  Copyright © 2018 MyComedy. All rights reserved.
//

import UIKit
import Moya

class OrderManager{
    
    //MARK: - OrderDetail
    func orderDetail(_ orderid:String, successCallback : @escaping (Response<Store>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .OrderDetail(orderid: orderid),
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
    
    //MARK: - ShipOrderDetail
    func ShipOrderDetail(_ orderDetailid:String,storeid:String, successCallback : @escaping (Response<Store>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .ShipOrderProduct(orderDetailid: orderDetailid, storeid: storeid),
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
    
    //MARK: - ShowConfiremed/Shipped/completed Order
    func ShowAllCompleted(_ storeid:String,status:String, successCallback : @escaping (Response<[OrderData]>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .ShowConfirmedShippedCompletedOrders(storeid: storeid, status: status),
        success:
        {(response) in
            print(response)
            let someDictionaryFromJSON = try! JSONSerialization.jsonObject(with: response, options: .allowFragments) as! [String: Any]
            print(someDictionaryFromJSON)
//               let dictionary = someDictionaryFromJSON as! [String: AnyObject]
//            let objUserr = OrderMain.init(dictionary: dictionary as NSDictionary)
//               print(objUserr?.data?._id)
            
            
            //
            //let json4Swift_Base = OrderMain(dictionary: someDictionaryFromJSON as NSDictionary)
        //    successCallback(objUserr)
            if let parsedResponse = ServerAPI.parseServerResponse(Response<[OrderData]>.self, from: response){
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
    
    //MARK: - MakeProductComplete
    func MakeProductComplete(_ orderDetailid:String, successCallback : @escaping (Response<Store>?) -> Void,failureCallback : @escaping (NetworkError) -> Void){
        NetworkManager.request(target: .MakeProductComplete(orderDetailid: orderDetailid),
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
}
