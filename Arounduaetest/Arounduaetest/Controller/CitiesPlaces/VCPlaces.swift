//
//  VCPlaces.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 18/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class VCPlaces: ButtonBarPagerTabStripViewController {

     @IBOutlet var collectionViewPager: ButtonBarView!
    var placesArray = [Places]()
    var cityId = ""
    let child_1 = UIStoryboard(name: "HomeTabs", bundle: nil).instantiateViewController(withIdentifier: "VCNearBy")
    let child_2 = UIStoryboard(name: "HomeTabs", bundle: nil).instantiateViewController(withIdentifier: "VCTopRated")
    
    override func viewDidLoad(){
        settings.style.buttonBarBackgroundColor = UIColor.red
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = #colorLiteral(red: 0.9607843137, green: 0.003921568627, blue: 0.2039215686, alpha: 1)
        
        settings.style.buttonBarItemFont = UIFont(name: "Raleway-Medium", size: 15)!
        settings.style.selectedBarHeight = 4
        settings.style.buttonBarMinimumLineSpacing = 0.6
        settings.style.buttonBarItemTitleColor = .red
        settings.style.selectedBarBackgroundColor = UIColor.red
        settings.style.buttonBarBackgroundColor = #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1);
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = {(oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = #colorLiteral(red: 0.2549019608, green: 0.2549019608, blue: 0.2549019608, alpha: 1)
            newCell?.label.textColor = #colorLiteral(red: 0.3019607843, green: 0.3019607843, blue: 0.3019607843, alpha: 1)
        }
        
        collectionViewPager.layer.borderWidth = 1
        collectionViewPager.layer.borderColor = UIColor.init(red: 247, green: 247, blue: 247, alpha: 1).cgColor
        super.viewDidLoad()
        super.viewDidLoad()
        self.fetchCitiesPlacesData()
    }
  
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationBar()
        self.addBackButton()
        self.title = "Places"
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController]{
        return [child_1,child_2]
    }
    
    private func fetchCitiesPlacesData(){
    
        startLoading("")
        CitiesPlacesManager().getCitiesPlaces((cityId,"1","",""),successCallback:
            {[weak self](response) in
                DispatchQueue.main.async {
                    self?.finishLoading()
                    if let citiesPlacesResponse = response{
                        if(citiesPlacesResponse.data?.places ?? []).count != 0{
                            SharedData.sharedUserInfo.placesDataObj = citiesPlacesResponse.data!
                        }
                    }else{
                        self?.alertMessage(message: "Error".localized, completionHandler: nil)
                    }
                }
            })
        {[weak self](error) in
            DispatchQueue.main.async{
                self?.finishLoading()
                self?.alertMessage(message: error.message.localized, completionHandler: nil)
            }
        }
    }
}
