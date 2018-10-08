//
//  CellFavourit.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 14/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage

class CellFavourit: UITableViewCell {

    @IBOutlet weak var BtnHeart: UIButton!
    @IBOutlet weak var lblFavouritUserName: UILabel!
    @IBOutlet weak var lblFavouritProduct: UILabel!
    @IBOutlet weak var lblFavouritProductprice: UILabel!
    @IBOutlet weak var imgFavourit: UIImageView!
    @IBOutlet weak var ratingView: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
         lblFavouritUserName.text = nil
         lblFavouritProduct.text = nil
         imgFavourit.image = nil
         ratingView.rating = 0.0
         lblFavouritProductprice.text = nil
    }
    
    func setupCellData(_ product: Products){
        lblFavouritProduct.text = product.productName?.en
        lblFavouritUserName.text = "Denim Series Vavy"
        imgFavourit.sd_addActivityIndicator()
        imgFavourit.sd_setIndicatorStyle(.gray)
        imgFavourit.sd_setImage(with: URL(string: product.images?.first?.path ?? ""))
        lblFavouritProductprice.text = "$\(product.price?.usd ?? 0)"
        ratingView.rating = Double(product.averageRating ?? 0)
    }
    
    @IBAction func heartClick(_ sender: Any){
        
    }
}
