//
//  VCFavrouit.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 13/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import Cosmos
import XLPagerTabStrip

class VCFavrouit: UIViewController,IndicatorInfoProvider{
    
    @IBOutlet weak var viewEmptyList: UIView!
    @IBOutlet weak var lblEmpty: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet var favouriteProductTableView: UITableView!{
        didSet{
            self.favouriteProductTableView.delegate = self
            self.favouriteProductTableView.dataSource = self
        }
    }
    
    var favouriteProductList = [Products]()
    var totalPages = 0
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialUI()
        getFavouriteProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title = "Products"
        lblEmpty.text = "Empty List".localized
        lblMessage.text = "Sorry there no data available".localized
    }
    
    private func getFavouriteProducts(){
        startLoading("")
        ProductManager().getFavouriteProducts("\(currentPage + 1)",
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                self?.finishLoading()
                if let FavouriteProductData = response{
                    if(FavouriteProductData.data?.products ?? []).count == 0{
                        self?.viewEmptyList.isHidden = false
                    }else{
                        self?.favouriteProductList = FavouriteProductData.data?.products ?? []
                        self?.currentPage = FavouriteProductData.data?.pagination?.page ?? 1
                        self?.totalPages = FavouriteProductData.data?.pagination?.pages ?? 0
                        self?.favouriteProductTableView.reloadData()
                    }
                }else{
                    self?.viewEmptyList.isHidden = false
                    self?.alertMessage(message: "Error".localized, completionHandler: nil)
                }
            }
        })
        {[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.viewEmptyList.isHidden = false
                self?.alertMessage(message: error.message.localized, completionHandler: nil)
            }
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: "Products")
    }
    
    @IBAction func tryAgain(_ sender: UIButton) {
        self.viewEmptyList.isHidden = true
        getFavouriteProducts()
    }
}

extension VCFavrouit{
    
    func initialUI(){
        
        favouriteProductTableView.spr_setTextHeader { [weak self] in
            self?.viewEmptyList.isHidden = true
            self?.currentPage = 0
             ProductManager().getFavouriteProducts("\((self?.currentPage ?? 0) + 1)",successCallback:
                {[weak self](response) in
                    DispatchQueue.main.async {
                        self?.favouriteProductTableView.spr_endRefreshing()
                        if let favouriteResponse = response{
                            if(favouriteResponse.data?.products ?? []).count == 0{
                                self?.viewEmptyList.isHidden = false
                            }else{
                                self?.favouriteProductList = favouriteResponse.data?.products ?? []
                                self?.currentPage = favouriteResponse.data?.pagination?.page ?? 1
                                self?.totalPages = favouriteResponse.data?.pagination?.pages ?? 0
                                self?.favouriteProductTableView.reloadData()
                            }
                        }else{
                            self?.viewEmptyList.isHidden = false
                            self?.alertMessage(message: "Error".localized, completionHandler: nil)
                        }
                    }
                })
            {[weak self](error) in
                DispatchQueue.main.async {
                    self?.favouriteProductTableView.spr_endRefreshing()
                    self?.viewEmptyList.isHidden = false
                    self?.alertMessage(message: error.message.localized, completionHandler: nil)
                }
            }
        }
        
        favouriteProductTableView.spr_setIndicatorFooter {[weak self] in
            if((self?.currentPage)! >= (self?.totalPages)!){
                self?.favouriteProductTableView.spr_endRefreshing()
                return}
            
             ProductManager().getFavouriteProducts("\((self?.currentPage ?? 0) + 1)",successCallback:
                {[weak self](response) in
                    DispatchQueue.main.async {
                        self?.favouriteProductTableView.spr_endRefreshing()
                        if let favouriteResponse = response{
                            for product in favouriteResponse.data?.products ?? []{
                                self?.favouriteProductList.append(product)
                            }
                            self?.currentPage = favouriteResponse.data?.pagination?.page ?? 1
                            self?.totalPages = favouriteResponse.data?.pagination?.pages ?? 0
                            self?.favouriteProductTableView.reloadData()
                        }else{
                            self?.alertMessage(message: "Error".localized, completionHandler: nil)
                        }
                    }
                })
            {[weak self](error) in
                DispatchQueue.main.async {
                    self?.favouriteProductTableView.spr_endRefreshing()
                    self?.alertMessage(message: error.message.localized, completionHandler: nil)
                }
            }
        }
    }
}

extension VCFavrouit: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 133
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteProductList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellFavourit") as! CellFavourit
        cell.setupCellData(favouriteProductList[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}
