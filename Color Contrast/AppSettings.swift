//
//  AppSettings.swift
//  Color Contrast
//
//  Created by Paolo Ladisa on 12/10/2018.
//  Copyright © 2018 Paolo. All rights reserved.
//

import Foundation

enum PLColorFormat : Int {
    case rgb
    case hex
}

enum PLFontStyle: Int{
    case regular
    case bold
}

protocol AppSettings {
    var colorFormat : PLColorFormat { get set }
    var fontSize: Int { get set }
    var fontStyle: PLFontStyle { get set }
}
