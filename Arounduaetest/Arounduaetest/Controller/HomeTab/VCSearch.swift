//
//  VCSearch.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 05/10/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import SwiftRangeSlider

class VCSearch: UIViewController {

    @IBOutlet weak var lblcolorsize4: UILabel!
    @IBOutlet weak var lblcolorsize3: UILabel!
    @IBOutlet weak var lblcolorsize2: UILabel!
    @IBOutlet weak var lblcolorsize1: UILabel!
    @IBOutlet weak var ViewRanger: RangeSlider!
    @IBOutlet weak var lblPriceranger: UILabel!
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    @IBAction func btnClick1(_ sender: UIButton){
        
    }
    
    @IBAction func btnClick2(_ sender: UIButton){
        
    }
    
    @IBAction func btnClick3(_ sender: UIButton){
        
    }
    
    @IBAction func btnClick4(_ sender: UIButton){
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Product Filter"
        self.addBackButton()
        self.setNavigationBar()
    }
}
