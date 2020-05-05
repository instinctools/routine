//
//  String+OrEmpty.swift
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
}
