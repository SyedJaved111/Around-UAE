//
//  OrderDetailCell.swift
//  Arounduaetest
//
//  Created by Apple on 18/10/2018.
//  Copyright © 2018 MyComedy. All rights reserved.
//

import UIKit
import SDWebImage

protocol OrderDetailPrortocol {
    func tapOnReceived(cell:OrderDetailCell)
}

class OrderDetailCell: UITableViewCell {

    @IBOutlet weak var lblOrderName: UILabel!
    @IBOutlet weak var lblOrderList: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblCharges: UILabel!
    @IBOutlet weak var orderImage: UIImageView!
    @IBOutlet weak var cellBtn: UIButton!
    @IBOutlet weak var boxesImage: UIImageView!
    @IBOutlet weak var shadowImage: UIImageView!
    
    var str = ""
    var delegate: OrderDetailPrortocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblOrderName.text = ""
        lblOrderList.text = ""
        storeName.text = ""
        lblStatus.text = ""
        lblCharges.text = ""
        boxesImage.image = nil
        shadowImage.image = nil
    }
    
    func setupData(order:SomeOrderDetails){
        if (order.status ?? "") == "shipped"{
           cellBtn.isEnabled = true
           cellBtn.backgroundColor = #colorLiteral(red: 0.8549019608, green: 0.2039215686, blue: 0.3294117647, alpha: 1)
        }else{
            cellBtn.isEnabled = false
            cellBtn.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        str = "Quantity: \(0)"
        
        for obj in (order.combinationDetail) ?? []{
            str += " "
            str += (obj.feature?.title?.en ?? "")+": "+(obj.characteristic?.title?.en ?? "")
        }

        if(order.quantity ?? 0) > 0{
            boxesImage.image = #imageLiteral(resourceName: "Slide")
            shadowImage.image = #imageLiteral(resourceName: "Bg")
        }else{
            boxesImage.image = nil
            shadowImage.image = nil
        }
        
        lblOrderName.text = order._id 
        lblOrderList.text = str
        storeName.text = order.product?.productName?.en ?? ""
        lblStatus.text = order.status
        lblCharges.text = "$\(order.price?.usd ?? 0)"
        
        orderImage.sd_setShowActivityIndicatorView(true)
        orderImage.sd_setIndicatorStyle(.gray)
        orderImage.sd_setImage(with: URL(string: (order.image ?? "")), placeholderImage: #imageLiteral(resourceName: "Category"))
    }
    
    @IBAction func actonBtn(_ sender: UIButton){
        delegate?.tapOnReceived(cell: self)
    }
}
