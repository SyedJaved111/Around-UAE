//
//  VCChangeSetting.swift
//  Arounduaetest
//
//  Created by Apple on 22/10/2018.
//  Copyright © 2018 MyComedy. All rights reserved.
//

import UIKit
import DLRadioButton

class VCChangeSetting: UIViewController {
    
    @IBOutlet weak var changecurrencylbl: UILabel!
    @IBOutlet weak var usdlbl: UILabel!
    @IBOutlet weak var aedlbl: UILabel!
    
    @IBOutlet weak var usdBtn: DLRadioButton!
    @IBOutlet weak var ardBtn: DLRadioButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(true)
        self.title = "Change Setting".localized
        
        changecurrencylbl.text = "Change Currency".localized
        usdlbl.text = "USD".localized
        aedlbl.text = "AED".localized
        
        if lang == "ar"{
             showArabicBackButton()
             ardBtn.isSelected = true
        }else{
             addBackButton()
             usdBtn.isSelected = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        if ardBtn.isSelected{
            UserDefaults.standard.set("aed", forKey: "currency")
        }else{
            UserDefaults.standard.set("usd", forKey: "currency")
        }
    }
}
