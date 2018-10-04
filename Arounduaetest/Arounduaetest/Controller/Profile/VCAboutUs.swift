//
//  VCAboutUs.swift
//  AroundUAE
//
//  Created by Macbook on 17/09/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit

class VCAboutUs: UIViewController {

    @IBOutlet var UIButtonTwitter: UIButton!
    @IBOutlet var UIButtonFaceBook: UIButton!
    @IBOutlet var UIButtonIn: UIButton!
    @IBOutlet var lblAboutUs: UILabel!
    let shareduserinfo = SharedData.sharedUserInfo
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let attributedString = NSMutableAttributedString(string: shareduserinfo.setting.aboutShortDescription?.en ?? "")
        lblAboutUs.attributedText = attributedString
        UIButtonIn.makeRound()
        UIButtonFaceBook.makeRound()
        UIButtonTwitter.makeRound()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "About Us"
        self.setNavigationBar()
        self.addBackButton()
    }
}
