//
//  VCTopRated.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 18/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class VCTopRated: BaseController,IndicatorInfoProvider {
    
    @IBOutlet weak var TopratedCollectionView: UICollectionView!{
        didSet{
            self.TopratedCollectionView.delegate = self
            self.TopratedCollectionView.dataSource = self
            self.TopratedCollectionView.alwaysBounceVertical = true
        }
    }
    
    var placeArray = [Places]()
    var totalPages = 0
    var currentPage = 0
    var cityid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TopratedCollectionView.adjustDesign(width: ((view.frame.size.width+20)/2.5))
        initialUI()
        fetchCitiesPlacesData()
    }
    
    fileprivate func setupDelegates(){
        self.TopratedCollectionView.emptyDataSetSource = self
        self.TopratedCollectionView.emptyDataSetDelegate = self
        self.TopratedCollectionView.reloadData()
    }
    
    private func fetchCitiesPlacesData(){
        startLoading("")
        CitiesPlacesManager().getCitiesPlaces((cityid,"\(currentPage + 1)","",""),successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    if let placeResponse = response{
                        if placeResponse.success!{
                            self?.placeArray = placeResponse.data?.places ?? []
                            self?.currentPage = placeResponse.data?.pagination?.page ?? 1
                            self?.totalPages = placeResponse.data?.pagination?.pages ?? 0
                        }else{
                            self?.alertMessage(message:(placeResponse.message?.en ?? "").localized, completionHandler: nil)
                        }
                    }else{
                        self?.alertMessage(message: (response?.message?.en ?? "").localized, completionHandler: nil)
                    }
                    self?.setupDelegates()
                }
            })
        {[weak self](error) in
            DispatchQueue.main.async{
                self?.placeArray = [Places(_id: "", title: Title(en: "hello", ar: "hello"), averageRating: 3, images: [Images(path: "")])]
                self?.finishLoading()
                self?.setupDelegates()
                self?.alertMessage(message: error.message.localized, completionHandler: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Stores"
    }
}

extension VCTopRated{
    
    func initialUI(){
        
        TopratedCollectionView.spr_setTextHeader { [weak self] in
            self?.currentPage = 0
            CitiesPlacesManager().getCitiesPlaces((self?.cityid ?? "0","\((self?.currentPage ?? 0) + 1)","",""),successCallback:
                {[weak self](response) in
                    DispatchQueue.main.async {
                        self?.TopratedCollectionView.spr_endRefreshing()
                        if let placeResponse = response{
                            if placeResponse.success!{
                                self?.placeArray = placeResponse.data?.places ?? []
                                self?.currentPage = placeResponse.data?.pagination?.page ?? 1
                                self?.totalPages = placeResponse.data?.pagination?.pages ?? 0
                            }else{
                                self?.alertMessage(message:(placeResponse.message?.en ?? "").localized, completionHandler: nil)
                            }
                        }else{
                            self?.alertMessage(message: (response?.message?.en ?? "").localized, completionHandler: nil)
                        }
                        self?.setupDelegates()
                    }
                })
            {[weak self](error) in
                DispatchQueue.main.async {
                    self?.TopratedCollectionView.spr_endRefreshing()
                    self?.setupDelegates()
                    self?.alertMessage(message: error.message.localized, completionHandler: nil)
                }
            }
        }
        
        TopratedCollectionView.spr_setIndicatorFooter {[weak self] in
            if((self?.currentPage)! >= (self?.totalPages)!){
                self?.TopratedCollectionView.spr_endRefreshing()
                return}
            CitiesPlacesManager().getCitiesPlaces((self?.cityid ?? "0","\((self?.currentPage ?? 0) + 1)","",""),successCallback:
                {[weak self](response) in
                    DispatchQueue.main.async {
                        self?.TopratedCollectionView.spr_endRefreshing()
                        if let placeResponse = response{
                            
                            if placeResponse.success!{
                                for cityplaces in placeResponse.data?.places ?? []{
                                    self?.placeArray.append(cityplaces)
                                }
                                self?.currentPage = placeResponse.data?.pagination?.page ?? 1
                                self?.totalPages = placeResponse.data?.pagination?.pages ?? 0
                            }else{
                                self?.alertMessage(message:(placeResponse.message?.en ?? "").localized, completionHandler: nil)
                            }
                        }else{
                            self?.alertMessage(message: (response?.message?.en ?? "").localized, completionHandler: nil)
                        }
                        self?.setupDelegates()
                    }
                })
            {[weak self](error) in
                DispatchQueue.main.async {
                    self?.TopratedCollectionView.spr_endRefreshing()
                    self?.setupDelegates()
                    self?.alertMessage(message: error.message.localized, completionHandler: nil)
                }
            }
        }
    }
}

extension VCTopRated: UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return placeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopratedCell", for: indexPath) as! TopratedCell
        cell.setupPlaceCell(placeArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let id = placeArray[indexPath.row]._id{
           moveToPlaceDetail(id)
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Toprated")
    }
    
    private func moveToPlaceDetail(_ placeid:String){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCDesertSafari") as! VCDesertSafari
        vc.placeid = placeid
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!){
        fetchCitiesPlacesData()
    }
}

