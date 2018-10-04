//
//  VCPages.swift
//  Arounduaetest
//
//  Created by mohsin raza on 30/09/2018.
//  Copyright © 2018 MyComedy. All rights reserved.
//

import UIKit

class VCPages: UIViewController {

    @IBOutlet var lblAboutUs: UILabel!
    @IBOutlet var titlepage: UILabel!
    let shareduserinfo = SharedData.sharedUserInfo
    var titletxt = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let attributedString = NSMutableAttributedString(string: shareduserinfo.setting.aboutShortDescription?.en ?? "")
        lblAboutUs.attributedText = attributedString
        titlepage.text = titletxt
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = titletxt
        self.setNavigationBar()
        self.addBackButton()
    }
}
