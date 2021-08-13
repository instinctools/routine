//
//  UIBarButtonItem+Init.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 4/20/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    convenience init(barButtonSystemItem systemItem: UIBarButtonItem.SystemItem) {
        self.init(barButtonSystemItem: systemItem, target: nil, action: nil)
    }
}
