//
//  VCHomeTab.swift
//  AroundUAE
//
//  Created by Macbook on 13/09/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SocketIO
import SwiftyJSON
import MIBadgeButton_Swift

class VCHomeTabs: TTabBarViewController {
    
    var Notificationbtn: MIBadgeButton?
    var Count = ""
    var manager:SocketManager!
    var socket:SocketIOClient!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar()
        self.title = "Around UAE"
        if AppSettings.sharedSettings.user.accountType == "seller"{
            viewControllers?.remove(at: 1)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.rightBarButton()
        setsocketIOS()
    }

    @objc func btnCardClick (_ sender: Any){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCCart") as! VCCart
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func btnSearchClick (_ sender: Any){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCProductFilter") as! VCProductFilter
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func rightBarButton() {
        var btnCard:UIBarButtonItem?
        if AppSettings.sharedSettings.user.accountType == "buyer"{
            let btn1 = UIButton(type: .custom)
            btn1.setImage(UIImage(named: "Cart"), for: .normal)
            btn1.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            btn1.addTarget(self, action: #selector(btnCardClick(_:)), for: .touchUpInside)
            btnCard = UIBarButtonItem(customView: btn1)
        }

        Notificationbtn = MIBadgeButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        Notificationbtn!.setImage(#imageLiteral(resourceName: "Notification-red"), for: .normal)
        if(Count == ""){
            Notificationbtn?.badgeString = nil
        }
        else if (Count == "0"){
            Notificationbtn?.badgeString = nil
        }
        else{
            Notificationbtn?.badgeString = Count
        }
        
        Notificationbtn?.addTarget(self, action:#selector(VCHomeTabs.notification_message), for: UIControlEvents.touchUpInside)
        let notificationItem = UIBarButtonItem(customView: Notificationbtn!)
        Notificationbtn!.badgeEdgeInsets = UIEdgeInsetsMake(4, 0, 0, 0)
        
        
        //self.navigationItem.rightBarButtonItems = [notificationItem]
        
        let btn2 = UIButton(type: .custom)
        btn2.setImage(UIImage(named: "Search"), for: .normal)
        btn2.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        btn2.addTarget(self, action: #selector(btnSearchClick(_:)), for: .touchUpInside)
        let btnSearch = UIBarButtonItem(customView: btn2)
        
        if let btn = btnCard {
            self.navigationItem.setRightBarButtonItems([btnSearch,btn,notificationItem], animated: true)
        }else{
            self.navigationItem.setRightBarButtonItems([btnSearch,notificationItem], animated: true)
        }
    }
    
    @objc func notification_message(_ sender: Any){
        moveToNotificationVC()
    }
    
    private func moveToNotificationVC(){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setsocketIOS(){
        
        
        
        guard let userToken = AppSettings.sharedSettings.authToken else {return}
        
        
        
        
        // let userToken = UserDefaults.standard.value(forKey: "userAuthToken") as? String
        
        let usertoken = [
            "token":  userToken
        ]
        
        let specs: SocketIOClientConfiguration = [
            .forceWebsockets(true),
            .forcePolling(false),
            .path("/around-uae/socket.io"),
            .connectParams(usertoken),
            .log(true)]
        
        
        
        
        self.manager = SocketManager(socketURL: URL(string:  "http://216.200.116.25/around-uae")! , config: specs)
        
        self.socket = manager.defaultSocket
        
        self.manager.defaultSocket.on("connected") {data, ack in
            print(data)
        }
        
        
        self.socket.on("connected") { (data, ack) in
            if let arr = data as? [[String: Any]] {
                if let txt = arr[0]["text"] as? String {
                    print(txt)
                }
            }
        }
        
        self.socket.on("unseenNotifications") { (data, ack) in
            let modified =  (data[0] as AnyObject)
            
            let dictionary = modified as! [String: AnyObject]
            print(dictionary)
            let NotificationCount = NotificationCountModel.init(dictionary: dictionary as NSDictionary)
            
            if (NotificationCount?.success)!{
                self.Count = "\(String(describing: NotificationCount!.data!.unseenNotificationsCount!))"
                self.rightBarButton()
            }
        }
        
        self.socket.on("newNotification") { (data, ack) in
            let modified =  (data[0] as AnyObject)
            
            let dictionary = modified as! [String: AnyObject]
            print(dictionary)
            self.socket.emit("unseenNotifications")
            
        }
   
        self.socket.on(clientEvent: .connect) {data, emitter in
            // handle connected
            
            self.socket.emit("unseenNotifications")
          
        }
        
        self.socket.on(clientEvent: .disconnect, callback: { (data, emitter) in
            //handle diconnect
        })
        
        self.socket.onAny({ (event) in
            //handle event
        })
        
        self.socket.connect()
        // CFRunLoopRun()
        
        // Do any additional setup after loading the view.
        
    }
}
