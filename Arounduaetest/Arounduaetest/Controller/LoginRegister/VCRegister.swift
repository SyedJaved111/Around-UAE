//
//  VCRegister.swift
//  AroundUAE
//
//  Created by Apple on 12/09/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import DLRadioButton
import Photos
import CountryPicker
import GooglePlaces
import FlagKit

class VCRegister: BaseController{
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtPasspord: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var countryPicker: CountryPicker!
    @IBOutlet weak var countryPickerMainView: UIView!
    @IBOutlet weak var txtAttachNIC: UIButton!{
        didSet{
           txtAttachNIC.titleLabel?.textAlignment = NSTextAlignment.center
        }
    }
    @IBOutlet weak var lblGenderText: UILabel!
    @IBOutlet weak var radioMale: DLRadioButton!
    @IBOutlet weak var radioFemale: DLRadioButton!
    @IBOutlet weak var btnRegister: UIButtonMain!
    @IBOutlet weak var lblAlreadyHaveAnAccount: UILabel!
    @IBOutlet weak var btnLoginNow: UIButton!
    @IBOutlet weak var subScrollView: UIView!
    
    var imagePicker = UIImagePickerController()
    var cameraPicker = UIImagePickerController()
    var imgNic: UIImage?
    let fileName = "Nic_pic"
    var code = "AE"
    var image:UIImage!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        radioMale.isSelected = true
        self.txtAttachNIC.titleLabel?.text = "Attach NIC Copy"
        
        if(lang == "en"){
            self.txtAttachNIC.titleLabel?.textAlignment = .left
        } else if(lang == "ar")
        {
            self.txtAttachNIC.titleLabel?.textAlignment = .right
        }
        
