//
//  VCStoreProducts.swift
//  AroundUAE
//
//  Created by Macbook on 24/09/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SDWebImage

class VCStoreProducts: BaseController,IndicatorInfoProvider,storeCellDelegate{
   
    @IBOutlet var collectionViewManageProducts: UICollectionView!
    var productsArray = [Products]()
    var storeidProducts = ""
    
    override func viewDidLoad(){
        super.viewDidLoad()
        collectionViewManageProducts.adjustDesign(width: ((view.frame.size.width+25)/2.3))
        collectionViewManageProducts.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchProductInfo(storeidProducts, isRefresh: false)
    }
    
    fileprivate func setupDelegates(){
        self.collectionViewManageProducts.emptyDataSetSource = self
        self.collectionViewManageProducts.emptyDataSetDelegate = self
        self.collectionViewManageProducts.reloadData()
    }
    
    private func fetchProductInfo(_ storeId: String, isRefresh: Bool){
        
        if isRefresh == false{
            startLoading("")
        }
        
        StoreManager().getStoreDetail(storeId,successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    if let productResponse = response{
                        if productResponse.success!{
                        self?.productsArray = productResponse.data?.products ?? []
                        }else{
                            self?.alertMessage(message: (lang == "en") ? response?.message?.en ?? "" : response?.message?.en ?? "", completionHandler: nil)
                        }
                    }else{
                        self?.alertMessage(message: "Error".localized, completionHandler: nil)
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
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo{
        return IndicatorInfo.init(title: "Store Products".localized)
    }
    
    func favouriteTapped(cell: CellStore){
        let indxpath = collectionViewManageProducts.indexPath(for: cell)
        if let path = indxpath, let productid = productsArray[path.row]._id{
            addProductToFavourite(product_id: productid)
        }
    }
    
    func addToCartTapped(cell: CellStore){
        
    }
    
    private func addProductToFavourite(product_id:String){
        ProductManager().makeProductFavourite(product_id,
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                if let favouriteResponse = response{
                    self?.alertMessage(message: (lang == "en") ? favouriteResponse.message?.en ?? "" : favouriteResponse.message?.ar ?? "", completionHandler: nil)
                }else{
                    self?.alertMessage(message: "Error".localized, completionHandler: nil)
                }
            }
        }){[weak self](error) in
            DispatchQueue.main.async{
                self?.alertMessage(message: error.message.localized, completionHandler: nil)
            }
        }
    }
}

extension VCStoreProducts: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"CellStore", for: indexPath) as! CellStore
        if AppSettings.sharedSettings.accountType != "seller"{
           cell.delegate = self
        }
        let product = productsArray[indexPath.row]
        cell.setupProductCell(product: product)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if AppSettings.sharedSettings.accountType != "seller"{
            let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "VCProductDetail") as! VCProductDetail
            vc.product = productsArray[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!){
        fetchProductInfo(storeidProducts, isRefresh: false)
    }
}
