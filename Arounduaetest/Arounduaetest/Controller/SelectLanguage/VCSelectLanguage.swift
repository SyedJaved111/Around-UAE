//
//  VCSelectLanguage.swift
//  AroundUAE
//
//  Created by Apple on 10/09/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class VCSelectLanguage: UIViewController {

    @IBOutlet weak var lblSelectLanguage: UILabel!
    @IBOutlet weak var lblSelctlanguageContinue: UILabel!
    @IBOutlet weak var btnEnglish: UIButtonMain!
    @IBOutlet weak var btnArabic: UIButtonMain!
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationBar()
        self.title = "Language".localized
        self.lblSelectLanguage.text = "Select Language".localized
        self.lblSelctlanguageContinue.text = "Select language to continue with".localized
        self.btnEnglish.setTitle("English".localized, for: .normal)
        self.btnArabic.setTitle("Arabic".localized, for: .normal)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func btnEnglishClick(_ sender: Any){
        UserDefaults.standard.set("en", forKey: "i18n_language")
        goToLogin()
    }
    
    @IBAction func btnArabicClick(_ sender: Any){
        UserDefaults.standard.set("ar", forKey: "i18n_language")
        goToLogin()
    }
    
    private func goToLogin(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCLogin") as! VCLogin
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

