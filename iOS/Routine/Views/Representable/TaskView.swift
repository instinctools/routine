//
//  TaskView.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 3/25/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import UIKit
import SwiftUI

struct TaskView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<TaskView>) -> TaskViewController {
        let viewController = TaskViewController(viewModel: .init())
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: TaskViewController, context: UIViewControllerRepresentableContext<TaskView>) {
        
    }
}

struct TransitionLink<Content, Destination>: View where Content: View, Destination: View {
    @Binding var isPresented: Bool
    var content: () -> Content
    var destination: () -> Destination
    
    init(isPresented: Binding<Bool>, @ViewBuilder destination: @escaping () -> Destination, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.destination = destination
        self._isPresented = isPresented
    }
    
    var body: some View {
        ZStack {
            if self.isPresented {
                self.destination()
                    .transition(.move(edge: .bottom))
            } else {
                self.content()
            }
        }
    }
}

struct ModaLinkViewModifier<Destination>: ViewModifier where Destination: View {
    
    @Binding var isPresented: Bool
    var destination: () -> Destination
    
    func body(content: Self.Content) -> some View {
        TransitionLink(
            isPresented: self.$isPresented,
            destination: {
                self.destination()
            },
            content: {
                content
            }
        )
     }
}

extension View {
    func modalLink<Destination: View>(isPresented: Binding<Bool>,
                                      destination: @escaping () -> Destination) -> some View {
        self.modifier(ModaLinkViewModifier(isPresented: isPresented, destination: destination))
    }
}
