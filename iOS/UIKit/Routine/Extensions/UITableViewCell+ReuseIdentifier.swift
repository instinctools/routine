//
//  UITableViewCell+ReuseIdentifier.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 4/20/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: type(of: self))
    }
}
