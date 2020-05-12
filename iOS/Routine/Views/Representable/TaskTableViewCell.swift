//
//  TaskTableViewCell.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/23/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit
import SwiftUI
import SwipeCellKit

class HostingTableViewCell<Content: View>: SwipeTableViewCell {

    private weak var controller: UIHostingController<Content>?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        controller?.willMove(toParent: nil)
        controller?.removeFromParent()
        contentView.subviews.forEach { $0.removeFromSuperview() }
    }

    func host(_ view: Content, parent: UIViewController) {
        let swiftUICellViewController = UIHostingController(rootView: view)
        controller = swiftUICellViewController
        swiftUICellViewController.view.backgroundColor = .clear

        layoutIfNeeded()

        parent.addChild(swiftUICellViewController)
        contentView.addSubview(swiftUICellViewController.view)
        swiftUICellViewController.view.snp.makeConstraints { (make) in
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.top.equalTo(contentView.snp.top)
            make.bottom.equalTo(contentView.snp.bottom)
        }
        swiftUICellViewController.didMove(toParent: parent)
        swiftUICellViewController.view.layoutIfNeeded()
    }
}

final class TaskTableViewCell: HostingTableViewCell<TaskRowView> {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
