//
//  EnabledButtonStyle.swift
//  EnabledButtonStyle
//
//  Created by Vadim Koronchik on 10.08.21.
//

import SwiftUI

struct EnabledButtonStyle: ButtonStyle {
    
    let enabledColor: Color
    let disabledColor: Color
    
    struct EnabledButton: View {
        
        let enabledColor: Color
        let disabledColor: Color
        let configuration: ButtonStyle.Configuration
        
        @Environment(\.isEnabled) private var isEnabled: Bool
        
        var body: some View {
            configuration.label.foregroundColor(isEnabled ? enabledColor : disabledColor)
        }
    }

    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        EnabledButton(enabledColor: enabledColor, disabledColor: disabledColor, configuration: configuration)
    }
}
