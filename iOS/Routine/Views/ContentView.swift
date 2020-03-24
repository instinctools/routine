//
//  ContentView.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/23/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            TaskListView()
                .navigationBarTitle("Routine")
                .navigationBarItems(trailing:
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "plus").imageScale(.large)
                    })
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
