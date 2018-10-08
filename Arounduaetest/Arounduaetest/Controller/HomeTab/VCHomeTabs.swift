//
//  VCHomeTab.swift
//  AroundUAE
//
//  Created by Macbook on 13/09/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit

class VCHomeTabs: TTabBarViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar()
        self.title = "Around UAE".localized
        self.addNavigationButton()
    }

    func addNavigationButton(){
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: "Cart"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        btn1.addTarget(self, action: #selector(btnCardClick(_:)), for: .touchUpInside)
        let btnCard = UIBarButtonItem(customView: btn1)
        
        let btn2 = UIButton(type: .custom)
        btn2.setImage(UIImage(named: "Search"), for: .normal)
        btn2.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        btn2.addTarget(self, action: #selector(btnSearchClick(_:)), for: .touchUpInside)
        let btnSearch = UIBarButtonItem(customView: btn2)
        self.navigationItem.setRightBarButtonItems([btnSearch,btnCard], animated: true)
    }
    
    @objc func btnCardClick (_ sender: Any){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCCart") as! VCCart
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func btnSearchClick (_ sender: Any){
        
    }
}
