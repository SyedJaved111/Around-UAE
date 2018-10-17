//
//  Order.swift
//  Arounduaetest
//
//  Created by Apple on 17/10/2018.
//  Copyright © 2018 MyComedy. All rights reserved.
//

import Foundation

struct OrderData : Decodable {
    let _id : String?
    let orderDetails : [SomeOrderDetails]?
    let status : String?
    let charges : Int?
    let orderNumber : String?
    let payerStatus : String?
    let orderStatus : String?
    let firstName : String?
    let lastName : String?
    let payerId : String?
    let payerEmail : String?
    let paymentId : String?
    let state : String?
    let paymentMethod : String?
    let currency : String?
    let transactionDetails : String?
    let user : String?
    let addresses : [Addresses]?
    let createdAt : String?
    let updatedAt : String?
}

struct SomeOrderDetails : Decodable {
    let _id : String?
    let price : Price?
    let total : OrderTotal?
    let quantity : Int?
    let status : String?
    let order : String?
    let product : OrderProduct?
    let store : String?
    let combinationDetail : [CombinationDetail]?
    let images : [String]?
    let createdAt : String?
    let updatedAt : String?
    let image : String?
}

struct OrderTotal : Decodable {
    let usd : Int?
    let aed : Int?
}

struct OrderProduct : Decodable {
    let _id : String?
    let productName : ProductName?
    let store : OrderStore?
}

struct OrderStore : Decodable {
    let _id : String?
    let storeName : StoreName?
    let shippingDays : Int?
    let image : String?
    let averageRating : Int?
}

struct CombinationDetail : Decodable {
    let _id : String?
    let feature : Feature?
    let characteristic : Characteristic?
}

struct Characteristic : Decodable {
    let _id : String?
    let title : Title?
}
