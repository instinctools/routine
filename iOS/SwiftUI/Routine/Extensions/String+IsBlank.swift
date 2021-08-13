//
//  String+IsBlank.swift
//  String+IsBlank
//
//  Created by Vadim Koronchik on 30.07.21.
//

extension String {
    var isBlank: Bool {
        return allSatisfy(\.isWhitespace)
    }
}
