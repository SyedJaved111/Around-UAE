//
//  NotificationVC.swift
//  ValetParking
//
//  Created by Zafar Najmi on 18/08/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import SocketIO
import SwiftyJSON
import SDWebImage
import ObjectMapper
import MIBadgeButton_Swift

class NotificationVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    var manager:SocketManager!
    var socket:SocketIOClient!
    var Notificationbtn: MIBadgeButton?
    var Count = ""
    
    @IBOutlet var notificationsTableView: UITableView!
    var notificationObj = NotificationMain()
    var notificationArray = [NotificationNotifications]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.title = "Notifications"
       
       addBackButton()
//
//        let deleteBtn = UIButton(type: .system)
//        deleteBtn.setImage(#imageLiteral(resourceName: "Delete").withRenderingMode(.alwaysOriginal), for: .normal)
//        deleteBtn.frame = CGRect(x: 0, y:0, width: 30, height: 30)
//        deleteBtn.addTarget(self, action: #selector(removeAll), for: .touchUpInside)
//
//        navigationItem.rightBarButtonItems  = [UIBarButtonItem(customView: deleteBtn)]
        
        
        //self.setNavigationBar()
        //self.addMenu()
       self.startLoading("")
        notificationsTableView.isHidden = true
        setsocketIOS()
        
    }
    
    @objc func removeAll() {
        
        self.removeNotificationAll()
        self.notificationArray.removeAll()
        self.notificationsTableView.reloadData()
    }
    

    @objc func back(_ sender:Any) {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        
       
    }
  

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationDataCell
        
        
        if lang == "ar" {
            cell.notificationTitle.text = notificationArray[indexPath.row].title?.ar
            cell.notificationDescription.text = notificationArray[indexPath.row].description?.ar
        }
        else {
            cell.notificationTitle.text = notificationArray[indexPath.row].title?.en
            cell.notificationDescription.text = notificationArray[indexPath.row].description?.en
            
        }
       
        let imageUrl = notificationArray[indexPath.row].sender?.image
       
        if let url = URL(string: imageUrl ?? "")
        {
            //print(url)
            //cell.imageView?.af_setImage(withURL: url)
            //cell.imageView?
            cell.notificationImage.sd_setImage(with: url, placeholderImage:UIImage(named: "Placeholder-3"))
            
        }
        
        let time = notificationArray[indexPath.row].createdAt
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as! TimeZone
        let date = dateFormatter.date(from: time!)
        
        
        
        
        let outputFormatter =  DateFormatter()
        //outputFormatter.dateFormat = "yyyy-MM-dd"
        outputFormatter.dateFormat = "hh:mm a"
        let resultString = outputFormatter.string(from: date!)
       
        cell.timeLbl.text =  resultString
        
        cell.delteNotificationBtn.tag = indexPath.row
        cell.delteNotificationBtn.addTarget(self, action: #selector(myButtonMethod(_:)), for: .touchUpInside)
        
        return cell
        
    }
    
  @objc func myButtonMethod(_ sender : UIButton!) {
    
       print(sender.tag)
    
    self.removeNotification(i: sender.tag)
    
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
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
        
        self.socket.on("notificationsList") { (data, ack) in
            
            self.finishLoading()
            self.notificationsTableView.isHidden = false
            let modified =  (data[0] as AnyObject)

         
            let swiftY = JSON(modified)
            print(swiftY["success"].stringValue)
            if let user = Mapper<NotificationMain>().map(JSONObject:modified) {
                print(user.message)
                
               self.notificationObj = user
                self.notificationArray = (self.notificationObj?.data?.notifications)!
                self.seenArray()
                print(self.notificationArray.count)
                //return
            }
            self.notificationsTableView.delegate = self
            self.notificationsTableView.dataSource = self
            
            self.notificationsTableView.reloadData()
            
        }
        
        self.socket.on(clientEvent: .connect) {data, emitter in
           
            self.socket.emit("notificationsList")
           
        }
        
        self.socket.on("newNotification") { (data, ack) in
           
            self.socket.emit("notificationsList")
        }
        
        self.socket.on("removeNotifications") { (data, ack) in
            let modified =  (data[0] as AnyObject)
            
             let dictionary = modified as! [String: AnyObject]
            print(dictionary)
        }
        
        self.socket.on("notificationsChanged") { (data, ack) in
           
            self.socket.emit("notificationsList")
        
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
    
    func seenArray() {
        var SeenArr = [String]()
        for i in 0 ..< self.notificationArray.count {
            let seenData = self.notificationArray[i]
            print(seenData.seen!)
            if(seenData.seen!){
                
            }
            else{
                SeenArr.append(seenData._id!)
            }
        }
        
        
        let json2 = [
            "notifications": SeenArr
        ]
        
        if(SeenArr.isEmpty){
            
        }else{
            self.socket.emit("notificationsSeen", with: [json2])
            
        }
        
    }
    
    func removeNotification(i:Int) {
        var SeenArr = [String]()
            let seenData = self.notificationArray[i]
            print(seenData.seen!)
        
                SeenArr.append(seenData._id!)
        
            
        
        
        
        let json2 = [
            "notifications": SeenArr
        ]
        
        if(SeenArr.isEmpty){
            
        }else{
            
            self.socket.emit("removeNotifications", with: [json2])
            self.notificationArray.remove(at:i)
            self.notificationsTableView.reloadData()
            
        }
        
    }
    
    func removeNotificationAll() {
        var SeenArr = [String]()
        //let seenData = self.notificationArray[i]
//        print(seenData.seen!)
//
//        SeenArr.append(seenData._id!)
        print(self.notificationArray.count)
        for i in 0 ..< self.notificationArray.count {
            let seenData = self.notificationArray[i]
            print(seenData.seen!)
           
                SeenArr.append(seenData._id!)
            
            
        }
        
        
        
        let json2 = [
            "notifications": SeenArr
        ]
        print(json2)
        if(SeenArr.isEmpty){
            
        }else{
            self.socket.emit("removeNotifications", with: [json2])
            
        }
        
    }
    
   
}