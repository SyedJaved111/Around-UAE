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
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo{
        return IndicatorInfo.init(title: "Store Info".localized)
    }

    override func viewDidLoad(){
        super.viewDidLoad()
    }
}
