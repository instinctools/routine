//
//  ContentView.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/23/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var showingNew = false
    
    var body: some View {
        if showingNew {
            return AnyView(NavigationView {
                TaskView()
                    .navigationBarTitle("", displayMode: .inline)
                    .navigationBarItems(
                        leading: Button(action: {
                            self.showingNew.toggle()
                        }, label: {
                            Text("Cancel")
                        }),
                        trailing: Button(action: {
                            self.showingNew.toggle()
                        }, label: {
                            Text("Done")
                                .fontWeight(.bold)
                        })
                    )
//                    .background(NavigationConfigurator { nc in
//                        nc.navigationBar.barTintColor = .systemBackground
//                    })
            })
        } else {
            return AnyView(NavigationView {
                TaskListView()
                    .navigationBarTitle("Routine")
                    .navigationBarItems(trailing:
                        Button(action: {
                            self.showingNew.toggle()
                        }, label: {
                            Image(systemName: "plus").imageScale(.large).padding()
                        })
                    )
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct TableViewConfigurator: UIViewRepresentable {

    var configure: (UITableView) -> Void = { _ in }

    func makeUIView(context: UIViewRepresentableContext<TableViewConfigurator>) -> UITableView {
        UITableView()
    }
    
    func updateUIView(_ uiView: UITableView, context: UIViewRepresentableContext<TableViewConfigurator>) {
        self.configure(uiView)
    }
}

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }

}
