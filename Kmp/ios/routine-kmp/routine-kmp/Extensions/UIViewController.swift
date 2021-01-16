import UIKit
import MBProgressHUD

extension UIViewController {
    
    func showErrorAlert(
        title: String,
        message: String,
        buttonTitle: String
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showToastMessage(message: String) {
        let view = self.navigationController?.view
        if(view != nil) {
            let hud = MBProgressHUD.showAdded(to: view!, animated: true)

            // Configure for text only and offset down
            hud.mode = MBProgressHUDMode.text
            hud.label.text = message
            hud.margin = 10;
            //hud.yOffset = 150;
            hud.removeFromSuperViewOnHide = true;

            hud.hide(animated: true, afterDelay: 3)
        }
    }
}
