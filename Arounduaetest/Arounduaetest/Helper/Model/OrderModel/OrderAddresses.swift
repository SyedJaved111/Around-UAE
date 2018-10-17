/* 
Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class OrderAddresses {
	public var email : String?
	public var phone : String?
	public var address1 : String?
	public var address2 : String?
	public var address3 : String?
	public var addressType : String?
	public var _id : String?
	public var fullName : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let addresses_list = Addresses.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Addresses Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [OrderAddresses]
    {
        var models:[OrderAddresses] = []
        for item in array
        {
            models.append(OrderAddresses(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let addresses = Addresses(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Addresses Instance.
*/
	required public init?(dictionary: NSDictionary) {

		email = dictionary["email"] as? String
		phone = dictionary["phone"] as? String
		address1 = dictionary["address1"] as? String
		address2 = dictionary["address2"] as? String
		address3 = dictionary["address3"] as? String
		addressType = dictionary["addressType"] as? String
		_id = dictionary["_id"] as? String
		fullName = dictionary["fullName"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.email, forKey: "email")
		dictionary.setValue(self.phone, forKey: "phone")
		dictionary.setValue(self.address1, forKey: "address1")
		dictionary.setValue(self.address2, forKey: "address2")
		dictionary.setValue(self.address3, forKey: "address3")
		dictionary.setValue(self.addressType, forKey: "addressType")
		dictionary.setValue(self._id, forKey: "_id")
		dictionary.setValue(self.fullName, forKey: "fullName")

		return dictionary
	}

}
