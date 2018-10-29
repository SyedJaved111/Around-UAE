//
//  ManageProductCellCollectionViewCell.swift
//  Arounduaetest
//
//  Created by Apple on 29/10/2018.
//  Copyright © 2018 MyComedy. All rights reserved.
//

import UIKit

class ManageProductCell: UICollectionViewCell {
    
    @IBOutlet weak var productimage: UIImageView!
    @IBOutlet weak var productname: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    override func awakeFromNib() {
        productname.text = nil
        productPrice.text = nil
        productimage.image = nil
    }
    
    func setupCellData(product:Product){
        
    }
}
