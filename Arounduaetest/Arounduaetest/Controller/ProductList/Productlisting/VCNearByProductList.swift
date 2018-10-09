
import UIKit
import XLPagerTabStrip

class VCNearByProductList: BaseController,IndicatorInfoProvider{
    
    var productarray = [Products]()
    
    @IBOutlet var collectionViewProductnearby: UICollectionView!{
        didSet{
            collectionViewProductnearby.delegate = self
            collectionViewProductnearby.dataSource = self
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        collectionViewProductnearby.adjustDesign(width: (view.frame.size.width+24)/2.3)
        searchProducts()
    }
    
    private func searchProducts(){
        startLoading("")
        ProductManager().SearchProduct("",
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                self?.finishLoading()
                if let productsResponse = response{
                    if productsResponse.success!{
                        self?.productarray = productsResponse.data?.products ?? []
                        self?.collectionViewProductnearby.reloadData()
                    }
                    else{
                        self?.alertMessage(message: (productsResponse.message?.en ?? "").localized, completionHandler: nil)
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
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo{
        return IndicatorInfo(title: "NearBy")
    }
}

extension VCNearByProductList: UICollectionViewDelegate,UICollectionViewDataSource{
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return productarray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellNearBy", for: indexPath) as! CellNearBy
        cell.setupNearbyData(product: productarray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if AppSettings.sharedSettings.accountType != "seller"{
            let storyboard = UIStoryboard(name: "HomeTabs", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "VCProductDetail") as! VCProductDetail
            vc.product = productarray[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}




