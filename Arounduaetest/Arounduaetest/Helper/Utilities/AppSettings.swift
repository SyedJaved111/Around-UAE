
import Foundation
import UIKit

class AppSettings{
    
    static var sharedSettings = AppSettings()
    var user:User = User()
    
    private init(){}
    
    var userPassword:String?{
        set{
            UserDefaults.standard.set(newValue ?? "",forKey:"UserPassword")
            UserDefaults.standard.synchronize()
        }
        get{
          return UserDefaults.standard.string(forKey: "UserPassword")
        }
    }
    
    var userEmail:String?{
        set{
            UserDefaults.standard.set(newValue ?? "",forKey:"UserEmail")
            UserDefaults.standard.synchronize()
        }
        get{
            return UserDefaults.standard.string(forKey: "UserEmail")
        }
    }
    
    var accountType:String?{
        set{
            UserDefaults.standard.set(newValue ?? "",forKey:"AccountType")
            UserDefaults.standard.synchronize()
        }
        get{
            return UserDefaults.standard.string(forKey: "AccountType")
        }
    }
    
    var authToken:String?{
        set{
            UserDefaults.standard.set(newValue ?? "",forKey:"userAuthToken")
            UserDefaults.standard.synchronize()
        }
        get{
            return UserDefaults.standard.string(forKey: "userAuthToken")
        }
    }
    
    var loginMethod:String?{
        set{
            UserDefaults.standard.set(newValue ?? "",forKey:"loginMethod")
            UserDefaults.standard.synchronize()
        }
        get{
            return UserDefaults.standard.string(forKey: "loginMethod")
        }
    }
    
    var isAutoLogin:Bool?{
        set{
            UserDefaults.standard.set(newValue ?? "",forKey:"isAutoLogin")
            UserDefaults.standard.synchronize()
        }
        get{
            return UserDefaults.standard.bool(forKey: "isAutoLogin")
        }
    }
}

