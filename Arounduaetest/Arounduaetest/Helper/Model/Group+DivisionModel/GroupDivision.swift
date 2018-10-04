
import UIKit

struct GroupData : Decodable {
	let groups : [Groups]?
	let brands : [Brands]?
}

struct Brands : Decodable {
    let title : Title?
    let image : String?
    let isActive : Bool?
    let _id : String?
}

struct Groups : Decodable {
    let title : Title?
    let image : String?
    let isActive : Bool?
    let isFeatured : Bool?
    let _id : String?
}

struct Divisions : Decodable {
    let title : Title?
    let image : String?
    let isActive : Bool?
    let _id : String?
}

struct GroupDivisonData : Decodable {
    let title : Title?
    let divisions : [Divisions]?
    let image : String?
    let isActive : Bool?
    let isFeatured : Bool?
    let _id : String?
}
