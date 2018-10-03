//
//  VCProfile.swift
//  AroundUAE
//
//  Created by Macbook on 17/09/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit

class VCProfile: BaseController {

    @IBOutlet var imgProfilePicture: UIImageView!
    @IBOutlet weak var txtUserName: UILabel!
    @IBOutlet weak var txtEmail: UILabel!
    @IBOutlet weak var txtPassword: UILabel!
    @IBOutlet weak var txtCnic: UILabel!
    @IBOutlet weak var txtGender: UILabel!
    @IBOutlet weak var txtCity: UILabel!
    @IBOutlet weak var txtAddress: UILabel!
    @IBOutlet weak var txtPhoneno: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgProfilePicture.makeRound()
        getUserProfile()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationBar()
        self.addBackButton()
        self.title = "Profile"
    }
    
    private func getUserProfile(){
        startLoading("")
        ProfileManager().getUserProfile(successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                self?.finishLoading()
                if let profileResponse = response{
                    print(profileResponse)
                }
            }
        })
        {[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.alertMessage(message: error.message.localized, completionHandler: nil)
            }
        }
    }
}

extension UIImageView{
    func  makeRound(){
        layer.cornerRadius = frame.size.width / 2
        layer.borderWidth = 1.0
        layer.masksToBounds = false
        layer.borderColor = UIColor.white.cgColor
        clipsToBounds = true
    }
}

extension UIButton{
    func makeRound(){
        layer.cornerRadius = frame.size.width / 2
        layer.borderWidth = 1.0
        layer.masksToBounds = false
        layer.borderColor = UIColor.white.cgColor
        clipsToBounds = true
    }
}


