//
//  AlphaExpansion.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 5/20/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit
import SwipeCellKit

struct AlphaExpansion: SwipeExpanding {
    func animationTimingParameters(buttons: [UIButton], expanding: Bool) -> SwipeExpansionAnimationTimingParameters {
        return .default
    }
    
    func actionButton(_ button: UIButton, didChange expanding: Bool, otherActionButtons: [UIButton]) {
        UIView.animate(withDuration: 0.2) {
            button.alpha = expanding ? 0.7 : 1.0
        }
    }
}
