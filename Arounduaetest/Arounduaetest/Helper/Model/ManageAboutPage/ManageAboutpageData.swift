
import Foundation

struct ManageAboutpageData : Decodable {
    
	let storeName : StoreName?
	let description : Description?
	let groups : [String]?
	let reviews : [String]?
	let divisions : [String]?
	let sections : [String]?
	let products : [String]?
	let shippingDays : Int?
	let location : String?
	let latitude : Double?
	let longitude : Double?
	let type : String?
	let image : String?
	let onlineSaleable : Bool?
	let isActive : Bool?
	let averageRating : Int?
	let _id : String?
	let user : String?
	let createdAt : String?
	let updatedAt : String?
	let canReviewUsers : [CanReviewUsers]?
}
