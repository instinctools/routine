//
//  PresentDismissAnimation.swift
//  Routine
//
//  Created by Vadim Koronchik on 6/3/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit
import Foundation

final class PresentDismissAnimation: NSObject {
    
    enum Transition {
        case present
        case dismiss
    }
    
    private let duration = 0.3
    private let transition: Transition
    
    init(transition: Transition) {
        self.transition = transition
    }
    
    private func makeAnimator(using transitionContext: UIViewControllerContextTransitioning,
                              animations: @escaping () -> Void) -> UIViewImplicitlyAnimating {
        let animator = UIViewPropertyAnimator(
            duration: duration,
            curve: .easeOut,
            animations: animations
        )
        
        animator.addCompletion { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
        return animator
    }
    
    private func presentAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {

        guard let view = transitionContext.view(forKey: .to),
            let viewController = transitionContext.viewController(forKey: .to) else {
                return UIViewPropertyAnimator()
        }
        
        let finalFrame = transitionContext.finalFrame(for: viewController)
        view.frame = finalFrame.offsetBy(dx: 0, dy: finalFrame.height)
        
        let animator = makeAnimator(using: transitionContext) {
            view.frame = finalFrame
        }
        
        return animator
    }
    
    private func dismissAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        
        guard let fromView = transitionContext.view(forKey: .from),
            let fromViewController = transitionContext.viewController(forKey: .from) else {
                return UIViewPropertyAnimator()
        }
        
        let finalFrame = transitionContext.finalFrame(for: fromViewController)
        let animator = makeAnimator(using: transitionContext) {
            fromView.frame = finalFrame.offsetBy(dx: 0, dy: finalFrame.height)
        }

        return animator
    }
    
    private func animator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        switch transition {
        case .present:
            return presentAnimator(using: transitionContext)
        case .dismiss:
            return dismissAnimator(using: transitionContext)
        }
    }
}

extension PresentDismissAnimation: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animator = self.animator(using: transitionContext)
        animator.startAnimation()
    }

    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        return animator(using: transitionContext)
    }
}
