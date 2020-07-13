import UIKit
import SwiftUI

extension View {
    var uiView: UIView {
        return UIHostingController(rootView: self).view
    }
}
