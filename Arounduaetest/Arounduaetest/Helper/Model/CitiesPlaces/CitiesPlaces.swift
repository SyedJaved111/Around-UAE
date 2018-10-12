//
//  CitiesPlaces.swift
//  AroundUAE
//
//  Created by Apple on 28/09/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

struct Cities: Decodable {
    let _id : String?
    let title : Title?
    let image : String?
}

struct CitiesData : Decodable {
    let cities : [Cities]?
    let pagination : Pagination?
}

struct PlacesData : Decodable {
    let places : [Places]?
    let pagination : Pagination?
}

//struct Places : Decodable {
//    let _id : String?
//    let title : Title?
//    let averageRating : Double?
//    let images : [Images]?
//}

struct Places : Decodable {
    let _id : String?
    let about : About?
    let title : Title?
    let description : Description?
    let reviews : [Places_Reviews]?
    let averageRating : Double?
    let address : String?
    let location : [Double]?
    let images : [Images]?
}

struct Places_Reviews : Decodable {
    let _id : String?
    let rating : Int?
    let comment : String?
    let place : String?
    let user : User?
    let createdAt : String?
    let updatedAt : String?
}

struct placeReview : Decodable {
    let rating : Int?
    let comment : String?
    let _id : String?
    let place : String?
    let user : String?
    let createdAt : String?
    let updatedAt : String?
}
