//
//  PendingTabCell.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 18/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import SDWebImage

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
        lblPending.text = nil
        lblStatusPending.text = nil
        lblPendingValue.text = nil
        lblPendingquantity.text = nil
        lblPendingPrice.text = nil
        lblPendingProduct.text = nil
        imgPending.image = nil
    }
    
    func setupCellData(order:OrderData){
        lblStatusPending.text = order.status
        lblPendingValue.text = nil
        lblPendingquantity.text = "\(order.orderDetails?.count ?? 0)"
        lblPendingPrice.text = "\(order.charges ?? 0)"
        lblPendingProduct.text = nil
        
        imgPending.sd_setShowActivityIndicatorView(true)
        imgPending.sd_setIndicatorStyle(.gray)
        imgPending.sd_setImage(with: URL(string: order.orderDetails?.first?.images?.first ?? ""), placeholderImage: #imageLiteral(resourceName: "Category"))
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.ButtonDesign()
    }
    
    func ButtonDesign() {
        self.btnPending.layer.cornerRadius = 2
    }
}
