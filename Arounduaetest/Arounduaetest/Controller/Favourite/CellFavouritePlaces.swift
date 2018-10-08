//
//  CellFavouritePlaces.swift
//  AroundUAE
//
//  Created by Macbook on 28/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage

class CellFavouritePlaces: UITableViewCell {

    @IBOutlet weak var BtnHeart: UIButton!
    @IBOutlet weak var lblFavouritUserName: UILabel!
    @IBOutlet weak var lblFavouritProduct: UILabel!
    @IBOutlet weak var imgFavourit: UIImageView!
    @IBOutlet weak var lblFavouritProductprice: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblFavouritUserName.text = nil
        lblFavouritProduct.text = nil
        imgFavourit.image = nil
        ratingView.rating = 0.0
        lblFavouritProductprice.text = nil
    }
    
    func setupCellData(_ place: Places){
        lblFavouritProduct.text = place.title?.en
        lblFavouritUserName.text = "Denim Series Vavy"
        ratingView.rating = Double(place.averageRating ?? 0)
        imgFavourit.sd_addActivityIndicator()
        imgFavourit.sd_setIndicatorStyle(.gray)
        imgFavourit.sd_setImage(with: URL(string: place.images?.first?.path ?? ""))
    }
    
    @IBAction func heartClick(_ sender: Any){
        
    }
}
