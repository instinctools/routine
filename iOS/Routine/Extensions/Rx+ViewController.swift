//
//  Rx+ViewController.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 5/20/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension RxSwift.Reactive where Base: UIViewController {
    var viewWillAppear: ControlEvent<Void> {
        let source = methodInvoked(#selector(Base.viewWillAppear)).map { _ in }
        return ControlEvent(events: source)
    }
}
