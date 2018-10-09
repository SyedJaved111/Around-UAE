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
import DZNEmptyDataSet

class VCFavrouit: BaseController,IndicatorInfoProvider{
    
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
    }
    
    fileprivate func setupDelegates(){
        self.favouriteProductTableView.emptyDataSetSource = self
        self.favouriteProductTableView.emptyDataSetDelegate = self
        self.favouriteProductTableView.tableFooterView = UIView()
        self.favouriteProductTableView.reloadData()
    }
    
    private func getFavouriteProducts(){
        startLoading("")
        ProductManager().getFavouriteProducts("\(currentPage + 1)",
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                self?.finishLoading()
                if let FavouriteProductData = response{
                    if FavouriteProductData.success!{
                        self?.favouriteProductList = FavouriteProductData.data?.products ?? []
                        self?.currentPage = FavouriteProductData.data?.pagination?.page ?? 1
                        self?.totalPages = FavouriteProductData.data?.pagination?.pages ?? 0
                    }else{
                        self?.alertMessage(message:(FavouriteProductData.message?.en ?? "").localized, completionHandler: nil)
                    }
                }else{
                    self?.alertMessage(message: (response?.message?.en ?? "").localized, completionHandler: nil)
                }
                self?.setupDelegates()
            }
        })
        {[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.setupDelegates()
                self?.alertMessage(message: error.message.localized, completionHandler: nil)
            }
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: "Products")
    }
}

extension VCFavrouit{
    
    func initialUI(){
        
        favouriteProductTableView.spr_setTextHeader { [weak self] in
            self?.currentPage = 0
             ProductManager().getFavouriteProducts("\((self?.currentPage ?? 0) + 1)",successCallback:
                {[weak self](response) in
                    DispatchQueue.main.async {
                        self?.favouriteProductTableView.spr_endRefreshing()
                        if let favouriteResponse = response{
                            if favouriteResponse.success!{
                                self?.favouriteProductList = favouriteResponse.data?.products ?? []
                                self?.currentPage = favouriteResponse.data?.pagination?.page ?? 1
                                self?.totalPages = favouriteResponse.data?.pagination?.pages ?? 0
                            }else{
                                self?.alertMessage(message:(favouriteResponse.message?.en ?? "").localized, completionHandler: nil)
                            }
                        }else{
                            self?.alertMessage(message: (response?.message?.en ?? "").localized, completionHandler: nil)
                        }
                        self?.setupDelegates()
                    }
                })
            {[weak self](error) in
                DispatchQueue.main.async {
                    self?.favouriteProductTableView.spr_endRefreshing()
                    self?.setupDelegates()
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
                            if favouriteResponse.success!{
                                for product in favouriteResponse.data?.products ?? []{
                                    self?.favouriteProductList.append(product)
                                }
                                self?.currentPage = favouriteResponse.data?.pagination?.page ?? 1
                                self?.totalPages = favouriteResponse.data?.pagination?.pages ?? 0
                            }else{
                                self?.alertMessage(message:(favouriteResponse.message?.en ?? "").localized, completionHandler: nil)
                            }
                        }else{
                            self?.alertMessage(message: (response?.message?.en ?? "").localized, completionHandler: nil)
                        }
                        self?.setupDelegates()
                    }
                })
            {[weak self](error) in
                DispatchQueue.main.async {
                    self?.favouriteProductTableView.spr_endRefreshing()
                    self?.setupDelegates()
                    self?.alertMessage(message: error.message.localized, completionHandler: nil)
                }
            }
        }
    }
}

extension VCFavrouit: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
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
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!){
        getFavouriteProducts()
    }
}
