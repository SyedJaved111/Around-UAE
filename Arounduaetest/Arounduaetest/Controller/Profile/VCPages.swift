//
//  VCPages.swift
//  Arounduaetest
//
//  Created by mohsin raza on 30/09/2018.
//  Copyright © 2018 MyComedy. All rights reserved.
//

import UIKit
let lang = UserDefaults.standard.string(forKey: "i18n_language")
class VCPages: UIViewController {

    @IBOutlet var lblAboutUs: UILabel!
    @IBOutlet var titlepage: UILabel!
    let shareduserinfo = SharedData.sharedUserInfo
    var titletxt = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if lang == "en"{
            let attributedString = NSMutableAttributedString(string: shareduserinfo.setting.aboutShortDescription?.en ?? "")
            lblAboutUs.attributedText = attributedString
        }else{
            let attributedString = NSMutableAttributedString(string: shareduserinfo.setting.aboutShortDescription?.ar ?? "")
            lblAboutUs.attributedText = attributedString
        }
        
        titlepage.text = titletxt
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = titletxt.localized
        self.setNavigationBar()
        if lang == "ar"{
            self.showArabicBackButton()
        }else{
           self.addBackButton()
        }
    }
}
