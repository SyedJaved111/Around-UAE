//
//  VCMenu.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 13/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import SDWebImage

class VCMenu: BaseController, UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var lblUserProfileMail: UILabel!
    @IBOutlet weak var lblUserProfilename: UILabel!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet var profileTableView: UITableView!
    
    var Menuimg = [
        "Orders",
        "Settings",
        "Contact",
        "AboutUs"]
    
    var lblMenuName = [
       "My Orders".localized,
       "Change Settings".localized,
       "Contact Us".localized,
       "About Us".localized]
    
    let defaults = UserDefaults.standard
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let shareduserinfo = SharedData.sharedUserInfo
    
    override func viewDidLoad(){
        super.viewDidLoad()
        lblMenuName += shareduserinfo.pages.map({$0.title?.en ?? ""})
        Menuimg += shareduserinfo.pages.map({$0.image ?? ""})
        lblMenuName.append("Language".localized)
        Menuimg.append("Language")
        lblMenuName.append("Logout".localized)
        Menuimg.append("Logout")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ImgDesign()
        self.setNavigationBar()
        setupUserData()
    }
    
    func setupUserData(){
        lblUserProfileMail.text = AppSettings.sharedSettings.user.email!
        lblUserProfilename.text = AppSettings.sharedSettings.user.fullName!
        imgUserProfile.sd_addActivityIndicator()
        imgUserProfile.sd_setIndicatorStyle(.gray)
        imgUserProfile.sd_setImage(with: URL(string: AppSettings.sharedSettings.user.image ?? ""))
    }
    
    func ImgDesign(){
        self.imgUserProfile.layer.cornerRadius = 30
        self.imgUserProfile.clipsToBounds = true
        self.imgUserProfile.layer.borderWidth = 0.5
        self.imgUserProfile.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lblMenuName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellMenu") as! CellMenu
        cell.setupMenu(lblMenuName[indexPath.row], imagestr: Menuimg[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let index = indexPath.row
        switch index {
            case 0:
             moveToOrderVC()
            case 1:
             break
            case 2:
             moveToContactUs()
            case 3:
             moveToAboutUS()
            case 4:
             moveTopage(txt: lblMenuName[indexPath.row])
            case 5:
             moveTopage(txt: lblMenuName[indexPath.row])
            case 6:
             appDelegate.moveToSelectlanguage()
            case 7:
                self.logOut()
            default:
                return
        }
    }
    
    @IBAction func ProfileClick(_ sender: Any){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCProfile") as! VCProfile
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func moveToContactUs(){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCContactUs") as! VCContactUs
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
     func moveToAboutUS(){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCAboutUs") as! VCAboutUs
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func moveTopage(txt:String){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCPages") as! VCPages
        vc.titletxt = txt
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func moveToOrderVC(){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCMyOrders") as! VCMyOrders
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func logOut(){
        AppSettings.sharedSettings.userEmail = nil
        AppSettings.sharedSettings.userPassword = nil
        AppSettings.sharedSettings.isAutoLogin = false
        AppSettings.sharedSettings.loginMethod = nil
        self.appDelegate.moveToLogin()
     }
}


