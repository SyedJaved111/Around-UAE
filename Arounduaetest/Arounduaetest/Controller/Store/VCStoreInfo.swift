//
//  VCStoreInfo.swift
//  AroundUAE
//
//  Created by Macbook on 24/09/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Cosmos
import SDWebImage

class VCStoreInfo: UIViewController,IndicatorInfoProvider {
  
    @IBOutlet var lblInstinct: UILabel!
    @IBOutlet var lblAdress: UILabel!
    @IBOutlet var btnSubmitFeedBack: UIButtonMain!
    @IBOutlet var lblWords: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var storeImage: UIImageView!
    var storeid = ""
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo{
        return IndicatorInfo.init(title: "Store Info".localized)
    }

    override func viewDidLoad(){
        super.viewDidLoad()
        if AppSettings.sharedSettings.accountType == "seller"{
            btnSubmitFeedBack.isHidden = true
        }
    }
    
    @IBAction func review(_ sender: Any){
        if AppSettings.sharedSettings.accountType == "buyer"{
            self.performSegue(withIdentifier: "movetopopfromstores", sender: storeid)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "movetopopfromstores"{
            storeid = (sender as? String)!
        }
    }
}
