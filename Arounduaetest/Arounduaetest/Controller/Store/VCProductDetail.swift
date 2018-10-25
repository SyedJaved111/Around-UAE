//
//  VCProductDetail.swift
//  AroundUAE
//
//  Created by Zafar Najmi on 19/09/2018.
//  Copyright © 2018 Zafar Najmi. All rights reserved.
//

import UIKit
import Cosmos

class VCProductDetail: UIViewController {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var prodcutPrice: UILabel!
    @IBOutlet weak var productname: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var favouriteBtn: UIButton!
    @IBOutlet weak var Productcounter: GMStepperCart!
    @IBOutlet weak var productDescription: UITextView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var reviewBtn: UIButton!
    @IBOutlet weak var favouritImage: UIImageView!
    @IBOutlet weak var CollectionView: UICollectionView!{
        didSet{
            CollectionView.delegate = self
            CollectionView.dataSource = self
            CollectionView.allowsSelection = true
            CollectionView.allowsMultipleSelection = true
        }
    }
    
    var product:Products!
    var productDetail:Product?
    var selectedCell = [IndexPath]()
    var features = [String]()
    var characteristics = [String]()
    var combination:Combinations?
    var dictionary:[String:Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getProductDetail()
    }
    
    override func viewDidLayoutSubviews(){
        super.updateViewConstraints()
        collectionViewHeight.constant = CollectionView.contentSize.height
        scrollview.contentSize = CGSize(width: UIScreen.main.bounds.width, height: scrollview.contentSize.height)
    }
    
