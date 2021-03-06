
import Foundation

struct Product : Decodable {
	let _id : String?
	let productName : ProductName?
	let description : Description?
	let about : About?
	let reviews : [String]?
	let combinations : [Combinations]?
	let priceables : [Priceables]?
	let images : [Images]?
	let price : Price?
}

struct About : Decodable {
    let en : String?
    let ar : String?
}

struct Characteristics : Decodable {
    let _id : String?
    let title : Title?
}

struct Combinations : Decodable {
    let features : [String]?
    let characteristics : [String]?
    let price : Price?
    let avalaible : Int?
    let _id : String?
    let images : [String]?
}

struct Description : Decodable {
    let en : String?
    let ar : String?
}

struct Feature : Decodable {
    let _id : String?
    let title : Title?
}

struct Images : Decodable {
    let path : String?
}

struct Price : Decodable {
    let usd : Int?
    let aed : Double?
}

struct Priceables : Decodable {
    let characteristics : [Characteristics]?
    let _id : String?
    let feature : Feature?
}

struct ProductName : Decodable {
    let en : String?
    let ar : String?
}

struct Title : Decodable {
    let en : String?
    let ar : String?
}

struct FavouriteProductData : Decodable {
    let products : [Products]?
    let pagination : Pagination?
}

struct Products: Decodable {
    let _id : String?
    let productName : ProductName?
    let averageRating : Int?
    let images : [Images]?
    let price : Price?
}