        setupTxtPhone()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        self.countryPickerMainView.addGestureRecognizer(tap)
        txtAddress.delegate = self
    }

    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(true)
        
        
        
        self.setNavigationBar()
       // self.addBackButton()
        self.setupLocalization()
        
        
    }
    
    
    
    
    private func setupTxtPhone(){
        self.txtPhoneNumber.delegate = self
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            self.txtPhoneNumber.text = UITextField.getCountryPhonceCode(countryCode)
            self.countryPicker.setCountry(countryCode)
            image = Flag(countryCode: countryCode)!.originalImage
            self.countryPicker.countryPickerDelegate = self
            self.txtPhoneNumber.keyboardType = .numberPad
            addButton()
        }
    }
    
    fileprivate func addButton(){
        if(lang == "en"){
        let button = UIButton()
        button.setImage(image!, for: .normal)
        button.frame = CGRect(x: 15, y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.addBtn), for: .touchUpInside)
        txtPhoneNumber.leftView = button
        txtPhoneNumber.leftViewMode = .always
    }else if(lang == "ar")
        {
            let button = UIButton()
            button.setImage(image, for: .normal)
            button.frame = CGRect(x: CGFloat(5), y:15 , width: CGFloat(25), height: CGFloat(25))
            button.addTarget(self, action: #selector(self.addBtn), for: .touchUpInside)
            txtPhoneNumber.rightView = button
            txtPhoneNumber.rightViewMode = .always
        }
    }
    
    @objc func addBtn(_ sender: Any) {
        self.view.addSubview(self.countryPickerMainView)
        self.view.center = self.countryPickerMainView.center
        self.subScrollView.isHidden = true
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        self.countryPickerMainView.removeFromSuperview()
        self.subScrollView.isHidden = false
    }
    
    
    private func setupLocalization(){
        self.title = "Register".localized
        
        self.txtFirstName.setPadding(left: 10, right: 0)
        
        
        self.txtLastName.setPadding(left: 10, right: 0)
        
        
        self.txtEmail.setPadding(left: 10, right: 0)
        
        
        self.txtPhoneNumber.setPadding(left: 10, right: 0)
        
        
        self.txtPasspord.setPadding(left: 10, right: 0)
        
        
        self.txtConfirmPassword.setPadding(left: 10, right: 0)
        
        
        self.txtAddress.setPadding(left: 10, right: 0)
        
        
        self.lblGenderText.text = "Gender".localized
        self.radioMale.setTitle("Male".localized, for: .normal)
        self.radioFemale.setTitle("Female".localized, for: .normal)
        self.btnRegister.setTitle("Register".localized, for: .normal)
        self.lblAlreadyHaveAnAccount.text = "Already have an account?".localized
        self.btnLoginNow.setTitle("Login now".localized, for: .normal)
        
        
        self.txtAddress.placeholder = "Address".localized
        self.txtLastName.placeholder = "Last Name".localized
        self.txtPhoneNumber.placeholder = "Phone no".localized
        self.txtFirstName.placeholder = "First Name".localized
        self.txtAttachNIC.setTitle("Attach NIC Copy".localized, for: .normal)
        self.txtConfirmPassword.placeholder = "Confirm Password".localized
        self.txtPasspord.placeholder = "Password".localized
        self.txtEmail.placeholder = "Email".localized
        
        
        if(lang == "ar")
        {
            self.showArabicBackButton()
            self.txtAddress.textAlignment = .right
            self.txtLastName.textAlignment = .right
            self.txtPhoneNumber.textAlignment = .right
            self.txtFirstName.textAlignment = .right
            
            self.txtConfirmPassword.textAlignment = .right
            self.txtPasspord.textAlignment = .right
            self.txtEmail.textAlignment = .right
            
        }else if(lang == "en")
        {
            self.addBackButton()
            self.txtAddress.textAlignment = .left
            self.txtLastName.textAlignment = .left
            self.txtPhoneNumber.textAlignment = .left
            self.txtFirstName.textAlignment = .left
            
            self.txtConfirmPassword.textAlignment = .left
            self.txtPasspord.textAlignment = .left
            self.txtEmail.textAlignment = .left
            
        }
    }
    
    
    
    @IBAction func attachNic(_ sender: UIButton) {
        picNicImage()
    }
    
    private func picNicImage(){
        let alert = UIAlertController(title: "Nic Picture".localized, message: nil, preferredStyle: .alert)
        let cameraAction = UIAlertAction(title: "Camera".localized, style: .default) {
            UIAlertAction in self.openCamera()
        }
        let libraryAction = UIAlertAction(title: "Library".localized, style: .default) { (action) in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .default) {
            UIAlertAction in self.cancel()
        }
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraPicker.sourceType = .camera
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = false
            self.present(cameraPicker, animated: true, completion: nil)
        }
        else {
            let alertView = AlertView.prepare(title: "Error".localized, message: "Camera not Available".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
        }
    }
    
    private func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
        else {
            print("Not Available")
        }
    }
    
    func cancel() {
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
    
    private func isCheck()->Bool{
        
        guard let firstName = txtFirstName.text, firstName.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter FirstName".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        guard let lastName = txtLastName.text, lastName.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter LastName".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        guard let email = txtEmail.text, email.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter Email".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        if !email.isValidEmail{
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter Valid Email".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        guard let phoneNumber = txtPhoneNumber.text, phoneNumber.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter PhoneNumber".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        if !phoneNumber.isPhoneNumber{
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter Valid PhoneNumber".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        guard let password = txtPasspord.text, password.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter Password".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        if password.count < 6 {
            let alertView = AlertView.prepare(title: "Error".localized, message: "Please Enter Password Below 6 Characters".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        guard let confirmpassword = txtConfirmPassword.text, confirmpassword.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter Confirm Password".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        if(password != confirmpassword) {
            let alertView = AlertView.prepare(title: "Error".localized, message: "Password do not matched".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        guard let address = txtAddress.text, address.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter Address".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        guard let _ = imgNic else{
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Select Nic Image".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    @IBAction func btnRegisterClick(_ sender: Any){
        let gender = (radioMale.isSelected) ? "male" : "female"
        if isCheck(){
            self.register(userfullname: txtFirstName.text!+txtLastName.text!, useremail: txtEmail.text!,
            userphone: txtPhoneNumber.text!, userpassword: txtPasspord.text!,
            userpasswordConfirm: txtConfirmPassword.text!, useraddresss: txtAddress.text!,
            userImage: imgNic!, usergender: gender, usernic: Data())
        }
    }
    
    @IBAction func btnLoginNowClick(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    private func register(userfullname:String, useremail:String,
        userphone: String, userpassword:String, userpasswordConfirm:String,
        useraddresss:String, userImage: UIImage, usergender:String, usernic: Data){
          startLoading("")
          let params = (userfullname,useremail, userphone,userpassword,userpasswordConfirm,useraddresss,usernic,usergender)
          AuthManager().registerUser(params,userImage: userImage,
          successCallback:
          {[weak self](response) in
             DispatchQueue.main.async {
                self?.finishLoading()
                if let Response = response{
                    if(Response.success ?? false == true){
                        self?.alertMessage(message: Response.message?.en ?? "", completionHandler: {
                            self?.navigationController?.popViewController(animated: true)
                        })
                    }else{
                        self?.alertMessage(message: Response.message?.en ?? "", completionHandler: nil)
                    }
                }else{
                    self?.alertMessage(message: "Error",completionHandler: nil)
                 }
              }
          })
          {[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.alertMessage(message: error.message,completionHandler: nil)
              }
          }
     }
}

extension VCRegister: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.imgNic = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.txtAttachNIC.titleLabel?.text = fileName
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension VCRegister: CountryPickerDelegate{
    func countryPhoneCodePicker(_ picker: CountryPicker,
                                didSelectCountryWithName name: String,
                                countryCode: String,
                                phoneCode: String,
                                flag: UIImage) {
        self.txtPhoneNumber.text = phoneCode
        let flag = Flag(countryCode: countryCode)!
        self.image = flag.originalImage
        self.code = phoneCode
        self.addButton()
    }
}

extension VCRegister: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.txtPhoneNumber {
            let char = string.cString(using: String.Encoding.utf8)
            let isBackSpace = strcmp(char, "\\b")
            
            if isBackSpace == -92 {
                
                if self.txtPhoneNumber.text == code{
                    self.txtPhoneNumber.text = code
                    return false
                }
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.txtAddress {
            let autoComplete = GMSAutocompleteViewController()
            autoComplete.delegate = self
            UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.8678156137, green: 0.2703827024, blue: 0.368032515, alpha: 1)
            UINavigationBar.appearance().tintColor = UIColor.white
            present(autoComplete, animated: true, completion: nil)
        }
    }
}

extension VCRegister: GMSAutocompleteViewControllerDelegate {
   
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    
        txtAddress.text = place.name
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}
