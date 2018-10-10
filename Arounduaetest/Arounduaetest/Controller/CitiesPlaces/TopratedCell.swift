//
//  TopratedCell.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 18/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage

class TopratedCell: UICollectionViewCell {
    
    @IBOutlet weak var btnToprated: UIButton!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var placeTitle: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setsubViewDesign()
    }
    
    func setsubViewDesign(){
        self.btnToprated.layer.cornerRadius = 20
        self.btnToprated.layer.borderWidth = 0.5
        self.btnToprated.layer.borderColor = UIColor.lightGray.cgColor
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
    }
}
