
import Foundation

public class UserModel {
    var success : Bool?
    var message : SomeMessage?
    var data : User?
    var errors : Errors?

    public class func modelsFromDictionaryArray(array:NSArray) -> [UserModel]{
        var models:[UserModel] = []
        for item in array{
            models.append(UserModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }

	required public init?(dictionary: NSDictionary) {
		success = dictionary["success"] as? Bool
		if (dictionary["message"] != nil) { message = SomeMessage(dictionary: dictionary["message"] as! NSDictionary) }
		if (dictionary["data"] != nil) { data = User(dictionary: dictionary["data"] as! NSDictionary) }
	}


	public func dictionaryRepresentation() -> NSDictionary {
		let dictionary = NSMutableDictionary()
		dictionary.setValue(self.success, forKey: "success")
		dictionary.setValue(self.message?.dictionaryRepresentation(), forKey: "message")
		dictionary.setValue(self.data?.dictionaryRepresentation(), forKey: "data")
		return dictionary
    }
}
