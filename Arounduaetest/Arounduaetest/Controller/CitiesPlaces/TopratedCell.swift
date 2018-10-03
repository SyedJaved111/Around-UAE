//
//  TopratedCell.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 18/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit

class TopratedCell: UICollectionViewCell {
    
    @IBOutlet weak var btnToprated: UIButton!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setsubViewDesign()
        
        
    }
    
    func setsubViewDesign()
    {
        self.btnToprated.layer.cornerRadius = 20
        self.btnToprated.layer.borderWidth = 0.5
        self.btnToprated.layer.borderColor = UIColor.lightGray.cgColor
    }
}
