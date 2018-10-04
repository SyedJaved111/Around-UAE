//
//  VCGenralServices.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 18/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit

class VCCities: BaseController{

    @IBOutlet weak var viewEmptyList: UIView!
    @IBOutlet weak var lblEmpty: UILabel!
    @IBOutlet weak var lblMessage: UILabel!

    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
        }
    }

    var CitiesArray = [Cities]()
    var totalPages = 0
    var currentPage = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.adjustDesign(width: ((view.frame.size.width+20)/2.4))
        initialUI()
        fetchCitiesData()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.title = "Cities"
        lblEmpty.text = "Empty List".localized
        lblMessage.text = "Sorry there no data available".localized
        self.setNavigationBar()
        self.addBackButton()
    }

    private func fetchCitiesData(){

        startLoading("")
        CitiesPlacesManager().getCities("\(currentPage + 1)",successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    if let citiesResponse = response{
                        if(citiesResponse.data?.cities ?? []).count == 0{
                            self?.viewEmptyList.isHidden = false
                        }else{
                            self?.CitiesArray = citiesResponse.data?.cities ?? []
                            self?.currentPage = citiesResponse.data?.pagination?.page ?? 1
                            self?.totalPages = citiesResponse.data?.pagination?.pages ?? 0
                            self?.collectionView.reloadData()
                        }
                    }else{
                        self?.alertMessage(message: "Error".localized, completionHandler: {self?.viewEmptyList.isHidden = false})
                    }
                }
            })
        {[weak self](error) in
            DispatchQueue.main.async{
                self?.finishLoading()
                self?.alertMessage(message: error.message.localized, completionHandler: {self?.viewEmptyList.isHidden = false})
            }
        }
    }
    
    @IBAction func tryAgain(_ sender: UIButton) {
        self.viewEmptyList.isHidden = true
        fetchCitiesData()
    }
}

extension VCCities{
    
    func initialUI(){
        
        collectionView.spr_setTextHeader { [weak self] in
            self?.viewEmptyList.isHidden = true
            self?.currentPage = 0
            CitiesPlacesManager().getCities("\((self?.currentPage ?? 0) + 1)",successCallback:
                {[weak self](response) in
                    DispatchQueue.main.async {
                        self?.collectionView.spr_endRefreshing()
                        if let citiesResponse = response{
                            if(citiesResponse.data?.cities ?? []).count == 0{
                                self?.viewEmptyList.isHidden = false
                            }else{
                                self?.CitiesArray = citiesResponse.data?.cities ?? []
                                self?.currentPage = citiesResponse.data?.pagination?.page ?? 1
                                self?.totalPages = citiesResponse.data?.pagination?.pages ?? 0
                                self?.collectionView.reloadData()
                            }
                        }else{
                            self?.viewEmptyList.isHidden = false
                            self?.alertMessage(message: "Error".localized, completionHandler: nil)
                        }
                    }
                })
            {[weak self](error) in
                DispatchQueue.main.async {
                    self?.collectionView.spr_endRefreshing()
                    self?.viewEmptyList.isHidden = false
                    self?.alertMessage(message: error.message.localized, completionHandler: nil)
                }
            }
        }
        
        collectionView.spr_setIndicatorFooter {[weak self] in
            if((self?.currentPage)! >= (self?.totalPages)!){
                self?.collectionView.spr_endRefreshing()
                return}
            
             CitiesPlacesManager().getCities("\((self?.currentPage ?? 0) + 1)",successCallback:
                {[weak self](response) in
                    DispatchQueue.main.async {
                        self?.collectionView.spr_endRefreshing()
                        if let citiesResponse = response{
                            for city in citiesResponse.data?.cities ?? []{
                                self?.CitiesArray.append(city)
                            }
                            self?.currentPage = citiesResponse.data?.pagination?.page ?? 1
                            self?.totalPages = citiesResponse.data?.pagination?.pages ?? 0
                            self?.collectionView.reloadData()
                        }else{
                            self?.alertMessage(message: "Error".localized, completionHandler: nil)
                        }
                    }
                })
            {[weak self](error) in
                DispatchQueue.main.async {
                    self?.collectionView.spr_endRefreshing()
                    self?.alertMessage(message: error.message.localized, completionHandler: nil)
                }
            }
        }
    }
}

extension VCCities:UICollectionViewDelegate,UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CitiesArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenralCell", for: indexPath) as! VCCitiesCell
        let city = CitiesArray[indexPath.row]
        cell.setupCities(city)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if let id = CitiesArray[indexPath.row]._id{
            moveToCityDetail(id)
        }
    }
    
    private func moveToCityDetail(_ cityId:String){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCPlaces") as! VCPlaces
        vc.cityId = cityId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
