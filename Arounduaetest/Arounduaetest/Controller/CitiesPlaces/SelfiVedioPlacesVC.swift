//
//  VCGenralServices.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 18/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import AVFoundation
import AVKit

class SelfiVedioPlacesVC: BaseController,IndicatorInfoProvider{
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
        }
    }
    
    var CitiesArray = [false,false,true,true,false,false,true,true,false,false,true,true,false,false,true,true]
    var totalPages = 0
    var currentPage = 0
    var storeid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.adjustDesign(width: ((view.frame.size.width+20)/2.5))
        setupDelegates()
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo{
        return IndicatorInfo.init(title: "Selfie/Video".localized)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Selfie/Video".localized
        addSelfieButton()
    }
    
    func addSelfieButton(backImage: UIImage = #imageLiteral(resourceName: "Takeselfie")) {
        let chatButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(onChatButtonClciked))
        navigationItem.rightBarButtonItem  = chatButton
    }
    
    @objc func onChatButtonClciked() {
        
    }
    
    fileprivate func setupDelegates(){
        self.collectionView.emptyDataSetSource = self
        self.collectionView.emptyDataSetDelegate = self
        self.collectionView.reloadData()
    }
}

extension SelfiVedioPlacesVC:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CitiesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let isvideo = CitiesArray[indexPath.row]
        if isvideo{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenralVideoCell", for: indexPath) as! VCCitiesCell
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenralCell", for: indexPath) as! VCCitiesCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let isvideo = CitiesArray[indexPath.row]
        if isvideo{
            playVideo()
        }else{
            moveToPhotoDetail()
        }
    }
    
    private func moveToPhotoDetail(){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PhotoDetailViewController") as! PhotoDetailViewController
        vc.detailImage = #imageLiteral(resourceName: "product")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func playVideo(){
        let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!){
        
    }
}
