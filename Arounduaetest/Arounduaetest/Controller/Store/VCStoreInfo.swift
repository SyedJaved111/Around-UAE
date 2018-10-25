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
    @IBOutlet weak var submitFeedbackBtn: UIButton!
    var storeid = ""
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo{
        return IndicatorInfo.init(title: "Store Info".localized)
    }

    override func viewDidLoad(){
        super.viewDidLoad()
        submitFeedbackBtn.setTitle("Submit Feedback".localized, for: .normal)
        if AppSettings.sharedSettings.accountType == "seller"{
            btnSubmitFeedBack.isHidden = true
        }
    }
    
    @IBAction func review(_ sender: Any){
        if AppSettings.sharedSettings.accountType == "buyer"{
            moveToPopVC()
        }
    }
    
    private func moveToPopVC(){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCPopUp") as! VCPopUp
        vc.productid = storeid
        self.present(vc, animated: true, completion: nil)
    }
}
