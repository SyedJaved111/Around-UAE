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
    @IBOutlet weak var Productcounter: GMStepper!
    @IBOutlet weak var productDescription: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var colorCollectionView: UICollectionView!{
        didSet{
            colorCollectionView.delegate = self
            colorCollectionView.dataSource = self
        }
    }
    
    @IBOutlet weak var sizeCollectionView: UICollectionView!{
        didSet{
            sizeCollectionView.delegate = self
            sizeCollectionView.dataSource = self
        }
    }
    
    var product:Products!
    var productDetail:Product?

    override func viewDidLoad() {
        super.viewDidLoad()
        getProductDetail()
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
                        self?.colorCollectionView.reloadData()
                        self?.sizeCollectionView.reloadData()
                    }
                }else{
                    self?.alertMessage(message: "Error".localized, completionHandler: nil)
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
    
    private func addToCart(){
        
        var dic = [String:Any]()
        var features = [String]()
        var characteristics = [String]()
        
        if let sizeindxpaths = sizeCollectionView.indexPathsForSelectedItems{
            for indxpath in sizeindxpaths{
                print(indxpath.row)
                dic["characteristics[\(indxpath.row)]"] = productDetail?.priceables?[0].characteristics?[indxpath.row]._id ?? ""
                characteristics.append(productDetail?.priceables?[0].characteristics?[indxpath.row]._id ?? "")
            }
            dic["features[\(0)]"] = productDetail?.priceables?[0].feature?._id ?? ""
            features.append(productDetail?.priceables?[0].feature?._id ?? "")
        }
        
        if let colorindxpaths = colorCollectionView.indexPathsForSelectedItems{
            for indxpath in colorindxpaths{
                print(indxpath.row)
                dic["characteristics[\(indxpath.row)]"] = productDetail?.priceables?[1].characteristics?[indxpath.row]._id ?? ""
                characteristics.append(productDetail?.priceables?[1].characteristics?[indxpath.row]._id ?? "")
            }
            dic["features[\(1)]"] = productDetail?.priceables?[1].feature?._id ?? ""
            features.append(productDetail?.priceables?[1].feature?._id ?? "")
        }
       
        dic["product"] = product._id!
        dic["quantity"] = "\(Int(Productcounter.value))"
       
        if let combinations = productDetail?.combinations{
            for obj in combinations{
                if obj.characteristics != characteristics && obj.features != features {
                    self.alertMessage(message: "Could not find combination!!", completionHandler: nil)
                    return
                }else if obj.characteristics == characteristics && obj.features == features{
                    addToCartProduct(dic)
                    break
                }
            }
        }
    }
    
    private func addToCartProduct(_ dict:[String:Any]){
        startLoading("")
        CartManager().addCartProducts(dict,
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                self?.finishLoading()
                if let storeResponse = response{
                    if storeResponse.success!{
                        
                    }else{
                        self?.alertMessage(message: (storeResponse.message?.en ?? "").localized, completionHandler: nil)
                    }
                }else{
                    self?.alertMessage(message: response?.message?.en ?? "", completionHandler: nil)
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
        productImage.setShowActivityIndicator(true)
        productImage.setIndicatorStyle(.gray)
        productImage.sd_setImage(with: URL(string: product.images?.first?.path ?? ""))
        prodcutPrice.text = "$\(product.price?.usd ?? 0)"
        productname.text = productdetail.productName?.en ?? ""
        ratingView.rating = 0.0
        productDescription.text = productdetail.description?.en ?? ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Product Detail"
        self.addBackButton()
    }
    
    @IBAction func addtocartclick(_ sender: Any) {
       addToCart()
    }
}

extension VCProductDetail: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView{
            case colorCollectionView:
                return productDetail?.priceables?[1].characteristics?.count ?? 0
            case sizeCollectionView:
                return productDetail?.priceables?[0].characteristics?.count ?? 0
            default:
                return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacteristicsCell", for: indexPath) as! CharacteristicsCell
        switch collectionView{
            case colorCollectionView:
                cell.setupCell(productDetail?.priceables?[1].characteristics?[indexPath.row].image ?? "")
            case sizeCollectionView:
                cell.setupCell(productDetail?.priceables?[0].characteristics?[indexPath.row].image ?? "")
            default:
                return cell
            }
        return cell
    }
}
