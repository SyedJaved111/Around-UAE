
import Foundation
import XLPagerTabStrip

class VCMyOrders: ButtonBarPagerTabStripViewController {
    
    @IBOutlet var collectionViewPager: ButtonBarView!
    override func viewDidLoad() {
        settings.style.buttonBarBackgroundColor = .red
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = #colorLiteral(red: 0.9607843137, green: 0.003921568627, blue: 0.2039215686, alpha: 1)
        
        settings.style.buttonBarItemFont = UIFont(name: "Raleway-Medium", size: 15)!
        settings.style.selectedBarHeight = 4
     
        settings.style.buttonBarItemTitleColor = .red
        settings.style.selectedBarBackgroundColor = UIColor.red
        settings.style.buttonBarBackgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1);        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
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
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.addBackButton()
        self.title = "My Orders"
    }
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
      let child_2 = UIStoryboard(name: "HomeTabs", bundle: nil).instantiateViewController(withIdentifier: "VCPendingProducts")
      let child_3 = UIStoryboard(name: "HomeTabs", bundle: nil).instantiateViewController(withIdentifier: "VCShippedProducts")
      let child_4 = UIStoryboard(name: "HomeTabs", bundle: nil).instantiateViewController(withIdentifier: "VCDilverdProducts")
        return [child_2,child_3,child_4]
    }
}

