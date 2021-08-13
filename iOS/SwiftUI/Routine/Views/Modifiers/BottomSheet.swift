//
//  BottomSheetView.swift
//  BottomSheetView
//
//  Created by Vadim Koronchik on 2.08.21.
//

import SwiftUI

struct BottomSheet<Base: View, Content: View>: View {
    
    @Binding var isPresented: Bool
    
    let base: Base
    let content: () -> Content
    
    var body: some View {
        ZStack(alignment: .bottom) {
            base
                .zIndex(0)
            
            if isPresented {
                Color(.init(white: 0, alpha: 0.3))
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation { self.isPresented = false }
                    }
                    .transition(.opacity)
                    .zIndex(1)
                
                content()
                    .background(
                        CornerRadiusShape(radius: 14, corners: [.topLeft, .topRight])
                            .fill(.background)
                            .ignoresSafeArea()
                    )
                    .transition(.move(edge: .bottom))
                    .zIndex(2)
            }
        }
    }
}

struct BottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheet(isPresented: .constant(true), base: EmptyView()) {
            Text("Hello")
                .padding()
                .frame(maxWidth: .infinity)
        }
    }
}

extension View {
    func bottomSheet<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        BottomSheet(isPresented: isPresented, base: self, content: content)
    }
}
