//
//  Optional+Default.swift
//  Routine
//
//  Created by Vadzim Karonchyk on 5/5/20.
//  Copyright © 2020 Instinctools. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
    var orEmpty: String {
        return self ?? ""
    }
    
    var nilIfEmpty: String? {
        return self == "" ? nil : self
    }
}

extension Optional where Wrapped == Date {
    var orToday: Date {
        return self ?? .init()
    }
}
