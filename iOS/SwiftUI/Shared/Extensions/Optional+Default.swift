//
//  Optional+Default.swift
//  Optional+Default
//
//  Created by Vadim Koronchik on 29.07.21.
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

extension Optional where Wrapped == Task.ResetType {
    var orDefault: Task.ResetType {
        return self ?? .byPeriod
    }
}

extension Optional where Wrapped == Period {
    var orDefault: Period {
        return self ?? .day
    }
}
