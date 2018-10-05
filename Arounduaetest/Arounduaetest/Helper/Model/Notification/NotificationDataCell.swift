//
//  NotificationDataCell.swift
//  ValetParking
//
//  Created by Zafar Najmi on 18/08/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit

class NotificationDataCell: UITableViewCell {
    
    
    @IBOutlet var notificationImage: UIImageView!
    @IBOutlet var notificationTitle: UILabel!
    @IBOutlet var notificationDescription: UILabel!
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var delteNotificationBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
