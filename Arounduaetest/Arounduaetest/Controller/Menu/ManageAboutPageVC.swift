//
//  ManageAboutPageVC.swift
//  Arounduaetest
//
//  Created by Apple on 31/10/2018.
//  Copyright © 2018 MyComedy. All rights reserved.
//

import UIKit
import SDWebImage
import UITextView_Placeholder

class ManageAboutPageVC: UIViewController {

    @IBOutlet weak var storeImage: UIImageView!
    @IBOutlet weak var lblEnglishTextField: UITextView!
    @IBOutlet weak var lblArabicTextField: UITextView!
    var imagePicker = UIImagePickerController()
    var cameraPicker = UIImagePickerController()
    var storeObject:Stores!
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Manage Store About".localized
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setNavigationBar()
        if lang == "en"{
            addBackButton()
            lblEnglishTextField.textAlignment = .left
            lblArabicTextField.textAlignment = .left
        }else{
            showArabicBackButton()
            lblEnglishTextField.textAlignment = .right
            lblArabicTextField.textAlignment = .right
        }
        
        lblEnglishTextField.placeholder = "Description(English)"
        lblArabicTextField.placeholder = "Description(Arabic)"
    }
    
    private func setupData(){
        storeImage.sd_setShowActivityIndicatorView(true)
        storeImage.sd_setIndicatorStyle(.gray)
        storeImage.sd_setImage(with: URL(string: storeObject.image ?? ""))
        lblEnglishTextField.text = storeObject.description?.en ?? ""
        lblArabicTextField.text = storeObject.description?.ar ?? ""
    }
    
    @IBAction func editStoreImage(_ sender: UIButton) {
        picImage()
    }
    
    @IBAction func cancel(_ sender: UIButton){
        
    }
    
    private func isCheck()->Bool{
        
        guard let englishdescription = lblEnglishTextField.text, englishdescription.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter Description For English".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
        
        guard let arabicdescription = lblArabicTextField.text, arabicdescription.count > 0  else {
            let alertView = AlertView.prepare(title: "Alert".localized, message: "Please Enter Description For Arabic".localized, okAction: {
            })
            self.present(alertView, animated: true, completion: nil)
            return false
        }
       
        return true
    }
    
    @IBAction func submit(_ sender: UIButton){
        
        if !isCheck(){
            return
        }
        
        self.startLoading("")
        ProfileManager().aboutPage((lblEnglishTextField.text!,lblArabicTextField.text!,storeImage.image!,storeObject._id ?? ""),
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                self?.finishLoading()
                if let aboutResponse = response{
                    if aboutResponse.success!{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? aboutResponse.message?.en ?? "" : aboutResponse.message?.ar ?? "", completionHandler: {
                            self?.navigationController?.popViewController(animated: true)
                        })
                    }else{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? aboutResponse.message?.en ?? "" : aboutResponse.message?.ar ?? "", completionHandler: {
                             self?.navigationController?.popViewController(animated: true)
                        })
                    }
                }else{
                    self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: {
                         self?.navigationController?.popViewController(animated: true)
                    })
                }
            }
        })
        {[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.alertMessage(message: error.message.localized, completionHandler: {
                     self?.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
    private func picImage(){
        let alert = UIAlertController(title: "Store Picture".localized, message: nil, preferredStyle: .alert)
        
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
    
    func cancel() {
        self.imagePicker.dismiss(animated: true, completion: nil)
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
}

extension ManageAboutPageVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            storeImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
