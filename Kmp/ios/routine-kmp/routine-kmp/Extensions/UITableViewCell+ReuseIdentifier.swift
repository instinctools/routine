import Foundation

import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: type(of: self))
    }
}
