//
//  Transition.swift
//  Routine
//
//  Created by Vadim Koronchik on 6/3/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit

final class BottomCardTransition: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        
        return PresentationController(
            presentedViewController: presented,
            presenting: presenting ?? source
        )
    }
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentDismissAnimation(transition: .present)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentDismissAnimation(transition: .dismiss)
    }
}
