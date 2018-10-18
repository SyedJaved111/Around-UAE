//
//  CartCell.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 19/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import SDWebImage

protocol Cartprotocol{
    func tapOnDeleteProduct(cell:CartCell)
    func tapQuantity(cell:CartCell)
}

class CartCell: UITableViewCell {

    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var viewStepper: GMStepperCart!{
        didSet{
            self.delegate?.tapQuantity(cell: self)
        }
    }
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var lblusername: UILabel!
    @IBOutlet weak var lblProductname: UILabel!
    var delegate:Cartprotocol?
    var increaseValue = false
    var decreaseValue = false
    var previousValue = 0.0
    
    override func awakeFromNib() {
        imgProduct.image = nil
        lblProductPrice.text = nil
        lblusername.text = nil
        lblProductname.text = nil
    }
    
    func setupCartCell(_ product:ProductUAE){
        imgProduct.sd_setShowActivityIndicatorView(true)
        imgProduct.sd_setIndicatorStyle(.gray)
        imgProduct.sd_setImage(with: URL(string: product.product?.image ?? ""), placeholderImage: #imageLiteral(resourceName: "Category"))
        lblProductPrice.text = "$\(product.price?.usd ?? 0)"
        lblusername.text = product.product?.productName?.en
        lblProductname.text = product.product?.productName?.en
        viewStepper.value = product.quantity ?? 0.0
        previousValue = product.quantity ?? 0.0
    }
    
    @IBAction func btnCancelClick(_ sender: Any){
        self.delegate?.tapOnDeleteProduct(cell: self)
    }
    
    @IBAction func btnQuantityClick(_ sender: GMStepperCart){
        if sender.tag == 1{
            if sender.value > previousValue {
                increaseValue = true
                decreaseValue = false
            } else {
                increaseValue = false
                decreaseValue = true
            }
            previousValue = sender.value

          self.delegate?.tapQuantity(cell: self)
        }
        sender.tag = 1
    }
}
