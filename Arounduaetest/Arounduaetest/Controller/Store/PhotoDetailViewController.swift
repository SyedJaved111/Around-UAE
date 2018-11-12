
import UIKit

class PhotoDetailViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrolView: UIScrollView!
    @IBOutlet weak var imgPhoto: UIImageView!
    var detailImage:UIImage?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setNavigationBar()
        addBackButton()
        self.title = "Picture"
        scrolView.delegate = self
        scrolView.minimumZoomScale = 1.0
        scrolView.maximumZoomScale = 10.0
        imgPhoto.image = detailImage
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgPhoto
    }
}

