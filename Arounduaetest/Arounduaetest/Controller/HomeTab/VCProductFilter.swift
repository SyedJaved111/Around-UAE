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
    @IBOutlet weak var lblFilter: UILabel!
    @IBOutlet weak var txtfiledEnterKeyword: UITextField!
    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet weak var filterTableConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var selectGroupBtn: UIButton!
    @IBOutlet weak var selectDivisionBtn: UIButton!
    @IBOutlet weak var selectSectionBtn: UIButton!
    @IBOutlet weak var selectManufacturesBtn: UIButton!
    
    @IBOutlet weak var selectGroupArrow: UIImageView!
    @IBOutlet weak var selectDivisionArrow: UIImageView!
    @IBOutlet weak var selectSectionArrow: UIImageView!
    @IBOutlet weak var selectManufacturesArrow: UIImageView!
    
    @IBOutlet weak var selectGrouplbl: UILabel!
    @IBOutlet weak var selectDivisionlbl: UILabel!
    @IBOutlet weak var selectSectionlbl: UILabel!
    @IBOutlet weak var selectManufactureslbl: UILabel!
    
    @IBOutlet weak var selectGroupHeader: UILabel!
    @IBOutlet weak var selectDivisionHeader: UILabel!
    @IBOutlet weak var selectSectionHeader: UILabel!
    @IBOutlet weak var selectManufacturesHeader: UILabel!
    
    @IBOutlet weak var searchBtnHeight: NSLayoutConstraint!
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    var featuresArray = [Features]()
    var filterdata = [GroupDivisonData]()
    var filtersearchdata:FilterSeachData?
    var filterArray = [Int]()
    var max = 0.0
    var min = 0.0
    var counter = 0
    var groupIndex = 0
    var divisionIndex = 0
    var isDivisonShown = false
    var isSectionShown = false
    let dispatchGroup = DispatchGroup()
    var selectedDivision: Divisions?
    var selectedSection:Sections?
    var selectedManufactorId:String?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.txtfiledEnterKeyword.setPadding(left: 10, right: 0)
        self.txtfiledEnterKeyword.txtfildborder()
        getFilterSearcData()
        dispatchGroup.notify(queue: .main) {
            self.selectGroupBtn.isHidden = false
            self.selectGroupArrow.isHidden = false
            self.selectGrouplbl.isHidden = false
            self.btnSearchclick.isHidden = false
            //self.setViewHeight()
            self.finishLoading()
        }
    }
    
    override func viewWillAppear(_ animated: Bool){
        self.title = "Search".localized
        self.setNavigationBar()
        if(lang == "en"){
            self.addBackButton()
        }else{
            self.showArabicBackButton()
        }
        
        self.lblFilter.text = "Price Range".localized
        self.txtfiledEnterKeyword.placeholder = "Enter Keyword...".localized
        if(lang == "en"){
            self.txtfiledEnterKeyword.textAlignment = .left
        }else{
            self.txtfiledEnterKeyword.textAlignment = .right
        }
    }
    
    private func setViewHeight(){
        var tableViewHeight:CGFloat = 0;
        for i in 0..<self.filterTableView.numberOfRows(inSection: 0){
            tableViewHeight = tableViewHeight + tableView(self.filterTableView, heightForRowAt: IndexPath(row: i, section: 0))
        }
        filterTableConstraint.constant = tableViewHeight
        searchBtnHeight.constant = tableViewHeight + 280
        self.filterTableView.setNeedsDisplay()
    }
    
    private func divisionsetViewHeight(){
        var tableViewHeight:CGFloat = 0;
        for i in 0..<self.filterTableView.numberOfRows(inSection: 0){
            tableViewHeight = tableViewHeight + tableView(self.filterTableView, heightForRowAt: IndexPath(row: i, section: 0))
        }
        filterTableConstraint.constant = tableViewHeight
        self.filterTableView.setNeedsDisplay()
    }
    
    private func getFeaturesCharacters(divisionArray:[String], sectionArray:[String]){
        startLoading("")
        ProductManager().getFeaturesCharacters((divisionArray,sectionArray),
           successCallback: {[weak self](response) in
            DispatchQueue.main.async {
                self?.finishLoading()
                if let filterResponse = response{
                    if filterResponse.success!{
                        self?.featuresArray = filterResponse.data?.features ?? []
                        self?.filterTableView.reloadData()
                        self?.setViewHeight()
                    }
                    else{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                    }
                }else{
                    self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                }
            }
         }){[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.alertMessage(message: error.message.localized, completionHandler: nil)
            }
        }
    }
    
    private func getFilterSearchData(groupId:String, divisionId:String){
        startLoading("")
        IndexManager().getSearchFilterData((groupId,divisionId),
          successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    if let filterResponse = response{
                        if filterResponse.success!{
                            self?.filtersearchdata = filterResponse.data!
                            self?.searchBtnHeight.constant = 280
                            
                            self?.featuresArray.removeAll()
                            self?.filterTableView.reloadData()
                            self?.divisionsetViewHeight()
                            self?.scrollView.updateContentView()
                            self?.view.setNeedsDisplay()
                            self?.selectSectionlbl.text = "Select Section"
                            self?.selectSectionBtn.isHidden = false
                            self?.selectSectionlbl.isHidden = false
                            self?.selectSectionArrow.isHidden = false
                            self?.selectSectionHeader.isHidden = false
                            
                            self?.selectManufactureslbl.text = "Select Manufactures"
                            self?.selectManufacturesArrow.isHidden = false
                            self?.selectManufacturesBtn.isHidden = false
                            self?.selectManufactureslbl.isHidden = false
                            self?.selectManufacturesHeader.isHidden = false
                            self?.filterTableView.reloadData()
                            
                        }
                        else{
                            self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                        }
                    }else{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
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
        dispatchGroup.enter()
        GDSManager().getGroupsWithDivisons(successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    self?.dispatchGroup.leave()
                    if let filterResponse = response{
                        if filterResponse.success!{
                            self?.filterdata = filterResponse.data ?? []
                            self?.filterTableView.reloadData()
                            self?.scrollView.updateContentView()
                        }
                        else{
                            self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                        }
                    }else{
                        self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
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
        ProductManager().SearchProduct(("",min,max,[String](),txt,[selectedManufactorId ?? ""]),
        successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    if let productsResponse = response{
                        if productsResponse.success!{
                            self?.moveToFilteredProducts(products: productsResponse.data?.products ?? [])
                        }
                        else{
                            if(self?.lang ?? "" == "en")
                            {
                                self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                            }else{
                                self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                            }
                        }
                    }else{
                        if(self?.lang ?? "" == "en")
                        {
                            self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                        }else{
                            self?.alertMessage(message: (self?.lang ?? "" == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
                        }
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
    
    @IBAction func groupSelection(_ sender: UIButton){
        
        let menudropDown = DropDown()
        menudropDown.anchorView = sender
        menudropDown.backgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        menudropDown.selectionBackgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        if(lang == "en"){
            var groupsarray = (filterdata.map({$0.title?.en ?? ""}))
            groupsarray.insert("Select Group", at: 0)
            menudropDown.dataSource = groupsarray
        }else{
            var groupsarray = (filterdata.map({$0.title?.ar ?? ""}))
            groupsarray.insert("اختر مجموعة", at: 0)
             menudropDown.dataSource = groupsarray
        }
        
        menudropDown.selectionAction = {(index: Int, item: String) in
            self.groupIndex = index - 1
            self.selectGrouplbl.text = item
            
            if item == "Select Group"{
                self.searchBtnHeight.constant = 25
                self.view.setNeedsDisplay()
                
                self.featuresArray.removeAll()
                self.filterTableView.reloadData()
                self.divisionsetViewHeight()
                
                self.scrollView.updateContentView()
                
                self.selectSectionBtn.isHidden = true
                self.selectSectionlbl.isHidden = true
                self.selectSectionArrow.isHidden = true
                self.selectSectionHeader.isHidden = true
                
                self.selectManufacturesArrow.isHidden = true
                self.selectManufacturesBtn.isHidden = true
                self.selectManufactureslbl.isHidden = true
                self.selectManufacturesHeader.isHidden = true
                
                self.selectDivisionBtn.isHidden = true
                self.selectDivisionlbl.isHidden = true
                self.selectDivisionArrow.isHidden = true
                self.selectDivisionHeader.isHidden = true
                
            }else{
                
                self.featuresArray.removeAll()
                self.filterTableView.reloadData()
                self.divisionsetViewHeight()
                
                self.scrollView.updateContentView()
                
                self.searchBtnHeight.constant = 100
                self.view.setNeedsDisplay()
                self.selectDivisionlbl.text = "Select Divison"
                
                self.selectDivisionBtn.isHidden = false
                self.selectDivisionlbl.isHidden = false
                self.selectDivisionArrow.isHidden = false
                self.selectDivisionHeader.isHidden = false
                
                self.selectSectionBtn.isHidden = true
                self.selectSectionlbl.isHidden = true
                self.selectSectionArrow.isHidden = true
                self.selectSectionHeader.isHidden = true
                
                self.selectManufacturesArrow.isHidden = true
                self.selectManufacturesBtn.isHidden = true
                self.selectManufactureslbl.isHidden = true
                self.selectManufacturesHeader.isHidden = true
            }
        }
        menudropDown.show()
    }
    
    @IBAction func divisionSelection(_ sender: UIButton){
        let menudropDown = DropDown()
        menudropDown.anchorView = sender
        menudropDown.backgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        menudropDown.selectionBackgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        if(lang == "en"){
            var divisionsarray = (filterdata[groupIndex].divisions?.map({$0.title?.en ?? ""})) ?? []
            divisionsarray.insert("Select Division", at: 0)
            menudropDown.dataSource = divisionsarray
        }else{
            var divisionsarray = (filterdata[groupIndex].divisions?.map({$0.title?.ar ?? ""})) ?? []
            divisionsarray.insert("Select Division", at: 0)
            menudropDown.dataSource = divisionsarray
        }
        
        menudropDown.selectionAction = {(index: Int, item: String) in
            self.divisionIndex = index - 1
            self.selectDivisionlbl.text = item
            
            if item == "Select Division"{
                self.searchBtnHeight.constant = 100
                self.view.setNeedsDisplay()
                self.featuresArray.removeAll()
                self.filterTableView.reloadData()
                self.divisionsetViewHeight()
                self.scrollView.updateContentView()
                self.selectSectionBtn.isHidden = true
                self.selectSectionlbl.isHidden = true
                self.selectSectionArrow.isHidden = true
                self.selectSectionHeader.isHidden = true
                
                self.selectManufacturesArrow.isHidden = true
                self.selectManufacturesBtn.isHidden = true
                self.selectManufactureslbl.isHidden = true
                self.selectManufacturesHeader.isHidden = true
            }else{
                self.selectedDivision = self.filterdata[self.groupIndex].divisions?[self.divisionIndex]
                self.getFilterSearchData(groupId: self.filterdata[self.groupIndex]._id ?? "", divisionId: self.filterdata[self.groupIndex].divisions?[self.divisionIndex]._id ?? "")
            }
        }
        menudropDown.show()
    }
    
    @IBAction func sectionSelection(_ sender: UIButton){
        self.view.setNeedsDisplay()
        let menudropDown = DropDown()
        menudropDown.anchorView = sender
        menudropDown.backgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        menudropDown.selectionBackgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        if(lang == "en"){
            var sectionsarray = filtersearchdata?.division?.sections?.map({$0.title?.en ?? ""}) ?? []
            sectionsarray.insert("Select Section", at: 0)
            menudropDown.dataSource = sectionsarray
        }else{
            var sectionsarray = filtersearchdata?.division?.sections?.map({$0.title?.ar ?? ""}) ?? []
            sectionsarray.insert("Select Section", at: 0)
            menudropDown.dataSource = sectionsarray
        }
        menudropDown.selectionAction = {(index: Int, item: String) in
            if item == "Select Section"{
                self.featuresArray.removeAll()
                self.filterTableView.reloadData()
                self.setViewHeight()
                self.selectSectionlbl.text = "Select Section".localized
            }else{
                
                self.selectedSection = self.filtersearchdata?.division?.sections?[index - 1]
                self.selectSectionlbl.text = item
                self.getFeaturesCharacters(divisionArray: [self.selectedDivision?._id ?? ""], sectionArray: [self.selectedSection?._id ?? ""])
            }
        }
        menudropDown.show()
    }
    
    @IBAction func sectionManufactures(_ sender: UIButton){
        self.view.setNeedsDisplay()
        let menudropDown = DropDown()
        menudropDown.anchorView = sender
        menudropDown.backgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        menudropDown.selectionBackgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        if(lang == "en"){
            var manufacturesarray = filtersearchdata?.division?.manufacturers?.map({$0.title?.en ?? ""}) ?? []
            manufacturesarray.insert("Select Manufactures", at: 0)
            menudropDown.dataSource = manufacturesarray
        }else{
            var manufacturesarray = filtersearchdata?.division?.manufacturers?.map({$0.title?.ar ?? ""}) ?? []
            manufacturesarray.insert("Select Manufactures", at: 0)
            menudropDown.dataSource = manufacturesarray
        }
        menudropDown.selectionAction = {(index: Int, item: String) in
            if item == "Select Manufactures"{
                self.featuresArray.removeAll()
                self.filterTableView.reloadData()
                self.setViewHeight()
                self.selectManufactureslbl.text = "Select Manufactures".localized
            }else{
                self.selectManufactureslbl.text = item
                self.selectedManufactorId =
                    self.filtersearchdata?.division?.manufacturers?[index - 1]._id
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
        cell.menudropDown.backgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.menudropDown.selectionBackgroundColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.featureName.text = "Select".localized
        if(lang == "en"){
            cell.featureheader.text = featuresArray[indexPath.row].title?.en ?? ""
            var array = (featuresArray[indexPath.row].characteristics?.map({$0.title?.en ?? ""})) ?? []
            array.insert("Select".localized, at: 0)
            cell.menudropDown.dataSource = array
        }else
        {
            cell.featureheader.text = featuresArray[indexPath.row].title?.ar ?? ""
            var array = (featuresArray[indexPath.row].characteristics?.map({$0.title?.ar ?? ""})) ?? []
            array.insert("Select".localized, at: 0)
            cell.menudropDown.dataSource = array
        }
        cell.menudropDown.selectionAction = {(index: Int, item: String) in
            cell.featureName.text = item}
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
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
    @IBOutlet weak var featureheader: UILabel!
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
        self.layer.borderColor =  #colorLiteral(red: 0.8745098039, green: 0.8784313725, blue: 0.8823529412, alpha: 1)
        self.clipsToBounds = true
    }
}

extension UIScrollView {
    func updateContentView() {
        contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
    }
}
