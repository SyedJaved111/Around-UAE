//
//  DataCollectionViewCell.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 13/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit

class DataCollectionViewCell: UICollectionViewCell {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    @IBOutlet weak var imgProducts: UIImageView!
    @IBOutlet weak var lblProducts: UILabel!
    
    override func awakeFromNib() {
        imgProducts.image = nil
        lblProducts.text = ""
    }
    
    func setupCell(_ divison:Divisions){
        if(lang == "en")
        {
        lblProducts.text = divison.title?.en
        } else if(lang == "ar")
        {
            lblProducts.text = divison.title?.ar
        }
        imgProducts.setShowActivityIndicator(true)
        imgProducts.setIndicatorStyle(.gray)
        imgProducts.sd_setImage(with: URL(string: divison.image ?? ""))
    }
}
 
