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
