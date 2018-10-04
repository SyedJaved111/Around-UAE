//
//  CollectionViewCell.swift
//  Arounduaetest
//
//  Created by Apple on 04/10/2018.
//  Copyright © 2018 MyComedy. All rights reserved.
//

import UIKit
import SDWebImage

class CharacteristicsCell: UICollectionViewCell {
    
    @IBOutlet weak var characterImage: UIImageView!
    
    func setupCell(_ image:String){
        characterImage.makeRound()
        characterImage.setShowActivityIndicator(true)
        characterImage.setIndicatorStyle(.gray)
        //characterImage.sd_setImage(with: URL(string: image ))
    }
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected{
                
            }
            else{
                
            }
        }
    }
}
