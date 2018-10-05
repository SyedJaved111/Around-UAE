//
//  VCProductFilter.swift
//  AroundUAE
//
//  Created by Macbook on 18/09/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import SwiftRangeSlider

class VCProductFilter: UIViewController {
    
    @IBOutlet weak var lblsizecolor4: UILabel!
    @IBOutlet weak var lblsizecolor3: UILabel!
    @IBOutlet weak var lblsizecolor2: UILabel!
    @IBOutlet weak var lblsizecolor1: UILabel!
    @IBOutlet weak var btnSearchclick: UIButtonMain!
    @IBOutlet weak var ViewRanger: RangeSlider!
    @IBOutlet weak var lblPriceRanger: UILabel!
    @IBOutlet weak var lblFilter: UILabel!
    @IBOutlet weak var txtfiledEnterKeyword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtfiledEnterKeyword.setPadding(left: 10, right: 0)
        self.txtfiledEnterKeyword.txtfildborder()
    }
    
    private func searchProducts(){
        guard let txt = txtfiledEnterKeyword.text, txt.count > 0 else{
            alertMessage(message: "Please Enter Search Keyword..", completionHandler: nil)
            return
        }
        
        startLoading("")
        ProductManager().SearchProduct(txt,
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                self?.finishLoading()
                if let productsResponse = response{
                    if productsResponse.success!{
                      self?.alertMessage(message:"Product(s)".localized, completionHandler: nil)
                    }
                    else{
                      self?.alertMessage(message: (productsResponse.message?.en ?? "").localized, completionHandler: nil)
                    }
                }else{
                   self?.alertMessage(message: (response?.message?.en ?? "").localized, completionHandler: nil)
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
    
    @IBAction func Click1(_ sender: UIButton){
        
    }
    
    @IBAction func Click2(_ sender: UIButton){
        
    }
    
    @IBAction func Click3(_ sender: UIButton){
        
    }
    
    @IBAction func Click4(_ sender: UIButton){
        
    }
    
    @IBAction func btnSearch(_ sender: UIButton){
        searchProducts()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Search"
        self.setNavigationBar()
        self.addBackButton()
    }

}
extension UITextField{
    
    func txtfildborder(){
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 3
        self.layer.borderColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
        self.clipsToBounds = true
    }
}
