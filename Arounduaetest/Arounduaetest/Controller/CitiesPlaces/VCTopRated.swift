//
//  VCTopRated.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 18/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class VCTopRated: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,IndicatorInfoProvider {
    
    
    @IBOutlet weak var TopratedCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    TopratedCollectionView.adjustDesign(width: ((view.frame.size.width)/2.4))

    }

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopratedCell", for: indexPath) as! TopratedCell
        return cell
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Toprated")
    }

}

