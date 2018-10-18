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

    @IBOutlet weak var orderlblTxt: UILabel!
    @IBOutlet weak var lblChargestxt: UILabel!
    @IBOutlet weak var lblDatetxt: UILabel!
    @IBOutlet weak var lblStatusTxt: UILabel!
    @IBOutlet weak var lblcombinatonDetail: UILabel!
    @IBOutlet weak var confirmImage: UIImageView!
    @IBOutlet weak var eyeBtn: UIButton!
    var str = ""
    var x = " "
    
    override func awakeFromNib() {
        super.awakeFromNib()
        orderlblTxt.text = nil
        lblChargestxt.text = nil
        lblDatetxt.text = nil
        lblStatusTxt.text = nil
        confirmImage.image = nil
    }
    
    func setupCellData(order:OrderData){
        orderlblTxt.text = order.payerId
        lblChargestxt.text = "$\(order.charges ?? 0)"
        
        str = "Quantity: \(order.orderDetails?.count ?? 0) "
        
        for obj in (order.orderDetails?.first?.combinationDetail) ?? []{
            str += (obj.feature?.title?.en ?? "")+" "+(obj.characteristic?.title?.en ?? "")
        }
        
        lblcombinatonDetail.text = str
        lblDatetxt.text = order.createdAt
        lblStatusTxt.text = order.status?.capitalized
        
        eyeBtn.layer.cornerRadius = 15
        eyeBtn.clipsToBounds = true
        
        confirmImage.sd_setShowActivityIndicatorView(true)
        confirmImage.sd_setIndicatorStyle(.gray)
        confirmImage.sd_setImage(with: URL(string: order.orderDetails?.first?.images?.first ?? ""), placeholderImage: #imageLiteral(resourceName: "Category"))
    }
    
    func setupSellerCellData(order:SellerOrder){
        orderlblTxt.text = order._id
        //lblChargestxt.text = "$\(order.charges ?? 0)"
        
        str = "Quantity: \(order.quantity ?? 0) "
        
        for obj in (order.combinationDetail) ?? []{
            str += (obj.feature?.title?.en ?? "")+" "+(obj.characteristic?.title?.en ?? "")
        }
        
        lblcombinatonDetail.text = str
        lblDatetxt.text = order.createdAt
        lblStatusTxt.text = order.status?.capitalized
        
        eyeBtn.layer.cornerRadius = 15
        eyeBtn.clipsToBounds = true
        
        confirmImage.sd_setShowActivityIndicatorView(true)
        confirmImage.sd_setIndicatorStyle(.gray)
        confirmImage.sd_setImage(with: URL(string: order.images?.first ?? ""), placeholderImage: #imageLiteral(resourceName: "Category"))
    }
}
