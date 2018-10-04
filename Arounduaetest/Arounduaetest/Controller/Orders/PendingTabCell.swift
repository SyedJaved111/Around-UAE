//
//  PendingTabCell.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 18/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit

class PendingTabCell: UITableViewCell {

    @IBOutlet weak var lblPending: UILabel!
    @IBOutlet weak var lblStatusPending: UILabel!
    @IBOutlet weak var btnPending: UIButton!
    @IBOutlet weak var lblPendingValue: UILabel!
    @IBOutlet weak var lblPendingquantity: UILabel!
    @IBOutlet weak var lblPendingPrice: UILabel!
    @IBOutlet weak var lblPendingProduct: UILabel!
    @IBOutlet weak var imgPending: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.ButtonDesign()
    }
    
    func ButtonDesign() {
        self.btnPending.layer.cornerRadius = 5
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
