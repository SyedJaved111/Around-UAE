//
//  VCDivisions.swift
//  Arounduaetest
//
//  Created by Apple on 02/10/2018.
//  Copyright © 2018 MyComedy. All rights reserved.
//

import UIKit

class VCSubDivisions: UIViewController {

    @IBOutlet weak var viewEmptyList: UIView!
    @IBOutlet weak var lblEmpty: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet var collectionViewSubDivison: UICollectionView!{
        didSet{
            self.collectionViewSubDivison.delegate = self
            self.collectionViewSubDivison.dataSource = self
        }
    }
    
    var subDivisonlist = [GroupDivisonData]()
    var groupId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewSubDivison.adjustDesign(width: ((view.frame.size.width+20)/2.3))
        fetchSubDivisonsData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "SubCategories"
        lblEmpty.text = "Empty List".localized
        lblMessage.text = "Sorry there no data available".localized
        self.setNavigationBar()
        self.addBackButton()
    }
    
    @IBAction func tryAgain(_ sender: UIButton) {
        self.viewEmptyList.isHidden = true
        fetchSubDivisonsData()
    }
    
    private func fetchSubDivisonsData(){
        startLoading("")
        GDSManager().gethDivisonsOfGoup(groupId,successCallback:
            {[weak self](response) in
                DispatchQueue.main.async{
                    self?.finishLoading()
                    if let subDivisonResponse = response{
                        if(subDivisonResponse.data ?? []).count == 0{
                            self?.viewEmptyList.isHidden = false
                        }else{
                            self?.subDivisonlist = subDivisonResponse.data ?? []
                            self?.collectionViewSubDivison.reloadData()
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
}

extension VCSubDivisions: UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subDivisonlist.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellStores", for: indexPath) as! CellStores
        let subdivision = subDivisonlist[indexPath.row]
        cell.setupSubDivisonCell(subdivision)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if let id = subDivisonlist[indexPath.row]._id{
            moveToStoreDetail(id)
        }
    }
    
    private func moveToStoreDetail(_ storeid:String){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCStoreProducts") as! VCStoreProducts
        //vc.storeid = storeid
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


