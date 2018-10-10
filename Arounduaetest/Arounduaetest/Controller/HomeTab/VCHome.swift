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
    
    @IBOutlet weak var btnViewMore: UIButton!
    @IBOutlet weak var lblGenralServices: UILabel!
    @IBOutlet weak var lblKnow: UILabel!
    @IBOutlet weak var bannerView: UIView!
    
    @IBOutlet weak var tablView: UITableView!{
        didSet{
            self.tablView.delegate = self
            self.tablView.dataSource = self
            self.tablView.alwaysBounceVertical = true
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
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
   
    
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
        lblKnow.text = "know more details about various shops ,location & tourist spots around UAE".localized
        lblGenralServices.text = "GENERAL SERVICES".localized
    }
    
    @objc func refreshTableView() {
        fetchGroupsWithDivisons(isRefresh: true)
    }
    
    fileprivate func setupDelegates(){
//        self.tablView.emptyDataSetSource = self
//        self.tablView.emptyDataSetDelegate = self
        self.tablView.reloadData()
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
                        if groupResponse.success!{
                            self?.groupWithDivisionList = groupResponse.data ?? []
                            if(self?.groupWithDivisionList.count ?? 0) > 0{
                                self?.bannerView.isHidden = false
                            }
                        }else{
                            self?.bannerView.isHidden = true
                            self?.alertMessage(message:(groupResponse.message?.en ?? "").localized, completionHandler: nil)
                        }
                    }else{
                        self?.alertMessage(message:(response?.message?.en ?? "").localized, completionHandler: nil)
                    }
                    self?.setupDelegates()
                }
            })
        {[weak self](error) in
            DispatchQueue.main.async {
                if isRefresh == false {
                    self?.finishLoading()
                }else {
                    self?.refreshControl.endRefreshing()
                }
                self?.setupDelegates()
                self?.alertMessage(message: error.message.localized, completionHandler: nil)
            }
        }
    }
    
    @IBAction func ViewMoreClick(_ sender: Any){
        moveToCitiesList()
    }
    
    @IBAction func ViewAllClick(_ sender: Any){
        if AppSettings.sharedSettings.accountType == "seller"{
           self.tabBarController?.selectedIndex = 1
        }else{
           self.tabBarController?.selectedIndex = 2
        }
    }
    
    private func moveToCitiesList(){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCCities") as! VCCities
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension VCHome: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 235
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  groupWithDivisionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
        let obj = groupWithDivisionList[indexPath.row]
        cell.lblCategoryName.text = obj.title?.en
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
    
//    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!){
//        fetchGroupsWithDivisons(isRefresh: false)
//    }
}
