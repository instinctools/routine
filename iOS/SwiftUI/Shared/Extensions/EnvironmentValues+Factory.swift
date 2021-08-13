//
//  EnvironmentValues+Factory.swift
//  EnvironmentValues+Factory
//
//  Created by Vadim Koronchik on 10.08.21.
//

import SwiftUI

struct FactoryKey: EnvironmentKey {
    static let defaultValue: FactoryProtocol = Factory()
}

extension EnvironmentValues {
    var factory: FactoryProtocol {
        get {
            return self[FactoryKey.self]
        }
        set {
            self[FactoryKey.self] = newValue
        }
    }
}
