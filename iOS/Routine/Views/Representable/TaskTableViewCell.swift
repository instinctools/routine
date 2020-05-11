//
//  TaskTableViewCell.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/23/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit
import SwiftUI

extension UITableView {
    var swipeCells: [TaskTableViewCell] {
        return visibleCells.compactMap({ $0 as? TaskTableViewCell })
    }

    func hideSwipeCell() {
        swipeCells.forEach { $0.hideSwipe() }
    }
}

extension UITableViewCell {
    var tableView: UITableView? {
        var view = superview
        while let v = view, v.isKind(of: UITableView.self) == false {
            view = v.superview
        }
        return view as? UITableView
    }
}

class HostingTableViewCell<Content: View>: UITableViewCell {

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
    
    private var taskView: TaskRowView?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        taskView = nil
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
//        if !editing {
//            taskView?.hideSwipe()
//        }
    }
    
    func setup(from parent: UIViewController,
               viewModel: TaskViewModel,
               onReset: @escaping EmptyAction,
               onDelete: @escaping EmptyAction) {
        
        let view = TaskRowView(
            viewModel: viewModel,
            onLeftAction: onReset,
            onRightAction: onDelete,
            onStartAction: {
                self.tableView?.hideSwipeCell()
            }
        )
        host(view, parent: parent)
    }
    
    override func host(_ view: TaskRowView, parent: UIViewController) {
        super.host(view, parent: parent)
        taskView = view
    }
    
    func hideSwipe() {
        taskView?.hideSwipe()
    }
}
