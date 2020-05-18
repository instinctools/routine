//
//  AnimationConfiguration.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 5/20/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit

struct AnimationConfiguration {
    let insertAnimation: UITableView.RowAnimation
    let reloadAnimation: UITableView.RowAnimation
    let deleteAnimation: UITableView.RowAnimation

    init(insertAnimation: UITableView.RowAnimation = .automatic,
         reloadAnimation: UITableView.RowAnimation = .automatic,
         deleteAnimation: UITableView.RowAnimation = .automatic) {
        self.insertAnimation = insertAnimation
        self.reloadAnimation = reloadAnimation
        self.deleteAnimation = deleteAnimation
    }
}
