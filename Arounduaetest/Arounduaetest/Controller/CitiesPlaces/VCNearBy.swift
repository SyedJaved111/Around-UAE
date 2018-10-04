//
//  VCNearBy.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 18/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Cosmos
import CoreLocation

class VCNearBy: UIViewController,IndicatorInfoProvider,CLLocationManagerDelegate {
   
    @IBOutlet weak var viewEmptyList: UIView!
    @IBOutlet weak var lblEmpty: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    var locationManager:CLLocationManager!

    @IBOutlet weak var NearbyCollectionview: UICollectionView!{
        didSet{
            self.NearbyCollectionview.delegate = self
            self.NearbyCollectionview.dataSource = self
        }
    }

    var placeArray = [Places]()
    var totalPages = 0
    var currentPage = 0
    var cityid = ""
    private var long:Double?
    private var lat:Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NearbyCollectionview.adjustDesign(width: ((view.frame.size.width+20)/2.4))
        initialUI()
        fetchCitiesPlacesData()
    }
    
    private func fetchCitiesPlacesData(){

//        guard let latitude = lat, let longitude = long else{
//
//        }

        startLoading("")
        CitiesPlacesManager().getCitiesPlaces((cityid,"\(currentPage + 1)","\(72.2327)","\(52.8765)"),successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    if let citiesPlacesResponse = response{
                        if(citiesPlacesResponse.data?.places ?? []).count == 0{
                           self?.viewEmptyList.isHidden = false
                        }else{
                            self?.placeArray = citiesPlacesResponse.data?.places ?? []
                            self?.currentPage = citiesPlacesResponse.data?.pagination?.page ?? 1
                            self?.totalPages = citiesPlacesResponse.data?.pagination?.pages ?? 0
                            self?.NearbyCollectionview.reloadData()
                        }
                    }else{
                        self?.viewEmptyList.isHidden = false
                        self?.alertMessage(message: "Error".localized, completionHandler: nil)
                    }
                }
            })
        {[weak self](error) in
            DispatchQueue.main.async{
                self?.finishLoading()
                self?.viewEmptyList.isHidden = false
                self?.alertMessage(message: error.message.localized, completionHandler: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Stores"
        lblEmpty.text = "Empty List".localized
        lblMessage.text = "Sorry there no data available".localized
        determineMyCurrentLocation()

    }

    @IBAction func tryAgain(_ sender: UIButton) {
        self.viewEmptyList.isHidden = true
        fetchCitiesPlacesData()
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        long = userLocation.coordinate.longitude
        lat = userLocation.coordinate.latitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("Error \(error)")
    }
}

extension VCNearBy{
    
    func initialUI(){
        
        NearbyCollectionview.spr_setTextHeader { [weak self] in
            self?.viewEmptyList.isHidden = true
            self?.currentPage = 0
            CitiesPlacesManager().getCitiesPlaces((self?.cityid ?? "0","\(self?.currentPage ?? 0)","",""),successCallback:
                {[weak self](response) in
                    DispatchQueue.main.async {
                        self?.NearbyCollectionview.spr_endRefreshing()
                        if let storeResponse = response{
                            if(storeResponse.data?.places ?? []).count == 0{
                                self?.viewEmptyList.isHidden = false
                            }else{
                                self?.placeArray = storeResponse.data?.places ?? []
                                self?.currentPage = storeResponse.data?.pagination?.page ?? 1
                                self?.totalPages = storeResponse.data?.pagination?.pages ?? 0
                                self?.NearbyCollectionview.reloadData()
                            }
                        }else{
                            self?.viewEmptyList.isHidden = false
                            self?.alertMessage(message: "Error".localized, completionHandler: nil)
                        }
                    }
                })
            {[weak self](error) in
                DispatchQueue.main.async {
                    self?.NearbyCollectionview.spr_endRefreshing()
                    self?.viewEmptyList.isHidden = false
                    self?.alertMessage(message: error.message.localized, completionHandler: nil)
                    }
                }
            }
        
            NearbyCollectionview.spr_setIndicatorFooter {[weak self] in
                if((self?.currentPage)! >= (self?.totalPages)!){
                    self?.NearbyCollectionview.spr_endRefreshing()
                    return}
            CitiesPlacesManager().getCitiesPlaces((self?.cityid ?? "0","\((self?.currentPage ?? 0) + 1)","",""),successCallback:
                {[weak self](response) in
                    DispatchQueue.main.async {
                        self?.NearbyCollectionview.spr_endRefreshing()
                        if let cityplacesResponse = response{
                            for cityplaces in cityplacesResponse.data?.places ?? []{
                                self?.placeArray.append(cityplaces)
                            }
                            self?.currentPage = cityplacesResponse.data?.pagination?.page ?? 1
                            self?.totalPages = cityplacesResponse.data?.pagination?.pages ?? 0
                            self?.NearbyCollectionview.reloadData()
                        }else{
                            self?.alertMessage(message: "Error".localized, completionHandler: nil)
                        }
                    }
                })
            {[weak self](error) in
                DispatchQueue.main.async {
                    self?.NearbyCollectionview.spr_endRefreshing()
                    self?.alertMessage(message: error.message.localized, completionHandler: nil)
                }
            }
        }
    }
}

extension VCNearBy: UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return placeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NearByCell", for: indexPath) as! NearByCell
        let place = placeArray[indexPath.row]
        cell.setupPlaceCell(place)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let id = placeArray[indexPath.row]._id{
            moveToPlaceDetail(id)
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "NearBy")
    }
    
    private func moveToPlaceDetail(_ placeid:String){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCDesertSafari") as! VCDesertSafari
        vc.placeid = placeid
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
