
import Foundation

struct Store : Decodable {
	let stores : [Stores]?
	let pagination : Pagination?
}

struct Resturants : Decodable {
    let restaurants : [Stores]?
    let pagination : Pagination?
}

struct Pagination : Decodable {
    let total : Int?
    let pages : Int?
    let per_page : Int?
    let page : Int?
    let previous : Int?
    let next : Int?
}

struct StoreName : Decodable {
    let en : String?
    let ar : String?
}

struct Stores : Decodable {
    var _id : String?
    let storeName : StoreName?
    let description: Description?
    let image : String?
    let isActive : Bool?
}

struct StoreDetail: Decodable {
    let _id : String?
    let storeName : StoreName?
    let description : Description?
    let reviews : [Reviews]?
    let products : [Products]?
    let location : String?
    let latitude : Double?
    let longitude : Double?
    let image : String?
    let isActive : Bool?
    let averageRating: Double?
    let canReviewUsers: [CanReviewUsers]?
    let selfies : [Selfies]?
    let gallery : [Gallery]?
}

struct Gallery : Decodable {
    let path : String?
    let mimeType : String?
    let createdAt : String?
    let _id : String?
}

struct Selfies : Decodable {
    let path : String?
    let mimeType : String?
    let thumbnail: String?
    let caption : String?
    let createdAt : String?
    let _id : String?
    let user : User?
}

