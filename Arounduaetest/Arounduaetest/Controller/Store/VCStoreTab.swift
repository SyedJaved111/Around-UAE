//
//  VCStoreTab.swift
//  AroundUAE
//
//  Created by Macbook on 24/09/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SocketIO
import SwiftyJSON
import MIBadgeButton_Swift

class VCStoreTab: ButtonBarPagerTabStripViewController {

    @IBOutlet weak var viewEmptyList: UIView!
    @IBOutlet weak var lblEmpty: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet var collectionViewPager: ButtonBarView!
    let user = SharedData.sharedUserInfo
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    var storeid = ""
    var child_1 = UIStoryboard(name: "HomeTabs", bundle: nil).instantiateViewController(withIdentifier: "VCStoreInfo")
    var child_2 = UIStoryboard(name: "HomeTabs", bundle: nil).instantiateViewController(withIdentifier: "VCStoreProducts")

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo{
        return IndicatorInfo.init(title: "Store Info".localized)
    }
    
    override func viewDidLoad() {
        
        settings.style.buttonBarBackgroundColor = UIColor.red
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = #colorLiteral(red: 0.9607843137, green: 0.003921568627, blue: 0.2039215686, alpha: 1)
        
        settings.style.buttonBarItemFont = UIFont(name: "Raleway-Medium", size: 15)!
        settings.style.selectedBarHeight = 4
        settings.style.buttonBarMinimumLineSpacing = 0.4
        settings.style.buttonBarItemTitleColor = .red
        settings.style.selectedBarBackgroundColor = UIColor.red
        settings.style.buttonBarBackgroundColor = #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1);        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = {(oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = #colorLiteral(red: 0.2549019608, green: 0.2549019608, blue: 0.2549019608, alpha: 1)
            newCell?.label.textColor = #colorLiteral(red: 0.3019607843, green: 0.3019607843, blue: 0.3019607843, alpha: 1)
        }
        
        collectionViewPager.layer.borderWidth = 1
        collectionViewPager.layer.borderColor = UIColor.init(red: 247, green: 247, blue: 247, alpha: 1).cgColor
        super.viewDidLoad()
        //fetchProductInfo(storeid, isRefresh: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
        self.setNavigationBar()
        if(lang == "ar"){
            showArabicBackButton()
        }else{
            self.addBackButton()
        }
        addChatButton()
        self.title = "Stores".localized
        lblEmpty.text = "Empty List".localized
        lblMessage.text = "Sorry there no data is available refresh it or try it later ".localized
    }
    
    func addChatButton(backImage: UIImage = #imageLiteral(resourceName: "Chat-1")) {
        let chatButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(onChatButtonClciked))
        navigationItem.rightBarButtonItem  = chatButton
    }
    
    @objc func onChatButtonClciked() {
       self.user.conversationuserID  = storeid
//        if AppSettings.sharedSettings.accountType == "seller"{
//            self.user.conversationIDImage = conversationData.user?.image ?? ""
//        }else{
//            self.user.conversationIDImage = conversationData.store?.image ?? ""
//        }
       self.performSegue(withIdentifier: "storeChat")
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let objinfo = child_1 as! VCStoreInfo
        objinfo.storeid = storeid
        let objproducts = child_2 as! VCStoreProducts
        objproducts.storeidProducts = storeid
        return [objinfo, objproducts]
    }

    @IBAction func tryAgain(_ sender: UIButton){
        self.viewEmptyList.isHidden = true
        //fetchProductInfo(storeid, isRefresh: false)
    }
}
