//
//  CellNearBy.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 03/10/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage

class CellNearBy: UICollectionViewCell {
    
    @IBOutlet weak var btnaddtocartnearby: UIButtonMain!
    @IBOutlet weak var lblpricenearby: UILabel!
    @IBOutlet weak var uiviewcomosenearby: CosmosView!
    @IBOutlet weak var lblproductBrandnamenearby: UILabel!
    @IBOutlet weak var lblproductnamenearby: UILabel!
    @IBOutlet weak var btnFavrouitnearby: UIButton!
    @IBOutlet weak var imgproductneaby: UIImageView!
    
    override func awakeFromNib() {
        btnFavrouitnearby.makeRound()
        btnFavrouitnearby.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        
        lblpricenearby.text = nil
        uiviewcomosenearby.rating = 0.0
        lblproductBrandnamenearby.text = nil
        lblproductnamenearby.text = nil
        imgproductneaby.image = nil
    }
    
    func setupNearbyData(product:Products){
        lblproductnamenearby.text = product.productName?.en
        uiviewcomosenearby.rating = Double(product.averageRating ?? 0)
        
        imgproductneaby.sd_addActivityIndicator()
        imgproductneaby.sd_setIndicatorStyle(.gray)
        lblpricenearby.text = "$\(product.price?.usd ?? 0)"
        
        imgproductneaby.sd_setImage(with: URL(string: product.images?.first?.path ?? ""))
        if AppSettings.sharedSettings.accountType == "seller"{
            btnFavrouitnearby.isHidden = true
            btnaddtocartnearby.isHidden = true
        }
    }
    
    @IBAction func btnaddtocartclicknearby(_ sender: Any){
        
    }
    
    @IBAction func btnfavrouitClicknearby(_ sender: Any){
        
    }
}
