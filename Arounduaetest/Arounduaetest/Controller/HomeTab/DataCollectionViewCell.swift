//
//  DataCollectionViewCell.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 13/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit

class DataCollectionViewCell: UICollectionViewCell {
   
    @IBOutlet weak var imgProducts: UIImageView!
    @IBOutlet weak var lblProducts: UILabel!
    
    override func awakeFromNib() {
        imgProducts.image = nil
        lblProducts.text = ""
    }
    
    func setupCell(_ divison:Divisions){
        lblProducts.text = divison.title?.en
        imgProducts.setShowActivityIndicator(true)
        imgProducts.setIndicatorStyle(.gray)
        imgProducts.sd_setImage(with: URL(string: divison.image ?? ""))
    }
}
 
