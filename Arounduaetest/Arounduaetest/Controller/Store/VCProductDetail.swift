//
//  VCProductDetail.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 19/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import Cosmos

class VCProductDetail: UIViewController {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var prodcutPrice: UILabel!
    @IBOutlet weak var productname: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var Productcounter: GMStepper!
    @IBOutlet weak var productDescription: UILabel!
    
    var product:Products!

    override func viewDidLoad() {
        super.viewDidLoad()
        getProductDetail()
    }
    
    private func getProductDetail(){
        startLoading("")
        ProductManager().productDetail(product._id!,
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                self?.finishLoading()
                if let storeResponse = response{
                    if storeResponse.success!{
                        self?.setupProductDetsil(storeResponse.data!)
                    }
                }else{
                    self?.alertMessage(message: "Error".localized, completionHandler: nil)
                }
            }
        })
        {[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.alertMessage(message: error.message.localized, completionHandler: nil)
            }
        }
    }
    
    private func setupProductDetsil(_ productdetail:Product){
        productImage.setShowActivityIndicator(true)
        productImage.setIndicatorStyle(.gray)
        productImage.sd_setImage(with: URL(string: product.images?.first?.path ?? ""))
        prodcutPrice.text = "$\(product.price?.usd ?? 0)"
        productname.text = productdetail.productName?.en ?? ""
        ratingView.rating = 0.0
        productDescription.text = productdetail.description?.en ?? ""
    }
    
    @IBAction func productLike(_ sender: UIButton) {
        
    }
    
    @IBAction func addToCart(_ sender: UIButton){
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Product Detail"
        self.addBackButton()
    }
    
    @IBAction func addtocartclick(_ sender: Any) {
       
    }
}
