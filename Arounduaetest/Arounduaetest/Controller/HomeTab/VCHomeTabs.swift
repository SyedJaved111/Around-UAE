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
        self.title = "Around UAE"
        self.addNavigationButton()
        // Do any additional setup after loading the view.
    }

    func addNavigationButton()
    {
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
        
        self.navigationItem.setRightBarButtonItems([btnCard,btnSearch], animated: true)
        
    }
    
    @objc func btnCardClick (_ sender: Any){
        
        
    }
    
    @objc func btnSearchClick (_ sender: Any)
    {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
