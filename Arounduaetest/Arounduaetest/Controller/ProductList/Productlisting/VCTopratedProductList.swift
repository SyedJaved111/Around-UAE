//
//  VCtest.swift
//  AroundUAE
//
//  Created by Macbook on 14/09/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class VCTopratedProductList: UIViewController,IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Top Rated")
    }
    
 
    @IBOutlet var collectionViewProduct: UICollectionView!
    
    let imgFaces = [UIImage(named: "color"),UIImage(named: "color"),UIImage(named: "color"),UIImage(named: "color"),UIImage(named: "color"),UIImage(named: "color")]
    let lblName = ["Sunglasses","Watches","Smart Phone","Glasses","Wathces","Smart"]
 
 
  
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
//collectionViewProduct.adjustDesign(width: (view.frame.size.width+24)/2.3)

       
        
    }
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return imgFaces.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productlistingcell", for: indexPath) as! productlistingcell
//        return cell
//
//    }

  
}



