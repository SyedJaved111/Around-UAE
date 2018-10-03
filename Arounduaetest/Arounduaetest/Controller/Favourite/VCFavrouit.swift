//
//  VCFavrouit.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 13/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import Cosmos

class VCFavrouit: UIViewController{
    
    @IBOutlet weak var viewEmptyList: UIView!
    @IBOutlet weak var lblEmpty: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet var tableViewProducts: UITableView!{
        didSet{
            //self.collectionViewProducts.delegate = self
            //self.collectionViewProducts.dataSource = self
        }
    }
    
    var favouriteProductsArray = [Products]()
    var totalPages = 0
    var currentPage = 0
    
    override func viewDidLoad(){
        super.viewDidLoad()
        initialUI()
        //fetchProductsData()
    }

    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(true)
    }
}

extension VCFavrouit{
    func initialUI(){
        
        tableViewProducts.spr_setTextHeader { [weak self] in
            self?.viewEmptyList.isHidden = true
            self?.currentPage = 0
            StoreManager().getStores("\((self?.currentPage ?? 0) + 1)",successCallback:
                {[weak self](response) in
                    DispatchQueue.main.async {
                        self?.tableViewProducts.spr_endRefreshing()
                        if let productResponse = response{
                            if(productResponse.data?.stores ?? []).count == 0{
                                self?.viewEmptyList.isHidden = false
                            }else{
                                //self?.favouriteProductsArray = productResponse.data?. ?? []
//                                self?.currentPage = storeResponse.data?.pagination?.page ?? 1
//                                self?.totalPages = storeResponse.data?.pagination?.pages ?? 0
//                                self?.collectionViewProducts.reloadData()
                            }
                        }else{
                            self?.viewEmptyList.isHidden = false
                            self?.alertMessage(message: "Error".localized, completionHandler: nil)
                        }
                    }
                })
            {[weak self](error) in
                DispatchQueue.main.async {
                    self?.tableViewProducts.spr_endRefreshing()
                    self?.viewEmptyList.isHidden = false
                    self?.alertMessage(message: error.message.localized, completionHandler: nil)
                }
            }
        }
        
          tableViewProducts.spr_setIndicatorFooter {[weak self] in
            if((self?.currentPage)! >= (self?.totalPages)!){
                self?.tableViewProducts.spr_endRefreshing()
                return}
            
            StoreManager().getStores("\((self?.currentPage ?? 0) + 1)",successCallback:
                {[weak self](response) in
                    DispatchQueue.main.async {
                        self?.tableViewProducts.spr_endRefreshing()
                        if let storeResponse = response{
                            for store in storeResponse.data?.stores ?? []{
                                //self?.storelist.append(store)
                            }
                            self?.currentPage = storeResponse.data?.pagination?.page ?? 1
                            self?.totalPages = storeResponse.data?.pagination?.pages ?? 0
                            self?.tableViewProducts.reloadData()
                        }else{
                            self?.alertMessage(message: "Error".localized, completionHandler: nil)
                        }
                    }
                })
            {[weak self](error) in
                DispatchQueue.main.async {
                    self?.tableViewProducts.spr_endRefreshing()
                    self?.alertMessage(message: error.message.localized, completionHandler: nil)
                }
            }
        }
    }
}

extension VCFavrouit: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = tableView.dequeueReusableCell(withIdentifier: "CellFavourit") as! CellFavourit
        //data.imgFavourit.image = Favroutarr[indexPath.row]
        data.selectionStyle = .none
        return data
    }
}
