
import UIKit
import XLPagerTabStrip

class   VCNearByProductList: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {        return IndicatorInfo(title: "NearBy")    }
    
    
    @IBOutlet var collectionViewProductnearby: UICollectionView!

    
    let imgFaces = [UIImage(named: "color"),UIImage(named: "color"),UIImage(named: "color"),UIImage(named: "color"),UIImage(named: "color"),UIImage(named: "color")]
    let lblName = ["Sunglasses","Watches","Smart Phone","Glasses","Wathces","Smart"]
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    collectionViewProductnearby.adjustDesign(width: (view.frame.size.width+24)/2.3)
        
        
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgFaces.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellNearBy", for: indexPath) as! CellNearBy
        
        return cell
        
        
        
    }
    
    
}




