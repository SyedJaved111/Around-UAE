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
//public class OrderDetails {
//    public var _id : String?
//    public var price : SomePrice?
//    public var total : Total?
//    public var quantity : Int?
//    public var status : String?
//    public var order : String?
//    var product : OrderProduct?
//    public var store : String?
//    public var combinationDetail : Array<CombinationDetail>?
//    public var images : Array<String>?
//    public var createdAt : String?
//    public var updatedAt : String?
//    public var image : String?
//
///**
//    Returns an array of models based on given dictionary.
//    
//    Sample usage:
//    let orderDetails_list = OrderDetails.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
//
//    - parameter array:  NSArray from JSON dictionary.
//
//    - returns: Array of OrderDetails Instances.
//*/
//    public class func modelsFromDictionaryArray(array:NSArray) -> [OrderDetails]
//    {
//        var models:[OrderDetails] = []
//        for item in array
//        {
//            models.append(OrderDetails(dictionary: item as! NSDictionary)!)
//        }
//        return models
//    }
//
///**
//    Constructs the object based on the given dictionary.
//    
//    Sample usage:
//    let orderDetails = OrderDetails(someDictionaryFromJSON)
//
//    - parameter dictionary:  NSDictionary from JSON.
//
//    - returns: OrderDetails Instance.
//*/
//    required public init?(dictionary: NSDictionary) {
//
//        _id = dictionary["_id"] as? String
//        if (dictionary["price"] != nil) { price = SomePrice(dictionary: dictionary["price"] as! NSDictionary) }
//        if (dictionary["total"] != nil) { total = Total(dictionary: dictionary["total"] as! NSDictionary) }
//        quantity = dictionary["quantity"] as? Int
//        status = dictionary["status"] as? String
//        order = dictionary["order"] as? String
//        if (dictionary["product"] != nil) { product = OrderProduct(dictionary: dictionary["product"] as! NSDictionary) }
//        store = dictionary["store"] as? String
//        //if (dictionary["combinationDetail"] != nil) { combinationDetail = CombinationDetail.modelsFromDictionaryArray(dictionary["combinationDetail"] as! NSArray) }
//        //if (dictionary["images"] != nil) { images = Images.modelsFromDictionaryArray(dictionary["images"] as! NSArray) }
//        createdAt = dictionary["createdAt"] as? String
//        updatedAt = dictionary["updatedAt"] as? String
//        image = dictionary["image"] as? String
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
//        dictionary.setValue(self.price?.dictionaryRepresentation(), forKey: "price")
//        dictionary.setValue(self.total?.dictionaryRepresentation(), forKey: "total")
//        dictionary.setValue(self.quantity, forKey: "quantity")
//        dictionary.setValue(self.status, forKey: "status")
//        dictionary.setValue(self.order, forKey: "order")
//        dictionary.setValue(self.product?.dictionaryRepresentation(), forKey: "product")
//        dictionary.setValue(self.store, forKey: "store")
//        dictionary.setValue(self.createdAt, forKey: "createdAt")
//        dictionary.setValue(self.updatedAt, forKey: "updatedAt")
//        dictionary.setValue(self.image, forKey: "image")
//
//        return dictionary
//    }
//
//}
