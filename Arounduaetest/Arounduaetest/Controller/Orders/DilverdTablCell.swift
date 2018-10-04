//
//  DilverdTablCell.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 18/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit

class DilverdTablCell: UITableViewCell {

    @IBOutlet weak var lblStatusDilver: UILabel!
    @IBOutlet weak var lblDilverdStatus: UILabel!
    @IBOutlet weak var lblDilverdValue: UILabel!
    @IBOutlet weak var lblDilverdquantity: UILabel!
    @IBOutlet weak var lblDilverdPrice: UILabel!
    @IBOutlet weak var imgDilverd: UIImageView!
    @IBOutlet weak var lblDilverdname: UILabel!
    @IBOutlet weak var btnDilverd: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.ButtonDesign()
    }
    
    func ButtonDesign() {
        self.btnDilverd.layer.cornerRadius = 5
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
