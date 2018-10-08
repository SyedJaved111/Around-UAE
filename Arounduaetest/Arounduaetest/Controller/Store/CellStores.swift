//
//  CellStores.swift
//  AroundUAE
//
//  Created by Macbook on 17/09/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import SDWebImage

class CellStores: UICollectionViewCell {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    @IBOutlet var imgStores: UIImageView!
    @IBOutlet var lblStore: UILabel!
    
    override func awakeFromNib() {
        imgStores.image = nil
        lblStore.text = nil
    }
    
    func setupStoreCell(_ store: Stores){
        if(lang == "en")
        {
        lblStore.text = store.storeName?.en ?? ""
        imgStores.setShowActivityIndicator(true)
        imgStores.setIndicatorStyle(.gray)
        imgStores.sd_setImage(with: URL(string: store.image ?? ""))
        } else if(lang == "ar")
        {
           
            lblStore.text = store.storeName?.ar ?? ""
            imgStores.setShowActivityIndicator(true)
            imgStores.setIndicatorStyle(.gray)
            imgStores.sd_setImage(with: URL(string: store.image ?? ""))
        }
    }
    
    func setupSubDivisonCell(_ divisionData: GroupDivisonData){
        lblStore.text = divisionData.title?.en ?? ""
        imgStores.setShowActivityIndicator(true)
        imgStores.setIndicatorStyle(.gray)
        imgStores.sd_setImage(with: URL(string: divisionData.image ?? ""))
    }
}
