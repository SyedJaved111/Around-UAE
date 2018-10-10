//
//  ConversationViewController.swift
//  HelloStream
//
//  Created by iOSDev on 6/21/18.
//  Copyright © 2018 iOSDev. All rights reserved.
//

import UIKit
import SocketIO
import Starscream
import NVActivityIndicatorView

class ConversationViewController: UIViewController,NVActivityIndicatorViewable {

    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    //   var followersArr = [FollowersArray]()
    let user = SharedData.sharedUserInfo
    
    var conversationArray = [Conversations]()
    var Page = 1
    var TotalPage = 0;
    var ObjPage = 0;
    var fetchingMore = false
    
    var manager:SocketManager!
    var socket:SocketIOClient!
    
    
    override func viewDidLoad()  {
        super.viewDidLoad()

        //self.title = "Conversation".localized
        setGesture()
        
        // Do any additional setup after loading the view.
        if lang == "ar" {
            showArabicBackButton()
            
        }else if lang == "en" {
            addBackButton()
        }
        
        self.showLoader()
        hitConversation()
        
    }
    @IBOutlet var conversationTableView: UITableView!{
        didSet {
            conversationTableView.delegate = self
            conversationTableView.dataSource = self
            conversationTableView.separatorStyle = .none
        }
    }
   
    func hitConversation(){
        
        
        
        if let userToken = AppSettings.sharedSettings.authToken {
            
            let usertoken = [
                "token":  userToken
            ]
            
            let specs: SocketIOClientConfiguration = [
                .forcePolling(false),
                .forceWebsockets(true),
                .path("/around-uae/socket.io"),
                .connectParams(usertoken),
                .log(true)
            ]
            
       
            
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
            
            self.socket.on("conversationsList") { (data, ack) in
                let modified =  (data[0] as AnyObject)
                
                let dictionary = modified as! [String: AnyObject]
                
                print(dictionary)
                
                let Conversation = ConversationModel.init(dictionary: dictionary as NSDictionary)
                
               
                self.conversationArray += (Conversation?.data?.conversations!)!
                self.TotalPage = (Conversation?.data?.pagination?.pages!)!
                print(self.TotalPage)
                self.ObjPage =  (Conversation?.data?.pagination?.page!)!
                self.fetchingMore = false
                
                // self.conversationArray =  self.conversationArray
                if ( self.conversationArray.isEmpty){
                  
                }
                
                self.conversationTableView.delegate = self
                self.conversationTableView.dataSource = self
                
                self.conversationTableView.reloadData()
                
                
                self.finishLoading()
                
            }
            
            self.socket.on("lastMessage") { (data, ack) in
                let modified =  (data[0] as AnyObject)
                
                let dictionary = modified as! [String: AnyObject]
                 self.conversationArray.removeAll()
                self.Page = 1
                print(dictionary)
                let conversationsList = [
                    
                    "page": self.Page
                    
                    ] as [String : Any]
                
                self.socket.emit("conversationsList", with: [conversationsList])
                
            }
            
           
            self.socket.on(clientEvent: .connect) {data, emitter in
                // handle connected
                self.conversationArray.removeAll()
                let conversationsList = [
                    
                    "page": self.Page
                    
                    ] as [String : Any]
                
                self.socket.emit("conversationsList", with: [conversationsList])
             
                
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
    func showLoader(){
      startLoading("")
    }
    
    
    func getTimeFromTimeStamp(timeStamp : Double) -> String
    {
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        let currentDate = Date()
        let second = currentDate.secondsInBetweenDate(date)
        let minutes : Int = Int(second/60)
        let hours : Int = Int(second/3600)
        let days  : Int = Int(second/(3600 * 24))
        
        if (days > 0 && days < 31)
        {
            return String(days) + " days ago"
        }
        
        if(hours > 0 && hours < 25)
        {
            return String(hours) + " hours ago"
        }
        if(minutes > 0 && minutes < 60)
        {
            return String(minutes) + " minutes ago"
        }
        
        if(second > 5 && second < 60)
        {
            let sec : Int = Int(round(second))
            return String(sec) + " second ago"
        }
        if(second <= 5)
        {
            return "just now".localized;
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: date)
    }
    func getDiffernce(toTime:Date) -> Int{
        let elapsed = NSDate().timeIntervalSince(toTime)
        return Int(elapsed * 1000)
    }
}

extension ConversationViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.conversationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.conversationTableView.dequeueReusableCell(withIdentifier: "ConversationTableViewCell", for: indexPath) as! ConversationTableViewCell
        let conversationData = conversationArray[indexPath.row]
     
        if(AppSettings.sharedSettings.accountType ==  "buyer"){
                if let imgUrl = URL(string: (conversationData.store?.image ?? "")) {
                    print(imgUrl)
                    cell.imageConversation.sd_setImage(with: imgUrl, placeholderImage:UIImage(named: "Placeholder-3"))
                    cell.imageConversation.makeRound()
                }
        
            cell.lblName.text = conversationData.store?.storeName?.en
        }
        else{
            if let imgUrl = URL(string: (conversationData.user?.image ?? "")) {
                print(imgUrl)
                cell.imageConversation.sd_setImage(with: imgUrl, placeholderImage:UIImage(named: "Placeholder-3"))
                cell.imageConversation.makeRound()
            }
            
            cell.lblName.text = conversationData.user?.fullName
        }
        let  mimeType =  conversationData.lastMessage?.mimeType!
        
        if(mimeType=="text"){
            cell.lbltext.text = conversationData.lastMessage?.content!
        }
        else{
            cell.lbltext.text = "file"
        }
//             cell.settingItemImg.image = self.imgArr[indexPath.row]
//             cell.settingItemLbl.text = self.nameArr[indexPath.row]
        if let time = conversationData.lastMessage?.createdAt! {

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone

            let date = dateFormatter.date(from: time)
            print(date!)
          
            let millieseconds = date!.timeIntervalSince1970 

            
            print(millieseconds)
            
         
            cell.lblTime.text =  self.getTimeFromTimeStamp(timeStamp: Double(millieseconds))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let conversationData = conversationArray[indexPath.row]
        //
              self.user.conversationID  = (conversationData._id)!
        self.user.conversationTableId = indexPath.row
           performSegue(withIdentifier: "goTochat", sender: nil)
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetY = scrollView.contentOffset.y
        let contentHieght = scrollView.contentSize.height
        
        if offSetY > contentHieght - scrollView.frame.height {
            if !fetchingMore
            {
                beginBatchFetch()
            }
            
        }
        
        
    }
    
    func beginBatchFetch() {
        fetchingMore = true
        
        print(self.ObjPage)
        print(self.TotalPage)
        
        if (self.ObjPage) < (self.TotalPage) {
            self.showLoader()
            Page += 1
            let conversationsList = [
              
                "page": Page
                
                ] as [String : Any]
            
            self.socket.emit("conversationsList", with: [conversationsList])
            
            
            
        }
        
    }
}
