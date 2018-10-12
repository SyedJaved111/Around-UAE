//
//  NearByCell.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 18/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage

class NearByCell: UICollectionViewCell {
    
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var btnFavourit: UIButton!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var placeTitle: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setsubViewDesign()
    }
    
    func setsubViewDesign(){
        self.btnFavourit.layer.cornerRadius = 20
        self.btnFavourit.layer.borderWidth = 0.5
        self.btnFavourit.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override func awakeFromNib() {
        cosmosView.rating = 0.0
        title.text = nil
        placeTitle.image = nil
    }
    
    func setupPlaceCell(_ places:Places){
        cosmosView.rating = Double(places.averageRating!)
        title.text = places.title?.en ?? ""
        
        placeTitle.sd_setShowActivityIndicatorView(true)
        placeTitle.sd_setIndicatorStyle(.gray)
        placeTitle.sd_setImage(with: URL(string: places.images?.first?.path ?? ""))
        
        if AppSettings.sharedSettings.user.favouritePlaces?.contains((places._id!)) ?? false{
            self.btnFavourit.setImage(#imageLiteral(resourceName: "Favourite"), for:.normal)
        }else{
            self.btnFavourit.setImage(#imageLiteral(resourceName: "Favourite-red"), for:.normal)
        }
    }
}
