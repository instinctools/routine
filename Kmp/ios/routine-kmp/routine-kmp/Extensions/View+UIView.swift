import UIKit
import SwiftUI

extension View {
    var uiView: UIView {
        return UIHostingController(rootView: self).view
    }
}

extension View {

    func snackBar(isShowing: Binding<Bool>,
                  text: Text,
                  actionText: Text? = nil,
                  action: (() -> Void)? = nil) -> some View {

        Snackbar(isShowing: isShowing,
                 presenting: self,
                 text: text,
                 actionText: actionText,
                 action: action)

    }

}
