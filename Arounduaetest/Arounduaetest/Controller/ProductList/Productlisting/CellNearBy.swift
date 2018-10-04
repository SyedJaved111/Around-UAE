//
//  CellNearBy.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 03/10/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import Cosmos
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
    }
    
    
    @IBAction func btnaddtocartclicknearby(_ sender: Any) {
    }
    @IBAction func btnfavrouitClicknearby(_ sender: Any) {
    }
    
    
   
}
