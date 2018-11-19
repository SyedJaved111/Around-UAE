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
    func favouriteTapped(cell: CellStore) {
        
    }
    
    
    @IBOutlet var collectionViewManageProducts: UICollectionView!
    var productsArray = [Products]()
    var storeidProducts = ""
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    override func viewDidLoad(){
        super.viewDidLoad()
        collectionViewManageProducts.adjustDesign(width: ((view.frame.size.width+25)/2.3))
        collectionViewManageProducts.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("RemoveSelfie"), object: nil)
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
                            self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.en ?? "", completionHandler: nil)
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
        if isResturant{
            return IndicatorInfo.init(title: "Food Items".localized)
        }
        return IndicatorInfo.init(title: "Store Products".localized)
    }
    
    func addToCartTapped(cell: CellStore){
        let indexpath  = collectionViewManageProducts.indexPath(for: cell)!
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCPopCart") as! VCPopCart
        vc.product = productsArray[indexpath.row]
        self.present(vc, animated: true, completion: nil)
    }
    
    private func addProductToFavourite(product_id:String,cellstore:CellStore){
        startLoading("")
        ProductManager().makeProductFavourite(product_id,
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                if let favouriteResponse = response{
                    AppSettings.sharedSettings.user = favouriteResponse.data!
                    if AppSettings.sharedSettings.user.favouriteProducts?.contains((product_id)) ?? false{
                        cellstore.favouriteImage.image = #imageLiteral(resourceName: "Favourite-red")
                        cellstore.UIButtonFavourite.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    }else{
                        cellstore.favouriteImage.image = #imageLiteral(resourceName: "Favourite")
                        cellstore.UIButtonFavourite.backgroundColor = #colorLiteral(red: 0.137254902, green: 0.1176470588, blue: 0.0862745098, alpha: 1)
                    }
                    self?.alertMessage(message: (self?.lang ?? "" == "en") ? favouriteResponse.message?.en ?? "" : favouriteResponse.message?.ar ?? "", completionHandler: nil)
                }else{
                    self?.alertMessage(message: "Error".localized, completionHandler: nil)
                }
                self?.finishLoading()
            }
        }){[weak self](error) in
            DispatchQueue.main.async{
                self?.finishLoading()
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
