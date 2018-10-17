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
var isFromHome = false
class VCProductFilter: UIViewController {
    
    @IBOutlet weak var btnSearchclick: UIButtonMain!
    @IBOutlet weak var ViewRanger: RangeSlider!
    @IBOutlet weak var lblPriceRanger: UILabel!
    @IBOutlet weak var lblFilter: UILabel!
    @IBOutlet weak var txtfiledEnterKeyword: UITextField!
    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet weak var filterTableConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var selectGroupBtn: UIButton!
    @IBOutlet weak var selectDivisionBtn: UIButton!
    @IBOutlet weak var selectSectionBtn: UIButton!
    
    @IBOutlet weak var selectGroupArrow: UIImageView!
    @IBOutlet weak var selectDivisionArrow: UIImageView!
    @IBOutlet weak var selectSectionArrow: UIImageView!
    
    @IBOutlet weak var selectGrouplbl: UILabel!
    @IBOutlet weak var selectDivisionlbl: UILabel!
    @IBOutlet weak var selectSectionlbl: UILabel!
    
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
        filterTableConstraint.constant = filterTableView.contentSize.height + 28
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
                        self?.filterdata?.groups?.insert(Groups(title:Title(en:"Select Group", ar: ""), divisions: nil, image: nil, isActive: nil, isFeatured: nil, _id: nil), at: 0)
                        
                        for var obj in (self?.filterdata?.groups) ?? []{
                              obj.divisions?.insert(Divisions(title: Title(en:"Select Division", ar: ""), sections: nil, image: nil, isActive: nil, _id: nil), at: 0)
                            for var ob in obj.divisions ?? []{
                              ob.sections?.insert(Sections(title: Title(en:"Select Division", ar: ""), image: nil, isActive: nil, _id: nil), at: 0)
                            }
                        }
                        
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
        
        if isFromHome{
            let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "VCProducList") as! VCProducList
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnSearch(_ sender: UIButton){
        searchProducts()
    }
   
    override func viewWillAppear(_ animated: Bool){
        self.title = "Search"
        self.setNavigationBar()
        self.addBackButton()
    }
    
    @IBAction func groupSelection(_ sender: UIButton){
        let menudropDown = DropDown()
        menudropDown.anchorView = sender
        menudropDown.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        menudropDown.selectionBackgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let groupsarray = (filterdata?.groups?.map({$0.title?.en ?? ""})) ?? []
        menudropDown.dataSource = groupsarray
        menudropDown.selectionAction = {(index: Int, item: String) in
            self.groupIndex = index
            self.selectGrouplbl.text = item
            
            if item == "Select Group"{
                self.selectSectionBtn.isHidden = true
                self.selectSectionlbl.isHidden = true
                self.selectSectionArrow.isHidden = true
                
                self.selectDivisionBtn.isHidden = true
                self.selectDivisionlbl.isHidden = true
                self.selectDivisionArrow.isHidden = true
                
            }else{
                self.selectDivisionlbl.text = "Select Divison"
                self.selectDivisionBtn.isHidden = false
                self.selectDivisionlbl.isHidden = false
                self.selectDivisionArrow.isHidden = false
            }
        }
        menudropDown.show()
    }
    
    @IBAction func divisionSelection(_ sender: UIButton){
        let menudropDown = DropDown()
        menudropDown.anchorView = sender
        menudropDown.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        menudropDown.selectionBackgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let divisionsarray = (filterdata?.groups?[groupIndex].divisions?.map({$0.title?.en ?? ""})) ?? []
        menudropDown.dataSource = divisionsarray
        menudropDown.selectionAction = {(index: Int, item: String) in
            self.divisionIndex = index
            self.selectDivisionlbl.text = item
            
            if item == "Select Division"{
                self.selectSectionBtn.isHidden = true
                self.selectSectionlbl.isHidden = true
                self.selectSectionArrow.isHidden = true
            }else{
                self.selectSectionlbl.text = "Select Section"
                self.selectSectionBtn.isHidden = false
                self.selectSectionlbl.isHidden = false
                self.selectSectionArrow.isHidden = false
            }
        }
        menudropDown.show()
    }
    
    @IBAction func sectionSelection(_ sender: UIButton){
        let menudropDown = DropDown()
        menudropDown.anchorView = sender
        menudropDown.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        menudropDown.selectionBackgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        guard let _ = filterdata?.groups?[safe:groupIndex]?.divisions?[safe:divisionIndex]?.sections else {
            return
        }
        
        let sectionsarray = (filterdata?.groups?[groupIndex].divisions?[divisionIndex].sections?.map({$0.title?.en ?? ""})) ?? []
        menudropDown.dataSource = sectionsarray
        menudropDown.selectionAction = {(index: Int, item: String) in
            if item == "Select Section"{
                self.selectSectionlbl.text = "Select Section"
            }else{
                self.selectSectionlbl.text = item
            }
        }
        menudropDown.show()
    }
}

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension VCProductFilter: UITableViewDelegate,UITableViewDataSource,featureCellProtocol{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return featuresArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "featureCell", for: indexPath) as! featureCell
        cell.delegate = self
        cell.menudropDown.anchorView = cell.backgroundBtn
        cell.menudropDown.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.menudropDown.selectionBackgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.featureName.text = featuresArray[indexPath.row].title?.en ?? ""
        cell.menudropDown.dataSource = (featuresArray[indexPath.row].characteristics?.map({$0.title?.en ?? ""})) ?? []
        cell.menudropDown.selectionAction = {(index: Int, item: String) in
        cell.featureName.text = item}
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
