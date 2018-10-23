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
    
    @IBOutlet weak var favroitimg: UIImageView!
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
        self.layer.borderWidth = 0.5
        self.layer.borderColor = #colorLiteral(red: 0.8745098039, green: 0.8784313725, blue: 0.8823529412, alpha: 1)
    }
    
    func setupProductCell(product:Products){
        lblProductName.text = product.productName?.en
        ratingView.rating = Double(product.averageRating ?? 0)

        imgProducts.sd_setShowActivityIndicatorView(true)
        imgProducts.sd_setIndicatorStyle(.gray)
        productPrice.text = "$\(product.price?.usd ?? 0)"
        //imgProducts.sd_setImage(with: URL(string: product.images?.first?.path ?? ""), placeholderImage: #imageLiteral(resourceName: "Category"))
        //imgProducts.sd_setImage(with: URL(string: product.images?.first?.path ?? ""))
        if AppSettings.sharedSettings.accountType == "seller"{
           UIButtonFavourite.isHidden = true
           addtocartBtn.isHidden = true
        }
        
        

        if AppSettings.sharedSettings.user.favouritePlaces?.contains((product._id!)) ?? false{
            self.favroitimg.image = #imageLiteral(resourceName: "Favourite-red")
            self.UIButtonFavourite.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.UIButtonFavourite.layer.borderWidth = 0.5
            self.UIButtonFavourite.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }else{
            self.favroitimg.image = #imageLiteral(resourceName: "Favourite-red")
            self.UIButtonFavourite.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.UIButtonFavourite.layer.borderWidth = 0.5
            self.UIButtonFavourite.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
        
//        if AppSettings.sharedSettings.user.favouritePlaces?.contains((product._id!)) ?? false{
//
//            self.UIButtonFavourite.setImage(#imageLiteral(resourceName: "Favourite"), for:.normal)
//        }else{
//            self.UIButtonFavourite.setImage(#imageLiteral(resourceName: "Favourite-red"), for:.normal)
//        }
    }
    
    @IBAction func addToCart(_ sender: UIButton){
        self.delegate?.addToCartTapped(cell: self)
    }
    
    @IBAction func addToFavourite(_ sender: UIButton){
        self.delegate?.favouriteTapped(cell: self)
    }
}