    private func getProductDetail(){
        startLoading("")
        ProductManager().productDetail(product._id!,
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                self?.finishLoading()
                if let storeResponse = response{
                    if storeResponse.success!{
                        self?.productDetail = storeResponse.data!
                        self?.setupProductDetsil(storeResponse.data!)
                        self?.CollectionView.reloadData()
                    }else{
                        self?.alertMessage(message: (lang == "en") ? storeResponse.message?.en ?? "" : storeResponse.message?.ar ?? "" , completionHandler: nil)
                    }
                }else{
                    self?.alertMessage(message: (lang == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
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
    
    private func checKCombination(){
        
        var dic = [String:Any]()
        dic["product"] = product._id!
        dic["quantity"] = "\(Int(Productcounter.value))"
        
        if let combinations = productDetail?.combinations{
            for obj in combinations{
                if obj.features! != features && obj.characteristics! != characteristics {
                    self.alertMessage(message: "Could not find combination!!", completionHandler: nil)
                    return
                }else if obj.features! == features && obj.characteristics! == characteristics{
                    prodcutPrice.text = (lang == "en") ? "$\(obj.price?.usd ?? 0)" : "$\(obj.price?.aed ?? 0)"
                    combination = obj
                    dictionary = dic
                    break
                }
            }
        }
    }
    
    private func addToCartProduct(_ dict:[String:Any]){
        var dictoinary = dict
        dictoinary["quantity"] = "\(Int(Productcounter.value))"
        dictoinary["combination"] = combination?._id ?? ""
        startLoading("")
        CartManager().addCartProducts(dictoinary,
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                self?.finishLoading()
                if let storeResponse = response{
                    if storeResponse.success!{
                        self?.alertMessage(message: (lang == "en") ? storeResponse.message?.en ?? "" : storeResponse.message?.ar ?? "", completionHandler: {
                            self?.navigationController?.popViewController(animated: true)
                        })
                    }else{
                        self?.alertMessage(message: (lang == "en") ? storeResponse.message?.en ?? "" : storeResponse.message?.ar ?? "", completionHandler: {
                            self?.navigationController?.popViewController(animated: true)
                        })
                    }
                }else{
                    self?.alertMessage(message: (lang == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: {
                        self?.navigationController?.popViewController(animated: true)
                    })
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
    
    private func setupProductDetsil(_ productdetail:Product){
        productImage.sd_setShowActivityIndicatorView(true)
        productImage.sd_setIndicatorStyle(.gray)
        productImage.sd_setImage(with: URL(string: product.images?.first?.path ?? ""))
        prodcutPrice.text = (lang == "en") ? "$\(product.price?.usd ?? 0)" : "$\(product.price?.aed ?? 0)"
        productname.text = (lang == "en") ? productdetail.productName?.en ?? "" : productdetail.productName?.ar ?? ""
        ratingView.rating = 0.0
        if AppSettings.sharedSettings.user.favouritePlaces?.contains((productDetail?._id!)!) ?? false{
            self.favouritImage.image = #imageLiteral(resourceName: "Favourite-red")
            self.favouriteBtn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }else{
            self.favouritImage.image = #imageLiteral(resourceName: "Favourite")
            self.favouriteBtn.backgroundColor = #colorLiteral(red: 0.06314799935, green: 0.04726300389, blue: 0.03047090769, alpha: 1)
        }
        productDescription.text = (lang == "en") ? productdetail.description?.en ?? "" : productdetail.description?.ar ?? ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Product Detail".localized
        if(lang == "ar"){
            showArabicBackButton()
        }else{
            self.addBackButton()
        }
        if AppSettings.sharedSettings.accountType == "seller"{
            self.reviewBtn.backgroundColor = #colorLiteral(red: 0.06274509804, green: 0.04705882353, blue: 0.03137254902, alpha: 1)
            self.reviewBtn.isUserInteractionEnabled = false
        }else{
            self.reviewBtn.backgroundColor = #colorLiteral(red: 0.8745098039, green: 0.1882352941, blue: 0.3176470588, alpha: 1)
            self.reviewBtn.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func addtocartclick(_ sender: Any){
        
        if features.count == 0 || characteristics.count == 0{
            self.alertMessage(message: "Please Select Some Combination or Feature...".localized, completionHandler: nil)
            return
        }
        
        checKCombination()
        
        guard let comb = combination,
            let avaliablecount = comb.avalaible,avaliablecount > Int(Productcounter.value) else{
                self.alertMessage(message: "Product is not avaliable in your desired quantity".localized, completionHandler: nil)
                return
        }
        
        if Productcounter.value == 0.0{
            self.alertMessage(message: "Please Select Your Quantity".localized, completionHandler: nil)
            return
        }
        
        if dictionary != nil{
           addToCartProduct(dictionary!)
        }
    }
    
    @IBAction func makeProductFavourite(_ sender: Any){
        startLoading("")
        ProductManager().makeProductFavourite((productDetail?._id!)!,
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                self?.finishLoading()
                if let favouriteResponse = response{
                    if favouriteResponse.success!{
                        AppSettings.sharedSettings.user = favouriteResponse.data!
                        if AppSettings.sharedSettings.user.favouritePlaces?.contains((self?.productDetail?._id!)!) ?? false{
                            self?.favouritImage.image = #imageLiteral(resourceName: "Favourite-red")
                            self?.favouriteBtn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                        }else{
                            self?.favouritImage.image = #imageLiteral(resourceName: "Favourite")
                            self?.favouriteBtn.backgroundColor = #colorLiteral(red: 0.06314799935, green: 0.04726300389, blue: 0.03047090769, alpha: 1)
                        }
                    }else{
                        self?.alertMessage(message: (lang == "en") ? favouriteResponse.message?.en ?? "" : favouriteResponse.message?.ar ?? "", completionHandler: nil)
                    }
                }else{
                    self?.alertMessage(message: (lang == "en") ? response?.message?.en ?? "" : response?.message?.ar ?? "", completionHandler: nil)
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
    
    @IBAction func submitProductReview(_ sender: UIButton) {
        if AppSettings.sharedSettings.accountType == "buyer"{
            moveToPopVC((productDetail?._id!)!)
        }
    }
    
    private func moveToPopVC(_ productid:String){
        let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VCPopUp") as! VCPopUp
        vc.productid = productid
        self.present(vc, animated: true, completion: nil)
    }
}

extension VCProductDetail: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return productDetail?.priceables?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var resuable :UICollectionReusableView? = nil
        if kind == UICollectionElementKindSectionHeader{
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ProductDetailView", for: indexPath) as! ProductDetailView
            view.lblHeader.text =  (lang == "en") ? productDetail?.priceables?[indexPath.section].feature?.title?.en : productDetail?.priceables?[indexPath.section].feature?.title?.ar
            resuable = view
            return resuable!
        }
        return resuable!
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productDetail?.priceables?[section].characteristics?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacteristicsCell", for: indexPath) as! CharacteristicsCell
        cell.setupCell(productDetail?.priceables?[indexPath.section].characteristics?[indexPath.row].image ?? "")
        if selectedCell.contains(indexPath){
            cell.characterImage.layer.borderWidth = 2.0
            cell.characterImage.layer.borderColor = UIColor.red.cgColor
        }
        else{
            cell.characterImage.layer.borderWidth = 2.0
            cell.characterImage.layer.borderColor = UIColor.clear.cgColor
        }
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath) as! CharacteristicsCell
//        selectedCell.append(indexPath)
//        cell.characterImage.layer.borderWidth = 2.0
//        cell.characterImage.layer.borderColor = UIColor.red.cgColor
//        characteristics.append(productDetail?.priceables?[indexPath.section].characteristics?[indexPath.row]._id ?? "")
//        features.append(productDetail?.priceables?[indexPath.section].feature?._id ?? "")
//    }
    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath) as! CharacteristicsCell
//        if  selectedCell.contains(indexPath){
//            selectedCell.remove(at: selectedCell.index(of: indexPath)!)
//            characteristics.remove(at: characteristics.index(of: productDetail?.priceables?[indexPath.section].characteristics?[indexPath.row]._id ?? "")!)
//            features.remove(at: features.index(of: productDetail?.priceables?[indexPath.section].feature?._id ?? "")!)
//            cell.characterImage.layer.borderWidth = 2.0
//            cell.characterImage.layer.borderColor = UIColor.clear.cgColor
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedRows = self.CollectionView.indexPathsForSelectedItems!
        //let cell = collectionView.cellForItem(at: indexPath) as! CharacteristicsCell

        for selectedRow in selectedRows {
            if (selectedRow.section == indexPath.section) && (selectedRow.row != indexPath.row) {
                //cell.characterImage.layer.borderWidth = 2.0/
                //cell.characterImage.layer.borderColor = UIColor.clear.cgColor
                self.CollectionView.deselectItem(at: selectedRow, animated: false)
            }else{
               //cell.characterImage.layer.borderWidth = 2.0
                //cell.characterImage.layer.borderColor = UIColor.red.cgColor
            }
        }
    }
}
