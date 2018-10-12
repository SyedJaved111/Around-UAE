//
//  VCDesertSafari.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 19/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import Cosmos
import MapKit
import CoreLocation

class VCDesertSafari: UIViewController {

    @IBOutlet weak var mapkitlocation: MKMapView!
    @IBOutlet weak var lbllocation: UILabel!
    @IBOutlet weak var btntiwitter: UIButtonMain!
    @IBOutlet weak var btnfacebook: UIButtonMain!
    @IBOutlet weak var btnlinkedin: UIButtonMain!
    @IBOutlet weak var lblShareon: UILabel!
    @IBOutlet weak var lblDesription: UILabel!
    @IBOutlet weak var strcomos: CosmosView!
    @IBOutlet weak var lblDesrtsfari: UILabel!
    @IBOutlet weak var imgBaner: UIImageView!
    @IBOutlet weak var btnlikeimg: UIButtonMain!
   
    var placeid = ""
    var locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPlaceDetailById()
        mapkitlocation.showsUserLocation = true
    }
    
    private func getPlaceDetailById(){
        if placeid == ""{
          return
        }
        
        startLoading("")
        CitiesPlacesManager().getPlaceDetail(placeid,
        successCallback:
        {[weak self](response) in
          DispatchQueue.main.async {
            self?.finishLoading()
                if let responsedetail = response{
                    self?.setupPlaceDetail(responsedetail.data!)
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
    
    private func setupPlaceDetail(_ place:Places){
      lblDesription.text = place.description?.en ?? ""
      strcomos.rating = place.averageRating ?? 0.0
      lblDesrtsfari.text = place.title?.en ?? ""
      imgBaner.sd_setShowActivityIndicatorView(true)
      imgBaner.sd_setIndicatorStyle(.gray)
      imgBaner.sd_setImage(with: URL(string: place.images?.first?.path ?? ""))
        if AppSettings.sharedSettings.user.favouritePlaces?.contains(placeid) ?? false{
            self.btnlikeimg.setImage(#imageLiteral(resourceName: "Favourite"), for:.normal)
        }else{
            self.btnlikeimg.setImage(#imageLiteral(resourceName: "Favourite-red"), for:.normal)
        }
      let location = CLLocation(latitude: place.location![1], longitude: place.location![0])
      let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000)
      mapkitlocation.setRegion(region, animated: true)
    }
    
    private func setFavourite(_ placeid: String){
        startLoading("")
        CitiesPlacesManager().makePlaceFavourite(placeid,
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async{
                self?.finishLoading()
                if let storeResponse = response{
                    if storeResponse.success!{
                        AppSettings.sharedSettings.user = storeResponse.data!
                        if AppSettings.sharedSettings.user.favouritePlaces?.contains(placeid) ?? false{
                            self?.btnlikeimg.setImage(#imageLiteral(resourceName: "Favourite"), for:.normal)
                        }else{
                            self?.btnlikeimg.setImage(#imageLiteral(resourceName: "Favourite-red"), for:.normal)
                        }
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
    
    
    override func viewWillAppear(_ animated: Bool){
        self.title = "Desert Safari"
        self.addBackButton()
    }

    @IBAction func makePlaceFavourite(_ sender: Any){
        if placeid != "" && placeid.count > 0{
           setFavourite(placeid)
        }
    }
    
    @IBAction func review(_ sender: Any){
       self.performSegue(withIdentifier: "movetopop", sender: placeid)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "movetopop"{
            placeid = (sender as? String)!
        }
    }
    
    @IBAction func btnLinkedinClick(_ sender: Any){
        
    }
    
    @IBAction func tbnFacebookClick(_ sender: Any){
        
    }
    
    @IBAction func btnTwitterClick(_ sender: Any){
        
    }
}

