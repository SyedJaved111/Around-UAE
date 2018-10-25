
import UIKit
import XLPagerTabStrip

var searchKeyword = ""
class VCNearByProductList: BaseController,IndicatorInfoProvider{
    
    var productarray = [Products]()
    
    @IBOutlet var collectionViewProductnearby: UICollectionView!{
        didSet{
            collectionViewProductnearby.delegate = self
            collectionViewProductnearby.dataSource = self
            collectionViewProductnearby.alwaysBounceVertical = true
            collectionViewProductnearby.addSubview(refreshControl)
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(refreshTableView),for: UIControlEvents.valueChanged)
        refreshControl.tintColor = #colorLiteral(red: 0.8745098039, green: 0.1882352941, blue: 0.3176470588, alpha: 1)
        return refreshControl
    }()
    
    fileprivate func setupDelegates(){
        self.collectionViewProductnearby.emptyDataSetSource = self
        self.collectionViewProductnearby.emptyDataSetDelegate = self
        self.collectionViewProductnearby.reloadData()
    }
    
    @objc func refreshTableView() {
        if isFromHome{
            searchProducts(isRefresh: true, searchTxt: "")
        }else{
            searchProducts(isRefresh: true, searchTxt: searchKeyword)
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        collectionViewProductnearby.adjustDesign(width: (view.frame.size.width+24)/2.3)
        if isFromHome{
            searchProducts(isRefresh: false, searchTxt: "")
        }else{
            searchProducts(isRefresh: false, searchTxt: searchKeyword)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("SearchCompleted"), object: nil)
    }
    
    @objc func methodOfReceivedNotification(notification: Notification){
        if let data = notification.object as? [Products]{
           productarray = data
           collectionViewProductnearby.reloadData()
        }
    }
    
    private func searchProducts(isRefresh: Bool,searchTxt:String){
        if isRefresh == false{
            startLoading("")
        }
        
        ProductManager().SearchProduct(("",0,0,[String](),searchTxt),
        successCallback:
        {[weak self](response) in
            DispatchQueue.main.async {
                if isRefresh == false {
                    self?.finishLoading()
                }else {
                    self?.refreshControl.endRefreshing()
                }
                if let productsResponse = response{
                    if productsResponse.success!{
                        self?.productarray = productsResponse.data?.products ?? []
                    }
                    else{
                        if(lang == "en")
                        {
                        self?.alertMessage(message: (productsResponse.message?.en ?? "").localized, completionHandler: nil)
                        }else
                        {
                           self?.alertMessage(message: (productsResponse.message?.ar ?? "").localized, completionHandler: nil)
                        }
                    }
                }else{
                    if(lang == "en")
                    {
                    self?.alertMessage(message: (response?.message?.en ?? "").localized, completionHandler: nil)
                    }else{
                        
                         self?.alertMessage(message: (response?.message?.ar ?? "").localized, completionHandler: nil)
                    }
                    
                }
                self?.setupDelegates()
            }
        })
        {[weak self](error) in
            DispatchQueue.main.async {
                if isRefresh == false {
                    self?.finishLoading()
                }else {
                    self?.refreshControl.endRefreshing()
                }
                self?.setupDelegates()
                self?.alertMessage(message: error.message.localized, completionHandler: nil)
            }
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo{
        return IndicatorInfo(title: "Near By".localized)
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
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!){
        if isFromHome{
            searchProducts(isRefresh: false, searchTxt: "")
        }else{
            searchProducts(isRefresh: false, searchTxt: searchKeyword)
        }
    }
}




