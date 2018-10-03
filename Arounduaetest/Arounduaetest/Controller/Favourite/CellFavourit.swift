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
    @IBOutlet weak var imgFavourit: UIImageView!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblFavouritUserName.text = nil
        lblFavouritProduct.text = nil
        imgFavourit.image = nil
    }
    
    func setupFavouriteCell(product:Product){
        imgFavourit.setShowActivityIndicator(true)
        imgFavourit.setIndicatorStyle(.gray)
        imgFavourit.sd_setImage(with: URL(string: product.images?.first?.path ?? ""))
        lblProductPrice.text = "$\(product.price?.usd ?? 0)"
        lblFavouritProduct.text = product.productName?.en ?? ""
        lblFavouritUserName.text = product.description?.en ?? ""
    }

    @IBAction func heartClick(_ sender: Any){
        
    }
}
