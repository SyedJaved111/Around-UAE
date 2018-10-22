//
//  VCMenu.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 13/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import SDWebImage
import FBSDKLoginKit
import GoogleSignIn

class VCMenu: BaseController, UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var lblUserProfileMail: UILabel!
    @IBOutlet weak var lblUserProfilename: UILabel!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet var profileTableView: UITableView!
    @IBOutlet var profileView: UIView!
    
    var Menuimgbuyer = [
        "Orders",
        "Settings",
        "Contact",
        "AboutUs",
        "Globe"]
    
    var lblMenuNamebuyer = [
       "My Orders".localized,
       "Change Settings".localized,
       "Contact Us".localized,
       "About Us".localized,
       "Language".localized]
    
    var Menuimgseller = [
        "Orders",
        "Contact",
        "AboutUs",
        "Globe"]
    
    var lblMenuNameseller = [
        "My Orders".localized,
        "Contact Us".localized,
        "About Us".localized,
        "Language".localized]
    
    let defaults = UserDefaults.standard
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let shareduserinfo = SharedData.sharedUserInfo
    
    override func viewDidLoad(){
        super.viewDidLoad()
        if AppSettings.sharedSettings.accountType == "seller"{
            lblMenuNameseller += shareduserinfo.pages.map({$0.title?.en ?? ""})
            Menuimgseller += shareduserinfo.pages.map({$0.image ?? ""})
            profileView.removeFromSuperview()
            profileTableView.reloadData()

        }else{
            lblMenuNamebuyer += shareduserinfo.pages.map({$0.title?.en ?? ""})
            Menuimgbuyer += shareduserinfo.pages.map({$0.image ?? ""})
            profileView.isHidden = false
        }
        
        lblMenuNameseller.append("Logout".localized)
        Menuimgseller.append("Logout")
        lblMenuNamebuyer.append("Logout".localized)
        Menuimgbuyer.append("Logout")
        profileTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ImgDesign()
        self.setNavigationBar()
        setupUserData()
    }
    
    func setupUserData(){
        lblUserProfileMail.text = AppSettings.sharedSettings.user.email!
        lblUserProfilename.text = AppSettings.sharedSettings.user.fullName!
        imgUserProfile.sd_setShowActivityIndicatorView(true)
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
        if AppSettings.sharedSettings.accountType == "seller"{
            return Menuimgseller.count
        }else{
            return Menuimgbuyer.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellMenu") as! CellMenu
        if AppSettings.sharedSettings.accountType == "seller"{
            cell.setupMenu(lblMenuNameseller[indexPath.row], imagestr: Menuimgseller[indexPath.row])
        }else{
            cell.setupMenu(lblMenuNamebuyer[indexPath.row], imagestr: Menuimgbuyer[indexPath.row])
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        
        if AppSettings.sharedSettings.accountType == "seller"{
            let index = indexPath.row
            switch index {
            case 0:
                moveToOrderStores()
            case 1:
                moveToContactUs()
            case 2:
                moveToAboutUS()
            case 3:
                moveToSelectLanguage()
            case 4:
                moveTopage(txt: "Terms and Conditions")
            case 5:
                moveTopage(txt: "Privacy Policy")
            case 6:
                self.logOut()
            default:
                return
            }
        }else{
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
                moveToSelectLanguage()
            case 5:
                moveTopage(txt: "Terms and Conditions")
            case 6:
                moveTopage(txt: "Privacy Policy")
            case 7:
                self.logOut()
            default:
                return
            }
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
    
    func moveToSelectLanguage(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCSelectLanguage") as! VCSelectLanguage
        vc.isFromMenu = true
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
    
    func moveToOrderStores(){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCOrderStore") as! VCOrderStore
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func logOut(){
        if let type = AppSettings.sharedSettings.loginMethod{
            if type == "facebook"{
                FBSDKLoginManager().logOut()
                AppSettings.sharedSettings.socialAccessToken = nil
                AppSettings.sharedSettings.socialId = nil
            }else if type == "google"{
                GIDSignIn.sharedInstance().signOut()
                AppSettings.sharedSettings.socialAccessToken = nil
                AppSettings.sharedSettings.socialId = nil
            }
        }
        AppSettings.sharedSettings.userEmail = nil
        AppSettings.sharedSettings.userPassword = nil
        AppSettings.sharedSettings.isAutoLogin = false
        AppSettings.sharedSettings.loginMethod = nil
        self.appDelegate.moveToLogin()
     }
}


