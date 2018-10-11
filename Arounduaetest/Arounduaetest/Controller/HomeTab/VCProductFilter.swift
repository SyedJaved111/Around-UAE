//
//  VCProductFilter.swift
//  AroundUAE
//
//  Created by Macbook on 18/09/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import SwiftRangeSlider
import DropDown

class VCProductFilter: UIViewController {
    
    @IBOutlet weak var btnSearchclick: UIButtonMain!
    @IBOutlet weak var ViewRanger: RangeSlider!
    @IBOutlet weak var lblPriceRanger: UILabel!
    @IBOutlet weak var lblFilter: UILabel!
    @IBOutlet weak var txtfiledEnterKeyword: UITextField!
    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet weak var filterTableConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!

    var featuresArray = [FeatureCharacterData]()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.txtfiledEnterKeyword.setPadding(left: 10, right: 0)
        self.txtfiledEnterKeyword.txtfildborder()
        getFeatureWithCharacteristics()
    }
    
    private func setViewHeight(){
        filterTableConstraint.constant = filterTableView.contentSize.height + 50
        self.filterTableView.setNeedsDisplay()
    }
    
    private func getFeatureWithCharacteristics(){
        startLoading("")
        ProductManager().getFeaturesCharacters(
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                self?.finishLoading()
                if let productsResponse = response{
                    if productsResponse.success!{
                        self?.featuresArray = productsResponse.data ?? []
                        self?.filterTableView.reloadData()
                        self?.setViewHeight()
                    }
                    else{
                        self?.alertMessage(message: (productsResponse.message?.en ?? "").localized, completionHandler: {
                           self?.getFeatureWithCharacteristics()
                        })
                    }
                }else{
                      self?.alertMessage(message: (response?.message?.en ?? "").localized, completionHandler: {
                      self?.getFeatureWithCharacteristics()
                    })
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
                        self?.moveToFilteredProducts(products: productsResponse.data?.products ?? [])
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
    
    private func moveToFilteredProducts(products:[Products]){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCFilteredProductList") as! VCFilteredProductList
        vc.productarray = products
        self.navigationController?.pushViewController(vc, animated: true)
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

extension VCProductFilter: UITableViewDelegate,UITableViewDataSource,featureCellProtocol{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return featuresArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "featureCell", for: indexPath) as! featureCell
        cell.featureName.text = featuresArray[indexPath.row].title?.en ?? ""
        cell.delegate = self
        cell.menudropDown.anchorView = cell.backgroundBtn
        cell.menudropDown.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.menudropDown.selectionBackgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.menudropDown.dataSource = (featuresArray[indexPath.row].characteristics?.map({$0.title?.en ?? ""}))!
        cell.menudropDown.selectionAction = {(index: Int, item: String) in
            cell.featureName.text = item
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
    func didtap(cell:featureCell){
        cell.menudropDown.show()
    }
}

protocol featureCellProtocol  {
    func didtap(cell:featureCell)
}

class featureCell:UITableViewCell{
    
    @IBOutlet weak var backgroundBtn: UIButton!
    @IBOutlet weak var cellbackground: UIButtonMain!
    @IBOutlet weak var featureName: UILabel!
    var menudropDown = DropDown()
    var delegate:featureCellProtocol?
    
    @IBAction func didTap(_ sender: UIButton){
        delegate?.didtap(cell: self)
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
