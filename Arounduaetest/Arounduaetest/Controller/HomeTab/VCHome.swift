//
//  VCHome.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 12/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class VCHome: BaseController{
    let lang  = UserDefaults.standard.string(forKey: "i18n_language")
    @IBOutlet weak var btnViewMore: UIButton!
    @IBOutlet weak var lblGenralServices: UILabel!
    @IBOutlet weak var lblKnow: UILabel!
    @IBOutlet weak var bannerView: UIView!
    
    @IBOutlet weak var tablView: UITableView!{
        didSet{
            self.tablView.delegate = self
            self.tablView.dataSource = self
            self.tablView.addSubview(refreshControl)
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(refreshTableView),for: UIControlEvents.valueChanged)
        refreshControl.tintColor = #colorLiteral(red: 0.8745098039, green: 0.1882352941, blue: 0.3176470588, alpha: 1)
        return refreshControl
    }()
    
    var groupWithDivisionList = [GroupDivisonData]()
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.tablView.emptyDataSetSource = self
        self.tablView.emptyDataSetDelegate = self
        self.tablView.tableFooterView = UIView()
        fetchGroupsWithDivisons(isRefresh: false)
        setupLocalization()
    }
    
    private func setupLocalization(){
        btnViewMore.setTitle("View More".localized, for: .normal)
        lblKnow.text = "know more detals about various shope, location & tourist spots around UAE ".localized
        lblGenralServices.text = "GENRAL SERVICES".localized
    }
    
    @objc func refreshTableView() {
        fetchGroupsWithDivisons(isRefresh: true)
    }
    
    private func fetchGroupsWithDivisons(isRefresh: Bool){
        
        if isRefresh == false{
            startLoading("")
        }
        
        GDSManager().getGroupsWithDivisons(successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    
                    if isRefresh == false {
                        self?.finishLoading()
                    }else {
                        self?.refreshControl.endRefreshing()
                    }
                    if let groupResponse = response{
                        if(groupResponse.data ?? []).count == 0{
                            self?.bannerView.isHidden = true
                            self?.tablView.isHidden = true
                            self?.tablView.reloadData()
                        }else{
                            self?.groupWithDivisionList = groupResponse.data ?? []
                            self?.bannerView.isHidden = false
                            self?.tablView.isHidden = false
                            self?.tablView.reloadData()
                         }
                    }else{
                        self?.alertMessage(message: "Error".localized, completionHandler: nil)
                    }
                }
            })
        {[weak self](error) in
            DispatchQueue.main.async {
                if isRefresh == false {
                    self?.finishLoading()
                }else {
                    self?.refreshControl.endRefreshing()
                }
                self?.alertMessage(message: error.message.localized, completionHandler: nil)
            }
        }
    }
    
    @IBAction func ViewMoreClick(_ sender: Any){
        moveToCitiesList()
    }
    
    @IBAction func ViewAllClick(_ sender: Any){
        self.tabBarController?.selectedIndex = 2
    }
    
    private func moveToCitiesList(){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCCities") as! VCCities
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension VCHome: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  groupWithDivisionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
        let obj = groupWithDivisionList[indexPath.row]
        if(lang == "en"){
        cell.lblCategoryName.text = obj.title?.en
        } else if(lang == "ar")
        {
            cell.lblCategoryName.text = obj.title?.ar
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? HomeTableViewCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }
}

extension VCHome: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  groupWithDivisionList[collectionView.tag].divisions?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DataCollectionViewCell", for: indexPath) as! DataCollectionViewCell
        if let divison = groupWithDivisionList[collectionView.tag].divisions?[indexPath.row]{
            cell.setupCell(divison)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCProducList") as! VCProducList
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension VCHome : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "No Data Is Avaliable!"
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
}
