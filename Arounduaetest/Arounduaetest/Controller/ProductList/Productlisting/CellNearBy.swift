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
    @IBOutlet weak var btnFavrouitnearbyImage: UIImageView!
    @IBOutlet weak var imgproductneaby: UIImageView!
    
    override func awakeFromNib() {
        btnFavrouitnearby.makeRound()
        btnFavrouitnearby.layer.borderColor = UIColor.lightGray.cgColor
//        self.layer.borderWidth = 1
//        self.layer.borderColor = UIColor.lightGray.cgColor
//        
        lblpricenearby.text = nil
        uiviewcomosenearby.rating = 0.0
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
        
        if AppSettings.sharedSettings.user.favouritePlaces?.contains((product._id!)) ?? false{
            self.btnFavrouitnearbyImage.image = #imageLiteral(resourceName: "Favourite-red")
            self.btnFavrouitnearby.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }else{
            self.btnFavrouitnearbyImage.image = #imageLiteral(resourceName: "Favourite")
            self.btnFavrouitnearby.backgroundColor = #colorLiteral(red: 0.06314799935, green: 0.04726300389, blue: 0.03047090769, alpha: 1)
        }
    }
    
    @IBAction func btnaddtocartclicknearby(_ sender: Any){
        
    }
    
    @IBAction func btnfavrouitClicknearby(_ sender: Any){
        
    }
}
