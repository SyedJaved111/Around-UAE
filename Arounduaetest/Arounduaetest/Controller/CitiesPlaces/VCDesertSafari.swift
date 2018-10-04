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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPlaceDetailById()
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
                    self?.alertMessage(message: (responsedetail.message?.en ?? "").localized, completionHandler: nil)
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
    
    private func setFavourite(_ placeid: String){
        startLoading("")
        CitiesPlacesManager().makePlaceFavourite(placeid,
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                self?.finishLoading()
                if let storeResponse = response{
                    if storeResponse.success!{
                        if(storeResponse.message?.en ?? "") == "Place liked Successfully."{
                            self?.btnlikeimg.setImage(#imageLiteral(resourceName: "Favourite-red"), for:.normal)
                        }else{
                            self?.btnlikeimg.setImage(#imageLiteral(resourceName: "Favourite"), for:.normal)
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
    
    override func viewWillAppear(_ animated: Bool) {
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
            let dvc = segue.destination as! VCPopUp
            dvc.placeid = sender as! String
        }
    }
    
    @IBAction func btnLinkedinClick(_ sender: Any){
        
    }
    
    @IBAction func tbnFacebookClick(_ sender: Any){
        
    }
    
    @IBAction func btnTwitterClick(_ sender: Any){
        
    }
}
