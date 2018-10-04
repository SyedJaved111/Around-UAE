//
//  ShippedTabCell.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 18/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit

class ShippedTabCell: UITableViewCell {

    @IBOutlet weak var lblstatusShipped: UILabel!
    @IBOutlet weak var lblShippedStatus: UILabel!
    @IBOutlet weak var lblShippedValue: UILabel!
    @IBOutlet weak var lblquantityShipped: UILabel!
    @IBOutlet weak var lblShippedPrice: UILabel!
    @IBOutlet weak var imgShipped: UIImageView!
    @IBOutlet weak var lblShippedName: UILabel!
    @IBOutlet weak var btnshipped: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.ButtonDesign()
    }
    
    func ButtonDesign() {
        self.btnshipped.layer.cornerRadius = 5
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
