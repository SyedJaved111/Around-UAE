//
//  SellerOrderDetail.swift
//  Arounduaetest
//
//  Created by Apple on 18/10/2018.
//  Copyright © 2018 MyComedy. All rights reserved.
//

import UIKit
import SDWebImage

class SellerOrderDetail: UIViewController {

    @IBOutlet weak var sellerOrderImage: UIImageView!
    @IBOutlet weak var sellerNasme: UILabel!
    @IBOutlet weak var sellerPhoneNumber: UILabel!
    @IBOutlet weak var sellerEmail: UILabel!
    @IBOutlet weak var shippingaddresss: UILabel!
    @IBOutlet weak var billingAddress: UILabel!
    @IBOutlet weak var orderImage: UIImageView!
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var orderQuantity: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var orderStatus: UILabel!
    @IBOutlet weak var shippedBtn: UIButton!
    
    var sellerOrder:SellerOrder!
    var storeid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOrderDetails()
        if(sellerOrder.status ?? "") != "shipped"{
            shippedBtn.isEnabled = true
            shippedBtn.backgroundColor = #colorLiteral(red: 0.8549019608, green: 0.2039215686, blue: 0.3294117647, alpha: 1)
        }else{
            shippedBtn.isEnabled = false
            shippedBtn.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    private func setupOrderDetails(){
        sellerOrderImage.sd_setShowActivityIndicatorView(true)
        sellerOrderImage.sd_setIndicatorStyle(.gray)
        sellerOrderImage.sd_setImage(with: URL(string:sellerOrder.image ?? ""), placeholderImage: #imageLiteral(resourceName: "Category"))
        sellerNasme.text = sellerOrder.order?.user?.fullName
        sellerPhoneNumber.text = sellerOrder.order?.user?.phone
        sellerEmail.text = sellerOrder.order?.user?.email
        shippingaddresss.text = sellerOrder.order?.addresses?[1].address1
        billingAddress.text = sellerOrder.order?.addresses?.first?.address1
    }
    
    @IBAction func shippedOrder(_ sender: UIButton) {
        startLoading("")
        OrderManager().ShipOrderDetail(sellerOrder.order?._id ?? "", storeid: storeid,
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                self?.finishLoading()
                if let shippedResponse = response{
                    if shippedResponse.success!{
                        self?.alertMessage(message:(shippedResponse.message?.en ?? "").localized, completionHandler: {
                            self?.navigationController?.popViewController(animated: true)
                        })
                    }else{
                        self?.alertMessage(message:(shippedResponse.message?.en ?? "").localized, completionHandler: {
                            self?.navigationController?.popViewController(animated: true)
                        })
                    }
                }else{
                    self?.alertMessage(message: (response?.message?.en ?? "").localized, completionHandler: nil)
                }
            }
        },
        failureCallback:
        {[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.alertMessage(message: error.message.localized, completionHandler: nil)
            }
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        self.addBackButton()
        self.title = "Order Detail"
    }
}
