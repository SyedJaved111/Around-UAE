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
    
    var selfiesArray = [Selfies]()
    var totalPages = 0
    var currentPage = 0
    var placeid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackButton()
        collectionView.reloadData()
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
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CaptureSelfiePopupVC") as! CaptureSelfiePopupVC
        vc.storeid = placeid
        self.present(vc, animated: true, completion: nil)
    }

    
    fileprivate func setupDelegates(){
        self.collectionView.emptyDataSetSource = self
        self.collectionView.emptyDataSetDelegate = self
        self.collectionView.reloadData()
    }
}

extension SelfiVedioPlacesVC:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selfiesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let isvideo = selfiesArray[indexPath.row].mimeType
        if isvideo == "video"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenralVideoCell", for: indexPath) as! VCCitiesCell
            cell.imgGenral.sd_setShowActivityIndicatorView(true)
            cell.imgGenral.sd_setIndicatorStyle(.gray)
            cell.imgGenral.sd_setImage(with: URL(string: selfiesArray[indexPath.row].thumbnail ?? ""), placeholderImage: #imageLiteral(resourceName: "Category"))
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenralCell", for: indexPath) as! VCCitiesCell
            cell.imgGenral.sd_setShowActivityIndicatorView(true)
            cell.imgGenral.sd_setIndicatorStyle(.gray)
            cell.imgGenral.sd_setImage(with: URL(string: selfiesArray[indexPath.row].path ?? ""), placeholderImage: #imageLiteral(resourceName: "Category"))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let isvideo = selfiesArray[indexPath.row].mimeType
        if isvideo == "video"{
            playVideo(selfiesArray[indexPath.row].path ?? "")
        }else{
            moveToPhotoDetail(selfiesArray[indexPath.row].path ?? "")
        }
    }
    
    private func moveToPhotoDetail(_ detailImageURL:String){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PhotoDetailViewController") as! PhotoDetailViewController
        vc.detailImageurl = detailImageURL
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func playVideo(_ url:String){
        let videoURL = URL(string:url)
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
