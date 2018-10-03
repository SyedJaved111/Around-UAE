//
//  VCStoreProducts.swift
//  AroundUAE
//
//  Created by Macbook on 24/09/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class VCStoreProducts: BaseController,IndicatorInfoProvider,storeCellDelegate{
   
    @IBOutlet var collectionViewManageProducts: UICollectionView!
    var productsArray = [Products]()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        collectionViewManageProducts.adjustDesign(width: ((view.frame.size.width+25)/2.3))
        collectionViewManageProducts.reloadData()
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo{
        return IndicatorInfo.init(title: "Store Products")
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
                    self?.alertMessage(message: favouriteResponse.message?.en ?? "", completionHandler: nil)
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
        cell.delegate = self
        let product = productsArray[indexPath.row]
        cell.setupProductCell(product: product)
        return cell
    }
}
