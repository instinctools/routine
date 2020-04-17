//
//  View+UIView.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 4/20/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit
import SwiftUI

extension View {
    var uiView: UIView {
        return UIHostingController(rootView: self).view
    }
}
