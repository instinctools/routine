//
//  UITableView+PlaceholderView.swift
//  Routine
//
//  Created by Vadim Koronchik on 6/11/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UITableView {
    var placeholderView: Binder<UIImage?> {
        return Binder(base) { tableView, image in
            if let image = image {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                imageView.alpha = 0.0
                tableView.backgroundView = imageView
                
                UIView.animate(withDuration: 0.3) {
                    imageView.alpha = 1.0
                }
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    tableView.backgroundView?.alpha = 0.0
                }, completion: { _ in
                    tableView.backgroundView = nil
                })
            }
        }
    }
}
