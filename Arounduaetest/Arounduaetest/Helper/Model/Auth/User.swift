
import Foundation

public class User:Decodable{
	 var userType : String?
	 var accountType : String?
	 var stores : [String]?
	 var favouritePlaces :Array<String>?
	 var favouriteProducts :Array<String>?
	 var gender : String?
	 var image : String?
	 var isCartProcessing : Bool?
	 var nic : String?
	 var isActive : Bool?
	 var isEmailVerified : Bool?
	 var _id : String?
	 var fullName : String?
	 var email : String?
	 var phone : String?
	 var address : String?
	 var createdAt : String?
	 var updatedAt : String?
	 var addresses : Array<String>?
	 var authorization : String?

    public class func modelsFromDictionaryArray(array:NSArray) -> [User]
    {
        var models:[User] = []
        for item in array
        {
            models.append(User(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {

		userType = dictionary["userType"] as? String
		accountType = dictionary["accountType"] as? String
		
        if(dictionary["stores"] != nil){
            stores = (dictionary["stores"] as! NSArray) as? Array<String>
        }
        
        if(dictionary["favouritePlaces"] != nil){
            favouritePlaces = (dictionary["favouritePlaces"] as! NSArray) as? Array<String>
        }
       
        if(dictionary["favouriteProducts"] != nil){
            favouriteProducts = (dictionary["favouriteProducts"] as! NSArray) as? Array<String>
        }
        
		gender = dictionary["gender"] as? String
		image = dictionary["image"] as? String
		isCartProcessing = dictionary["isCartProcessing"] as? Bool
		nic = dictionary["nic"] as? String
		isActive = dictionary["isActive"] as? Bool
		isEmailVerified = dictionary["isEmailVerified"] as? Bool
		_id = dictionary["_id"] as? String
		fullName = dictionary["fullName"] as? String
		email = dictionary["email"] as? String
		phone = dictionary["phone"] as? String
		address = dictionary["address"] as? String
		createdAt = dictionary["createdAt"] as? String
		updatedAt = dictionary["updatedAt"] as? String
        authorization = dictionary["authorization"] as? String
	}

	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.userType, forKey: "userType")
		dictionary.setValue(self.accountType, forKey: "accountType")
		dictionary.setValue(self.gender, forKey: "gender")
		dictionary.setValue(self.image, forKey: "image")
		dictionary.setValue(self.isCartProcessing, forKey: "isCartProcessing")
		dictionary.setValue(self.nic, forKey: "nic")
		dictionary.setValue(self.isActive, forKey: "isActive")
		dictionary.setValue(self.isEmailVerified, forKey: "isEmailVerified")
		dictionary.setValue(self._id, forKey: "_id")
		dictionary.setValue(self.fullName, forKey: "fullName")
		dictionary.setValue(self.email, forKey: "email")
		dictionary.setValue(self.phone, forKey: "phone")
		dictionary.setValue(self.address, forKey: "address")
		dictionary.setValue(self.createdAt, forKey: "createdAt")
		dictionary.setValue(self.updatedAt, forKey: "updatedAt")
		dictionary.setValue(self.authorization, forKey: "authorization")

		return dictionary
	}
}
