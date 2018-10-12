//
//  VCPopUp.swift
//  AroundUAE
//
//  Created by Macbook on 24/09/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import Cosmos

var productid:String?
var placeid:String?
var storeid:String?

class VCPopUp: UIViewController {

    @IBOutlet var lblHowsExperience: UILabel!
    @IBOutlet var lblSubmitFeedBack: UILabel!
    @IBOutlet var textViewWriteComments: UICustomTextView!
    @IBOutlet var btnCancel: UIButtonMain!
    @IBOutlet var btnSubmit: UIButtonMain!
    @IBOutlet weak var ratingView: CosmosView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textViewWriteComments.delegate = self
        textViewWriteComments.text = "Comment..."
        textViewWriteComments.textColor = UIColor.lightGray
    }
    
    @IBAction func btnAction(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        lblSubmitFeedBack.text = "Submit Feedback".localized
        //lblSubmitFeedBack.text = "Hows was your experience with instinct Store?".localized
        //textViewWriteComments.text = "Write Comments...".localized
        btnSubmit.setTitle("Submit".localized, for: .normal)
        btnCancel.setTitle("Cancel".localized, for: .normal)
    }
    
    private func isCheckReview()->Bool{
        guard let comment = textViewWriteComments.text, comment != "Comment..." else{
            self.alertMessage(message: "Please Enter Your Comment!", completionHandler: nil)
            return false
        }
        return true
    }
    
    @IBAction func submit(_ sender: Any){
        if !isCheckReview(){
            return
        }
        if let _ = placeid{
           placeReview()
        }else if let _ = storeid{
           storeReview()
        }else if let _ = productid{
           productReview()
        }
    }
    
    private func storeReview(){
        startLoading("")
        StoreManager().storeReview((storeid!,"\(ratingView.rating)",textViewWriteComments.text!),
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async{
                self?.finishLoading()
                if let reviewResponse = response{
                    if reviewResponse.success!{
                        self?.alertMessage(message: reviewResponse.message?.en ?? "", completionHandler: nil)
                    }else{
                        self?.alertMessage(message: reviewResponse.message?.en ?? "", completionHandler: nil)
                    }
                }else{
                    self?.alertMessage(message: response?.message?.en ?? "", completionHandler: nil)
                }
            }
        })
        {[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.alertMessage(message: error.message, completionHandler: nil)
            }
        }
    }
    
    private func placeReview(){
        startLoading("")
        CitiesPlacesManager().submitPlaceReview((placeid!,"\(ratingView.rating)",textViewWriteComments.text!),
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async{
                self?.finishLoading()
                if let reviewResponse = response{
                    if reviewResponse.success!{
                        self?.alertMessage(message: reviewResponse.message?.en ?? "", completionHandler: nil)
                    }else{
                        self?.alertMessage(message: reviewResponse.message?.en ?? "", completionHandler: nil)
                    }
                }else{
                    self?.alertMessage(message: response?.message?.en ?? "", completionHandler: nil)
                }
            }
        })
        {[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.alertMessage(message: error.message, completionHandler: nil)
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }
    
    private func productReview(){
        startLoading("")
        ProductManager().submitProductReview((productid!,"\(ratingView.rating)",textViewWriteComments.text!),
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async{
                self?.finishLoading()
                if let reviewResponse = response{
                    if reviewResponse.success!{
                        self?.alertMessage(message: reviewResponse.message?.en ?? "", completionHandler: nil)
                    }else{
                        self?.alertMessage(message: reviewResponse.message?.en ?? "", completionHandler: nil)
                    }
                }else{
                    self?.alertMessage(message: response?.message?.en ?? "", completionHandler: nil)
                }
            }
        })
        {[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.alertMessage(message: error.message, completionHandler: nil)
            }
        }
    }
}

extension VCPopUp: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textViewWriteComments.textColor == UIColor.lightGray {
            textViewWriteComments.text = nil
            textViewWriteComments.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textViewWriteComments.text.isEmpty {
            textViewWriteComments.text = "Commint..."
            textViewWriteComments.textColor = UIColor.lightGray
        }
    }
}
