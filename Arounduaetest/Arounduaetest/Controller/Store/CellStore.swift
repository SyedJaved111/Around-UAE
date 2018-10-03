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
        lblProductName.text = product.productName?.en
        ratingView.rating = Double(product.averageRating ?? 0)

        imgProducts.setShowActivityIndicator(true)
        imgProducts.setIndicatorStyle(.gray)
        productPrice.text = "$\(product.price?.usd ?? 0)"
        imgProducts.sd_setImage(with: URL(string: product.images?.first?.path ?? ""))
    }
    
    @IBAction func addToCart(_ sender: UIButton){
        self.delegate?.addToCartTapped(cell: self)
    }
    
    @IBAction func addToFavourite(_ sender: UIButton){
        self.delegate?.favouriteTapped(cell: self)
    }
}
