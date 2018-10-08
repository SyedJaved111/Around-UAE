//
//  VCPages.swift
//  Arounduaetest
//
//  Created by mohsin raza on 30/09/2018.
//  Copyright © 2018 MyComedy. All rights reserved.
//

import UIKit

class VCPages: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    @IBOutlet var lblAboutUs: UILabel!
    @IBOutlet var titlepage: UILabel!
    let shareduserinfo = SharedData.sharedUserInfo
    var titletxt = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(lang == "en"){
        let attributedString = NSMutableAttributedString(string: shareduserinfo.setting.aboutShortDescription?.en ?? "")
        lblAboutUs.attributedText = attributedString
        titlepage.text = titletxt
        } else if(lang == "ar")
        {
            let attributedString = NSMutableAttributedString(string: shareduserinfo.setting.aboutShortDescription?.ar ?? "")
            lblAboutUs.attributedText = attributedString
            titlepage.text = titletxt
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = titletxt
        self.setNavigationBar()
        if(lang == "en")
        {
        self.addBackButton()
        } else if(lang == "ar")
        {
            self.showArabicBackButton()
        }
    }
}
