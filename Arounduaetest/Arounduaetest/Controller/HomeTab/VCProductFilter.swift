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
    @IBOutlet weak var searchBtnHeight: NSLayoutConstraint!
    
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
    let dispatchGroup = DispatchGroup()
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.txtfiledEnterKeyword.setPadding(left: 10, right: 0)
        self.txtfiledEnterKeyword.txtfildborder()
        getFeatureWithCharacteristics()
        getFilterSearcData()
        dispatchGroup.notify(queue: .main) {
            self.selectGroupBtn.isHidden = false
            self.selectGroupArrow.isHidden = false
            self.selectGrouplbl.isHidden = false
            self.btnSearchclick.isHidden = false
            self.setViewHeight()
            self.finishLoading()
        }
    }
    
    private func setViewHeight(){
        filterTableConstraint.constant = filterTableView.contentSize.height + 10
        self.filterTableView.setNeedsDisplay()
    }
    
    private func getFeatureWithCharacteristics(){
        startLoading("")
        dispatchGroup.enter()
        ProductManager().getFeaturesCharacters(
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                self?.dispatchGroup.leave()
                if let productsResponse = response{
                    if productsResponse.success!{
                        self?.featuresArray = productsResponse.data ?? []
                        self?.filterTableView.reloadData()
                        self?.setViewHeight()
                    }
                    else{
                        if(lang == "en")
                        {
                        self?.alertMessage(message: (productsResponse.message?.en ?? "").localized, completionHandler: {
                           self?.getFeatureWithCharacteristics()
                        })
                            
                        }else
                        {
                            self?.alertMessage(message: (productsResponse.message?.ar ?? "").localized, completionHandler: {
                                self?.getFeatureWithCharacteristics()})
                        }
                    }
                }else{
                    if(lang == "en"){
                      self?.alertMessage(message: (response?.message?.en ?? "").localized, completionHandler: {
                      self?.getFeatureWithCharacteristics()
                      })
                        
                    }else
                    {
                        self?.alertMessage(message: (response?.message?.ar ?? "").localized, completionHandler: {
                            self?.getFeatureWithCharacteristics()
                        })
                    }
                }
            }
        })
        {[weak self](error) in
            DispatchQueue.main.async {
                self?.dispatchGroup.leave()
                self?.finishLoading()
                self?.alertMessage(message: error.message.localized, completionHandler: nil)
            }
        }
    }
    
    private func getFilterSearcData(){
        dispatchGroup.enter()
        IndexManager().getSearchFilterData(successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                self?.dispatchGroup.leave()
                if let filterResponse = response{
                    if filterResponse.success!{
                        self?.filterdata = filterResponse.data
                        self?.filterdata?.groups?.insert(Groups(title: Title(en: "Select Group", ar: nil), divisions: nil, image: nil, isActive: nil, isFeatured: nil, _id: nil), at: 0)
                        self?.filterTableView.reloadData()
                    }
                    else{
                        if(lang == "en")
                        {
                        self?.alertMessage(message: (filterResponse.message?.en ?? "").localized, completionHandler: {
                            self?.getFeatureWithCharacteristics()
                        })
                        }else
                        {
                            self?.alertMessage(message: (filterResponse.message?.ar ?? "").localized, completionHandler: {
                                self?.getFeatureWithCharacteristics()
                            })
                        }
                    }
                }else{
                    if(lang == "en")
                    {
                    self?.alertMessage(message: (response?.message?.en ?? "").localized, completionHandler: {
                        self?.getFeatureWithCharacteristics()
                    })
                    }else{
                        self?.alertMessage(message: (response?.message?.ar ?? "").localized, completionHandler: {
                            self?.getFeatureWithCharacteristics()
                        })
                        
                    }
                }
            }
        })
        {[weak self](error) in
            DispatchQueue.main.async {
                self?.dispatchGroup.leave()
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
            alertMessage(message: "Please Enter Search Keyword..".localized, completionHandler: nil)
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
                        if(lang == "en")
                        {
                      self?.alertMessage(message: (productsResponse.message?.en ?? "").localized, completionHandler: nil)
                        }else{
                             self?.alertMessage(message: (productsResponse.message?.ar ?? "").localized, completionHandler: nil)
                        }
                        
                    }
                }else{
                    if(lang == "en")
                    {
                   self?.alertMessage(message: (response?.message?.en ?? "").localized, completionHandler: nil)
                    }else
                    {
                         self?.alertMessage(message: (response?.message?.ar ?? "").localized, completionHandler: nil)
                    }
                    
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
        if isFromHome{
            NotificationCenter.default.post(name: Notification.Name("SearchCompleted"), object: products)
            self.navigationController?.popViewController(animated: true)
        }else{
            let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "VCProducList") as! VCProducList
            searchKeyword = txtfiledEnterKeyword.text!
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnSearch(_ sender: UIButton){
        searchProducts()
    }
   
    override func viewWillAppear(_ animated: Bool){
        self.title = "Search".localized
        self.setNavigationBar()
        if(lang == "en")
        {
            self.addBackButton()
        }else
        {
            self.showArabicBackButton()
        }
        
    }
    
    @IBAction func groupSelection(_ sender: UIButton){
    
        let menudropDown = DropDown()
        menudropDown.anchorView = sender
        menudropDown.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        menudropDown.selectionBackgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        if(lang == "en")
        {
        let groupsarray = (filterdata?.groups?.map({$0.title?.en ?? ""})) ?? []
            menudropDown.dataSource = groupsarray
        }else{
             let groupsarray = (filterdata?.groups?.map({$0.title?.ar ?? ""})) ?? []
                menudropDown.dataSource = groupsarray
        }
        
        menudropDown.selectionAction = {(index: Int, item: String) in
            self.groupIndex = index
            self.selectGrouplbl.text = item
            
            if item == "Select Group"{
                self.searchBtnHeight.constant = 25
                self.view.setNeedsDisplay()
                self.selectSectionBtn.isHidden = true
                self.selectSectionlbl.isHidden = true
                self.selectSectionArrow.isHidden = true
                
                self.selectDivisionBtn.isHidden = true
                self.selectDivisionlbl.isHidden = true
                self.selectDivisionArrow.isHidden = true
                
            }else{
                self.searchBtnHeight.constant = 78
                self.view.setNeedsDisplay()
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
        if(lang == "en")
        {
        var divisionsarray = (filterdata?.groups?[groupIndex].divisions?.map({$0.title?.en ?? ""})) ?? []
        divisionsarray.insert("Select Division", at: 0)
        menudropDown.dataSource = divisionsarray
        }else{
            var divisionsarray = (filterdata?.groups?[groupIndex].divisions?.map({$0.title?.ar ?? ""})) ?? []
            divisionsarray.insert("Select Division", at: 0)
             menudropDown.dataSource = divisionsarray
        }
       
        menudropDown.selectionAction = {(index: Int, item: String) in
            self.divisionIndex = index
            self.selectDivisionlbl.text = item
            
            if item == "Select Division"{
                self.searchBtnHeight.constant = 78
                self.view.setNeedsDisplay()
                self.selectSectionBtn.isHidden = true
                self.selectSectionlbl.isHidden = true
                self.selectSectionArrow.isHidden = true
            }else{
                self.searchBtnHeight.constant = 136
                self.view.setNeedsDisplay()
                self.selectSectionlbl.text = "Select Section"
                self.selectSectionBtn.isHidden = false
                self.selectSectionlbl.isHidden = false
                self.selectSectionArrow.isHidden = false
            }
        }
        menudropDown.show()
    }
    
    @IBAction func sectionSelection(_ sender: UIButton){
        searchBtnHeight.constant = 136
        self.view.setNeedsDisplay()
        let menudropDown = DropDown()
        menudropDown.anchorView = sender
        menudropDown.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        menudropDown.selectionBackgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        guard let _ = filterdata?.groups?[safe:groupIndex]?.divisions?[safe:divisionIndex]?.sections else {
            return
        }
        if(lang == "en")
        {
        var sectionsarray = (filterdata?.groups?[groupIndex].divisions?[divisionIndex].sections?.map({$0.title?.en ?? ""})) ?? []
        sectionsarray.insert("Select Selection", at: 0)
        menudropDown.dataSource = sectionsarray
        }else
        {
            var sectionsarray = (filterdata?.groups?[groupIndex].divisions?[divisionIndex].sections?.map({$0.title?.ar ?? ""})) ?? []
            sectionsarray.insert("Select Selection", at: 0)
            menudropDown.dataSource = sectionsarray
            
        }
        menudropDown.selectionAction = {(index: Int, item: String) in
            
            if item == "Select Section"{
                if(lang == "en"){
                self.selectSectionlbl.text = "Select Section".localized
                }
                else
                {
                     self.selectSectionlbl.text = "Select Section".localized
                }
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
        if(lang == "en")
        {
        cell.featureName.text = featuresArray[indexPath.row].title?.en ?? ""
        var array = (featuresArray[indexPath.row].characteristics?.map({$0.title?.en ?? ""})) ?? []
        array.insert("Select", at: 0)
        cell.menudropDown.dataSource = array
        }else
        {
            cell.featureName.text = featuresArray[indexPath.row].title?.ar ?? ""
            var array = (featuresArray[indexPath.row].characteristics?.map({$0.title?.ar ?? ""})) ?? []
            array.insert("Select", at: 0)
            cell.menudropDown.dataSource = array
        }
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
        self.layer.borderColor = #colorLiteral(red: 0.7025088241, green: 0.7148430643, blue: 0.7723167519, alpha: 1)
        self.clipsToBounds = true
    }
}
