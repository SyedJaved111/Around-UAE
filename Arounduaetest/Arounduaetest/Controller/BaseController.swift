
import UIKit
import MBProgressHUD

class BaseController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func showAlert(_ message: String, tryAgainClouser:@escaping (UIAlertAction)->Void){
        
        let alert = UIAlertController(title: "Alert".localized, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: tryAgainClouser)
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func getControllerRef(controller toPush:String,storyboard:String) -> UIViewController{
        return UIStoryboard(name: storyboard, bundle:nil).instantiateViewController(withIdentifier: toPush)
    }
}

extension UIViewController{
    
    func finishLoading(){
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func startLoading(_ message:String){
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = message
        loadingNotification.animationType = .zoom
    }
    
    func alertMessage(message:String,completionHandler:(()->())?) {
        let alert = UIAlertController(title:"", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
            completionHandler?()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
