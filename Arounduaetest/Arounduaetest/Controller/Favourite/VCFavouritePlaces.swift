//
//  VCFavouritePlaces.swift
//  AroundUAE
//
//  Created by Macbook on 28/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import  XLPagerTabStrip

class VCFavouritePlaces: UIViewController,IndicatorInfoProvider{
    
    @IBOutlet weak var viewEmptyList: UIView!
    @IBOutlet weak var lblEmpty: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet var favouritePlacesTableView: UITableView!{
        didSet{
            self.favouritePlacesTableView.delegate = self
            self.favouritePlacesTableView.dataSource = self
        }
    }
    
    var favouritePlacesList = [Places]()
    var totalPages = 0
    var currentPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialUI()
        getFavouritePlaces()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.title = "Places"
        lblEmpty.text = "Empty List".localized
        lblMessage.text = "Sorry there no data available".localized
    }
    
    private func getFavouritePlaces(){
        startLoading("")
        CitiesPlacesManager().getFavouritePlacesList("\(currentPage + 1)",successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    if let FavouritePlacesData = response{
                        if(FavouritePlacesData.data?.places ?? []).count == 0{
                            self?.viewEmptyList.isHidden = false
                        }else{
                            self?.favouritePlacesList = FavouritePlacesData.data?.places ?? []
                            self?.currentPage = FavouritePlacesData.data?.pagination?.page ?? 1
                            self?.totalPages = FavouritePlacesData.data?.pagination?.pages ?? 0
                            self?.favouritePlacesTableView.reloadData()
                        }
                    }else{
                        self?.viewEmptyList.isHidden = false
                        self?.alertMessage(message: "Error".localized, completionHandler: nil)
                    }
                }
            })
        {[weak self](error) in
            DispatchQueue.main.async {
                self?.finishLoading()
                self?.viewEmptyList.isHidden = false
                self?.alertMessage(message: error.message.localized, completionHandler: nil)
            }
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: "Places")
    }
    
    @IBAction func tryAgain(_ sender: UIButton) {
        self.viewEmptyList.isHidden = true
        getFavouritePlaces()
    }
}

extension VCFavouritePlaces{
    
    func initialUI(){
        
        favouritePlacesTableView.spr_setTextHeader { [weak self] in
            self?.viewEmptyList.isHidden = true
            self?.currentPage = 0
            CitiesPlacesManager().getFavouritePlacesList("\((self?.currentPage ?? 0) + 1)",successCallback:
                {[weak self](response) in
                    DispatchQueue.main.async {
                        self?.favouritePlacesTableView.spr_endRefreshing()
                        if let FavouritePlacesData = response{
                            if(FavouritePlacesData.data?.places ?? []).count == 0{
                                self?.viewEmptyList.isHidden = false
                            }else{
                                self?.favouritePlacesList = FavouritePlacesData.data?.places ?? []
                                self?.currentPage = FavouritePlacesData.data?.pagination?.page ?? 1
                                self?.totalPages = FavouritePlacesData.data?.pagination?.pages ?? 0
                                self?.favouritePlacesTableView.reloadData()
                            }
                        }else{
                            self?.viewEmptyList.isHidden = false
                            self?.alertMessage(message: "Error".localized, completionHandler: nil)
                        }
                    }
                })
            {[weak self](error) in
                DispatchQueue.main.async {
                    self?.favouritePlacesTableView.spr_endRefreshing()
                    self?.viewEmptyList.isHidden = false
                    self?.alertMessage(message: error.message.localized, completionHandler: nil)
                    }
                }
            }
        
            favouritePlacesTableView.spr_setIndicatorFooter {[weak self] in
            if((self?.currentPage)! >= (self?.totalPages)!){
                self?.favouritePlacesTableView.spr_endRefreshing()
                return}
            
             CitiesPlacesManager().getFavouritePlacesList("\((self?.currentPage ?? 0) + 1)",successCallback:
                {[weak self](response) in
                    DispatchQueue.main.async {
                        self?.favouritePlacesTableView.spr_endRefreshing()
                        if let FavouritePlacesData = response{
                            for place in FavouritePlacesData.data?.places ?? []{
                                self?.favouritePlacesList.append(place)
                            }
                            self?.currentPage = FavouritePlacesData.data?.pagination?.page ?? 1
                            self?.totalPages = FavouritePlacesData.data?.pagination?.pages ?? 0
                            self?.favouritePlacesTableView.reloadData()
                        }else{
                            self?.alertMessage(message: "Error".localized, completionHandler: nil)
                        }
                    }
                })
            {[weak self](error) in
                DispatchQueue.main.async {
                    self?.favouritePlacesTableView.spr_endRefreshing()
                    self?.alertMessage(message: error.message.localized, completionHandler: nil)
                }
            }
        }
    }
}

extension VCFavouritePlaces:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 133
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouritePlacesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellFavouritePlaces") as! CellFavouritePlaces
        cell.setupCellData(favouritePlacesList[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}
