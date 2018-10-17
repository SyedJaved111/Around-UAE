///* 
//Copyright (c) 2018 Swift Models Generated from JSON powered by http://www.json4swift.com
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//*/
//
//import Foundation
// 
///* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */
//
//public class OrderStore {
//    public var _id : String?
//    public var storeName : OrderStoreName?
//    public var shippingDays : Int?
//    public var image : String?
//    public var averageRating : Int?
///**
//    Returns an array of models based on given dictionary.
//    
//    Sample usage:
//    let store_list = Store.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
//
//    - parameter array:  NSArray from JSON dictionary.
//
//    - returns: Array of Store Instances.
//*/
//    public class func modelsFromDictionaryArray(array:NSArray) -> [OrderStore]
//    {
//        var models:[OrderStore] = []
//        for item in array
//        {
//            models.append(OrderStore(dictionary: item as! NSDictionary)!)
//        }
//        return models
//    }
//
///**
//    Constructs the object based on the given dictionary.
//    
//    Sample usage:
//    let store = Store(someDictionaryFromJSON)
//
//    - parameter dictionary:  NSDictionary from JSON.
//
//    - returns: Store Instance.
//*/
//    required public init?(dictionary: NSDictionary) {
//
//        _id = dictionary["_id"] as? String
//        if (dictionary["storeName"] != nil) { storeName = OrderStoreName(dictionary: dictionary["storeName"] as! NSDictionary) }
//        shippingDays = dictionary["shippingDays"] as? Int
//        image = dictionary["image"] as? String
//        averageRating = dictionary["averageRating"] as? Int
//    }
//
//        
///**
//    Returns the dictionary representation for the current instance.
//    
//    - returns: NSDictionary.
//*/
//    public func dictionaryRepresentation() -> NSDictionary {
//
//        let dictionary = NSMutableDictionary()
//
//        dictionary.setValue(self._id, forKey: "_id")
//        dictionary.setValue(self.storeName?.dictionaryRepresentation(), forKey: "storeName")
//        dictionary.setValue(self.shippingDays, forKey: "shippingDays")
//        dictionary.setValue(self.image, forKey: "image")
//        dictionary.setValue(self.averageRating, forKey: "averageRating")
//
//        return dictionary
//    }
//
//}
