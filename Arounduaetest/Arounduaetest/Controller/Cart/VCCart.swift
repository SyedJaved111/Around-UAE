//
//  VCCart.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 19/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit

class VCCart: UIViewController {
    
    @IBOutlet weak var btnCheckout: UIButtonMain!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblTotalBill: UILabel!
    @IBOutlet weak var tableheightconstraint: NSLayoutConstraint!
    var cartProductList = [Product]()
    @IBOutlet weak var cartscrollview: UIScrollView!
    
    @IBOutlet weak var myTbleView: UITableView!{
        didSet{
            myTbleView.delegate = self
            myTbleView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCartProducts()
    }
    
    private func getCartProducts(){
        startLoading("")
        CartManager().getCartProducts(
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                self?.finishLoading()
                if let FavouriteProductData = response{
                    if(FavouriteProductData.data ?? []).count == 0{

                    }else{
                        self?.cartProductList = FavouriteProductData.data ?? []
                        self?.myTbleView.reloadData()
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
    
    override func viewWillAppear(_ animated: Bool){
        self.title = "Cart".localized
        self.addBackButton()
    }
    
    override func viewDidLayoutSubviews(){
        super.updateViewConstraints()
        tableheightconstraint.constant = myTbleView.contentSize.height
        cartscrollview.contentSize = CGSize(width: UIScreen.main.bounds.width, height: myTbleView.contentSize.height + 180)
    }

    @IBAction func ContinueClick(_ sender: Any) {
        
    }
}

extension VCCart: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartProductList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell") as! CartCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
}
