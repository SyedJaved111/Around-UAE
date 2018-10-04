//
//  CartCell.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 19/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit

protocol Cartprotocol{
    func tapOnDeleteProduct(cell:CartCell)
}

class CartCell: UITableViewCell {

    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var viewStepper: GMStepperCart!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var lblusername: UILabel!
    @IBOutlet weak var lblProductname: UILabel!
    var delegate:Cartprotocol?
    
    @IBAction func btnCancelClick(_ sender: Any){
        self.delegate?.tapOnDeleteProduct(cell: self)
    }
}
