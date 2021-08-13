//
//  BottomCardViewController.swift
//  Routine
//
//  Created by Vadim Koronchik on 6/3/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit

class BottomCardViewController: UIViewController {

    private let transition = BottomCardTransition()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        transitioningDelegate = transition
        modalPresentationStyle = .custom
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
