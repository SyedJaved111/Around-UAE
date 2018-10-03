//
//  CellCategories.swift
//  AroundUAE
//
//  Created by Macbook on 14/09/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import SDWebImage

class CellCategories: UICollectionViewCell {
    
    @IBOutlet var imgCategory: UIImageView!
    @IBOutlet var lblCategory: UILabel!
    
    override func awakeFromNib() {
        imgCategory.image = nil
        lblCategory.text = ""
    }
    
    func setupCell(_ group:Groups, groupImage:UIImage?){
        lblCategory.text = group.title?.en
        if let Image = groupImage {
            imgCategory.image = Image
        }else{

            imgCategory.setShowActivityIndicator(true)
            imgCategory.setIndicatorStyle(.gray)
            imgCategory.sd_setImage(with: URL(string: group.image ?? ""))
        }
    }
}
