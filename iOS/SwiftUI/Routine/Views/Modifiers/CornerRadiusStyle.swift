//
//  CornerRadiusStyle.swift
//  CornerRadiusStyle
//
//  Created by Vadim Koronchik on 2.08.21.
//

import SwiftUI

struct CornerRadiusShape: Shape {
    
    var radius = CGFloat.infinity
    var corners = UIRectCorner.allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: .init(width: radius, height: radius))
        return .init(path.cgPath)
    }
}

struct CornerRadiusStyle: ViewModifier {
    
    var radius: CGFloat
    var corners: UIRectCorner
    
    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}

extension View {
    func cornerRadius(radius: CGFloat, corners: UIRectCorner) -> some View {
        modifier(CornerRadiusStyle(radius: radius, corners: corners))
    }
}

