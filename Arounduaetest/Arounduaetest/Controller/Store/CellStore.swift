//
//  CellStore.swift
//  AroundUAE
//
//  Created by Macbook on 24/09/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import SDWebImage
import Cosmos

protocol storeCellDelegate{
    func favouriteTapped(cell: CellStore)
    func addToCartTapped(cell: CellStore)
}

class CellStore: UICollectionViewCell {
    
    @IBOutlet var UIButtonFavourite: UIButton!
    @IBOutlet var addtocartBtn: UIButton!
    @IBOutlet var imgProducts: UIImageView!
    @IBOutlet var lblProductName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    var delegate: storeCellDelegate?
    
    override func awakeFromNib(){
        imgProducts.image = nil
        lblProductName.text = nil
        productPrice.text = nil
        UIButtonFavourite.makeRound()
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setupProductCell(product:Products){
        lblProductName.text = (lang == "en") ? product.productName?.en : product.productName?.ar
        ratingView.rating = Double(product.averageRating ?? 0)
        addtocartBtn.setTitle( "Add to Cart".localized, for: .normal) 

        imgProducts.sd_setShowActivityIndicatorView(true)
        imgProducts.sd_setIndicatorStyle(.gray)
        productPrice.text = (lang == "en") ? "$\(product.price?.usd ?? 0)" : "$\(product.price?.aed ?? 0)"
        imgProducts.sd_setImage(with: URL(string: product.images?.first?.path ?? ""))
        if AppSettings.sharedSettings.accountType == "seller"{
           UIButtonFavourite.isHidden = true
           addtocartBtn.isHidden = true
        }
        
        if AppSettings.sharedSettings.user.favouritePlaces?.contains((product._id!)) ?? false{
            self.UIButtonFavourite.setImage(#imageLiteral(resourceName: "Favourite"), for:.normal)
        }else{
            self.UIButtonFavourite.setImage(#imageLiteral(resourceName: "Favourite-red"), for:.normal)
        }
    }
    
    @IBAction func addToCart(_ sender: UIButton){
        self.delegate?.addToCartTapped(cell: self)
    }
    
    @IBAction func addToFavourite(_ sender: UIButton){
        self.delegate?.favouriteTapped(cell: self)
    }
}
