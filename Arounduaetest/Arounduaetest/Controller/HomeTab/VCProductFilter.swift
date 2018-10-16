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
    var filterdata:FilterData?
    var filterArray = [Int]()
    var max = 0.0
    var min = 0.0
    var counter = 0
    var groupIndex = 0
    var divisionIndex = 0
    var isDivisonShown = false
    var isSectionShown = false
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.txtfiledEnterKeyword.setPadding(left: 10, right: 0)
        self.txtfiledEnterKeyword.txtfildborder()
        getFeatureWithCharacteristics()
        getFilterSearcData()
    }
    
    private func setViewHeight(){
        filterTableConstraint.constant = filterTableView.contentSize.height + 135
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
    
    private func getFilterSearcData(){
        IndexManager().getSearchFilterData(successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                self?.finishLoading()
                if let filterResponse = response{
                    if filterResponse.success!{
                        self?.filterdata = filterResponse.data
                        self?.filterArray.append(1)
                        self?.filterTableView.reloadData()
                        self?.setViewHeight()
                    }
                    else{
                        self?.alertMessage(message: (filterResponse.message?.en ?? "").localized, completionHandler: {
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
    
    @IBAction func rangeSliderValuesChanged(_ rangeSlider: RangeSlider){
        max = rangeSlider.upperValue
        min = rangeSlider.lowerValue
    }
    
    private func searchProducts(){
        guard let txt = txtfiledEnterKeyword.text, txt.count > 0 else{
            alertMessage(message: "Please Enter Search Keyword..", completionHandler: nil)
            return
        }
        
        if ViewRanger.maximumValue == 0.0{
            max = -1
        }
        
        if ViewRanger.minimumValue == 0.0{
            min = -1
        }
        
        startLoading("")
        ProductManager().SearchProduct(("",min,max,[String](),txt),
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
         NotificationCenter.default.post(name: Notification.Name("SearchCompleted"), object: products)
         self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSearch(_ sender: UIButton){
        searchProducts()
    }
   
    override func viewWillAppear(_ animated: Bool){
        self.title = "Search"
        self.setNavigationBar()
        self.addBackButton()
    }
}

extension VCProductFilter: UITableViewDelegate,UITableViewDataSource,featureCellProtocol{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return featuresArray.count
        }else{
            return filterArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "featureCell", for: indexPath) as! featureCell
        var groupsarray = [String]()
        var divisionsarray = [String]()
        
        cell.delegate = self
        cell.menudropDown.anchorView = cell.backgroundBtn
        cell.menudropDown.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.menudropDown.selectionBackgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        if indexPath.section == 0{
            cell.featureName.text = featuresArray[indexPath.row].title?.en ?? ""
            cell.menudropDown.dataSource = (featuresArray[indexPath.row].characteristics?.map({$0.title?.en ?? ""})) ?? []
            cell.menudropDown.selectionAction = {(index: Int, item: String) in
            cell.featureName.text = item
            }
        }else{
            if indexPath.row == 0{
                groupsarray = (filterdata?.groups?.map({$0.title?.en ?? ""})) ?? []
                groupsarray.insert("Select Group", at: 0)
                cell.menudropDown.dataSource = groupsarray
                cell.featureName.text = groupsarray.first ?? ""
                cell.menudropDown.selectionAction = {[weak self](index: Int, item: String) in
                cell.featureName.text = item
                self?.groupIndex = index
                //self?.filterTableView.reloadData()
                  if !(self?.isDivisonShown)! && index != 0{
                    self?.counter = (self?.counter ?? 0) + 1
                    self?.filterArray.append(self?.counter ?? 0)
                    self?.filterTableView.reloadData()
                    self?.setViewHeight()
                 }
              }
            }else if indexPath.row == 1{
                isDivisonShown = true
                divisionsarray = (filterdata?.groups?[groupIndex].divisions?.map({$0.title?.en ?? ""})) ?? []
                divisionsarray.insert("Select Division", at: 0)
                cell.menudropDown.dataSource = divisionsarray
                cell.featureName.text = divisionsarray.first ?? ""
                cell.menudropDown.selectionAction = {[weak self](index: Int, item: String) in
                    cell.featureName.text = item
                    self?.divisionIndex = index
                    self?.filterTableView.reloadData()
                    if !(self?.isSectionShown)! && index != 0{
                        self?.counter = (self?.counter ?? 0) + 1
                        self?.filterArray.append(self?.counter ?? 0)
                        self?.filterTableView.reloadData()
                        self?.setViewHeight()
                    }
                }
            }else{
                isSectionShown = true
                
                cell.menudropDown.dataSource = (filterdata?.groups?[groupIndex].divisions?[divisionIndex].sections?.map({$0.title?.en ?? ""})) ?? []
                cell.menudropDown.selectionAction = {(index: Int, item: String) in
                    cell.featureName.text = item
                }
            }
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
    
    private func addSelectedCell(){
        filterTableView.beginUpdates()
        filterTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        filterTableView.endUpdates()
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
