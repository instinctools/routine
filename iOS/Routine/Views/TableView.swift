//
//  TableView.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/23/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import SwiftUI
import UIKit

struct TableView<Data, RowContent: View, ActionContent: View>: UIViewRepresentable {

    var data: [Data]
    var content: (Data) -> RowContent
    var resetActionView: (() -> ActionContent)? = nil
    var onReset: ((Int) -> Void)? = nil

    func makeUIView(context: Context) -> UITableView {
        let tableView = UITableView()
        tableView.delegate = context.coordinator
        tableView.dataSource = context.coordinator
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none

        let id = String(describing: UITableViewCell.self)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: id)

        return tableView
    }

    func updateUIView(_ uiView: UITableView, context: Context) {
//        let dataSource = context.coordinator.dataSource
        uiView.reloadData()
    }
    
    func makeCoordinator() -> Coordinator<Data, RowContent, ActionContent> {
        return Coordinator(data: data, content: content)
    }
}

class Coordinator<Data, RowContent, ActionContent>: NSObject, UITableViewDelegate, UITableViewDataSource where RowContent: View, ActionContent: View {
    
    var data: [Data]
//    var id: KeyPath<Items.Element, String>
    var rowContent: (Data) -> RowContent
    var actionContent: () -> ActionContent
    
    init(data: [Data], content: @escaping (Data) -> Content) {
        self.data = data
        self.content = content
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = String(describing: UITableViewCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let swiftUIView: UIView = UIHostingController(
            rootView: rowContent(data[indexPath.row])
        ).view
        swiftUIView.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(swiftUIView)

        NSLayoutConstraint.activate([
            swiftUIView.leftAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.leftAnchor),
            swiftUIView.rightAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.rightAnchor),
            swiftUIView.topAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.topAnchor),
            swiftUIView.bottomAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.bottomAnchor),
        ])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Reset") {  (contextualAction, view, completion) in
            
            completion(true)
        }
        action.image = 
        let swipeActions = UISwipeActionsConfiguration(actions: [action])

        return swipeActions
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        
    }
}
