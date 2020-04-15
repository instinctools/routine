//
//  TableView.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/23/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import SwiftUI
import UIKit

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

class TaskTableViewCell: HostingTableViewCell<TaskRowView> {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: type(of: self))
    }
}

//struct TableView<Data, Content: View>: UIViewRepresentable {
//
//    var data: [Data]
//    var content: (Data) -> Content
////    var onReset: ((Int) -> Void)? = nil
//
//    func makeUIView(context: Context) -> UITableView {
//        let tableView = UITableView()
//        tableView.delegate = context.coordinator
//        tableView.dataSource = context.coordinator
//        tableView.backgroundColor = .clear
//        tableView.separatorStyle = .none
//
//        let id = String(describing: TaskTableViewCell.self)
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: id)
//
//        return tableView
//    }
//
//    func updateUIView(_ uiView: UITableView, context: Context) {
////        let dataSource = context.coordinator.dataSource
//        uiView.reloadData()
//    }
//
//    func makeCoordinator() -> Coordinator<Data, Content> {
//        return Coordinator(data: data, content: content)
//    }
//}
//
//class Coordinator<Data, Content>: NSObject, UITableViewDelegate, UITableViewDataSource where Content: View {
//    
//    var data: [Data]
////    var id: KeyPath<Items.Element, String>
//    var content: (Data) -> Content
//    
//    init(data: [Data], content: @escaping (Data) -> Content) {
//        self.data = data
//        self.content = content
//    }
//    
//    func tableView(_ tableView: UITableView,
//                   numberOfRowsInSection section: Int) -> Int {
//        return data.count
//    }
//    
//    func tableView(_ tableView: UITableView,
//                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let identifier = String(describing: TaskTableViewCell.self)
//        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
//        let swiftUIView: UIView = UIHostingController(
//            rootView: content(data[indexPath.row])
//        ).view
//        swiftUIView.translatesAutoresizingMaskIntoConstraints = false
//        cell.contentView.addSubview(swiftUIView)
//
//        NSLayoutConstraint.activate([
//            swiftUIView.leftAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.leftAnchor),
//            swiftUIView.rightAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.rightAnchor),
//            swiftUIView.topAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.topAnchor),
//            swiftUIView.bottomAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.bottomAnchor),
//        ])
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView,
//                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let action = UIContextualAction(style: .normal, title: "") {  (contextualAction, view, completion) in
//            completion(true)
//        }
//
//        action.backgroundColor = .clear
//        action.image = UIImage(named: "Reset")
//        let swipeActions = UISwipeActionsConfiguration(actions: [action])
//
//        return swipeActions
//    }
//}
