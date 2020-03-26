//
//  DismissingKeyboard.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/24/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import SwiftUI
import UIKit

struct DismissingKeyboard: ViewModifier {
    func body(content: Content) -> some View {
        content.onTapGesture {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil
            )
        }
    }
}
