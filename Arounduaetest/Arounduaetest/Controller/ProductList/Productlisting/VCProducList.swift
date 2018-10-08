//
//  VCCategory.swift
//  AroundUAE
//
//  Created by Macbook on 19/09/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import  XLPagerTabStrip
class VCProducList: ButtonBarPagerTabStripViewController {
    let lang  = UserDefaults.standard.string(forKey: "i18n_language")
    override func viewDidLoad() {
        settings.style.buttonBarBackgroundColor = .red
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = .red
        settings.style.buttonBarItemFont = UIFont(name: "Raleway-Regular", size: 16)!
        settings.style.selectedBarHeight = 2
        settings.style.buttonBarMinimumLineSpacing = 0.5
        settings.style.buttonBarItemTitleColor = .red
        settings.style.selectedBarBackgroundColor = UIColor.red
        settings.style.buttonBarBackgroundColor = UIColor.lightGray;        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .gray
            newCell?.label.textColor = .red
            
            // Do any additional setup after loading the view.
        }

        super.viewDidLoad()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationBar()
        
        if(lang == "en"){
            self.addBackButton()
            self.title = "Products".localized
        } else if(lang == "ar")
        {
           self.showArabicBackButton()
            self.title = "Products".localized
        }
    }
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "HomeTabs", bundle: nil).instantiateViewController(withIdentifier: "VCNearByProductList")
        let child_2 = UIStoryboard(name: "HomeTabs", bundle: nil).instantiateViewController(withIdentifier: "VCTopratedProductList")
      
        return [child_1, child_2]
    }
   



}
