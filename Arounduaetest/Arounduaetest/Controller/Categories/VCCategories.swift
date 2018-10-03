//
//  VCCategories.swift
//  AroundUAE
//
//  Created by Macbook on 14/09/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class VCCategories: BaseController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    @IBOutlet weak var viewEmptyList: UIView!
    @IBOutlet weak var lblEmpty: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet var groupCollectionView: UICollectionView!{
        didSet{
            self.groupCollectionView.delegate = self
            self.groupCollectionView.dataSource = self
            self.groupCollectionView.addSubview(refreshControl)
        }
    }
   
    var grouplist = [Groups]()
    var storeGroup:Groups!
    var resturantGroup:Groups!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(refreshTableView),for: UIControlEvents.valueChanged)
        refreshControl.tintColor = #colorLiteral(red: 0.8745098039, green: 0.1882352941, blue: 0.3176470588, alpha: 1)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupCollectionView.adjustDesign(width: ((view.frame.size.width+20)/2.3))
        setupDefaultGroups()
        fetchGroupsData(isRefresh: false)
        self.viewEmptyList.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        lblEmpty.text = "Empty List".localized
        lblMessage.text = "Sorry there no data is available refresh it or try it later ".localized
    }
    
    @objc func refreshTableView() {
        self.viewEmptyList.isHidden = true
        fetchGroupsData(isRefresh: true)
    }
    
    private func setupDefaultGroups(){
         storeGroup = Groups(title: Title(en: "Stores", ar: "Stores"), image: nil, isActive: true, isFeatured: true, _id: "0123456")
         resturantGroup = Groups(title: Title(en: "Resturants", ar: "Resturants"), image: nil, isActive: true, isFeatured: true, _id: "0123456")
    }
    
    private func fetchGroupsData(isRefresh: Bool){
      
        if isRefresh == false{
            startLoading("")
        }
        
        GDSManager().getGroups(successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                
                if isRefresh == false {
                    self?.finishLoading()
                }else {
                    self?.refreshControl.endRefreshing()
                }
    
                if let groupResponse = response{
                    
                    if(groupResponse.data?.groups ?? []).count == 0{
                        self?.viewEmptyList.isHidden = false
                    }else{
                        self?.grouplist = groupResponse.data?.groups ?? []
                        self?.grouplist.insert((self?.storeGroup)!, at: 0)
                        self?.grouplist.insert((self?.resturantGroup)!, at:1)
                        self?.groupCollectionView.reloadData()
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
    
    @IBAction func tryAgain(_ sender: UIButton){
        self.viewEmptyList.isHidden = true
        fetchGroupsData(isRefresh: false)
    }
}

extension VCCategories{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  grouplist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellCategories", for: indexPath) as! CellCategories
        let obj = grouplist[indexPath.row]
        if obj.title?.en == "Stores"{
            cell.setupCell(obj, groupImage: #imageLiteral(resourceName: "3"))
        }else if obj.title?.en == "Resturants" {
            cell.setupCell(obj, groupImage: #imageLiteral(resourceName: "4"))
        }else{
            cell.setupCell(obj, groupImage: nil)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if indexPath.row == 0{
            self.moveToStores()
        }else if indexPath.row == 1{
            self.moveToResturants()
        }else{
            self.moveToProducts(grouplist[indexPath.row]._id ?? "")
        }
    }
    
    private func moveToProducts(_ groupId:String){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCDivisions") as! VCDivisions
        vc.groupid = groupId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func moveToStores(){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCStores") as! VCStores
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func moveToResturants(){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCResturants") as! VCResturants
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension UICollectionView{
    func  adjustDesign(width: CGFloat){
        let collectionViewSize = self.collectionViewLayout as! UICollectionViewFlowLayout
        collectionViewSize.itemSize.width = width
    }
}
