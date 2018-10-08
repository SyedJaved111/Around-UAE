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
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
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
    }
    
    @IBAction func review(_ sender: Any){
        self.performSegue(withIdentifier: "movetopopfromstores", sender: storeid)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "movetopopfromstores"{
            let dvc = segue.destination as! VCPopUp
            dvc.storeid = sender as! String
        }
    }
}
