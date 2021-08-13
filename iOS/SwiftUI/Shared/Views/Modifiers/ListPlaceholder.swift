//
//  List+Placeholder.swift
//  List+Placeholder
//
//  Created by Vadim Koronchik on 7.08.21.
//

import SwiftUI

private struct EmptyDataModifier<Items: Collection, Placeholder: View>: ViewModifier {
    
    let items: Items
    @ViewBuilder let placeholder: () -> Placeholder
    
    @ViewBuilder func body(content: Content) -> some View {
        if !items.isEmpty {
            content
        } else {
            placeholder()
        }
    }
}

extension List {
    func placeholder<Items: Collection, Placeholder: View>(
        _ items: Items,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) -> some View {
        modifier(EmptyDataModifier(items: items, placeholder: placeholder))
    }
}
