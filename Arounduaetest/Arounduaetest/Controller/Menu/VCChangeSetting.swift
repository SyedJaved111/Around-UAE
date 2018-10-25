//
//  VCChangeSetting.swift
//  Arounduaetest
//
//  Created by Apple on 22/10/2018.
//  Copyright © 2018 MyComedy. All rights reserved.
//

import UIKit

class VCChangeSetting: UIViewController {
    
     @IBOutlet weak var changelanguagelbl: UILabel!
     @IBOutlet weak var englishlbl: UILabel!
     @IBOutlet weak var arabiclbl: UILabel!
    
     @IBOutlet weak var changecurrencylbl: UILabel!
     @IBOutlet weak var usdlbl: UILabel!
     @IBOutlet weak var aedlbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title = "Change Setting".localized
        
        changelanguagelbl.text = "Change Language".localized
        englishlbl.text = "English".localized
        arabiclbl.text = "Arabic".localized
        
        changecurrencylbl.text = "Change Currency".localized
        usdlbl.text = "USD".localized
        aedlbl.text = "AED".localized
        
        if lang == "ar"{
            showArabicBackButton()
        }else{
            addBackButton()
        }
    }
}
