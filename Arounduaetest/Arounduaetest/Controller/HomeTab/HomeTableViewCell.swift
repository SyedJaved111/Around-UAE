//
//  HomeTableViewCell.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 13/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import SDWebImage

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var CollecView: HomeCollectionView!
    @IBOutlet weak var btnViewAll: UIButton!
    @IBOutlet weak var lblCategoryName: UILabel!

    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {
        
        CollecView.delegate = dataSourceDelegate
        CollecView.dataSource = dataSourceDelegate
        CollecView.tag = row
        CollecView.reloadData()
    }
}
