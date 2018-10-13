//
//  AppUserDefaults.swift
//  Color Contrast
//
//  Created by Paolo Ladisa on 12/10/2018.
//  Copyright © 2018 Paolo. All rights reserved.
//

import Foundation

class AppUserDefaults: AppSettings {
    
    private struct Key {
        static let colorFormat = "com.paololadisa.Color-Contrast.colorFormat"
        static let fontSize = "com.paololadisa.Color-Contrast.fontSize"
        static let fontStyle = "com.paololadisa.Color-Contrast.fontStyle"
    }
    
    var colorFormat: PLColorFormat {
        get{
            let rawFormat = UserDefaults.standard.integer(forKey: Key.colorFormat)
            return PLColorFormat(rawValue: rawFormat) ?? .rgb
        }
        set{
            UserDefaults.standard.set(newValue.rawValue, forKey: Key.colorFormat)
        }
    }
    
    var fontSize: Int {
        get{
            return UserDefaults.standard.integer(forKey: Key.fontSize)
        }
        set{
            UserDefaults.standard.set(newValue, forKey: Key.fontSize)
        }
    }
    
    var fontStyle: PLFontStyle {
        get{
            let rawStyle = UserDefaults.standard.integer(forKey: Key.fontStyle)
            return PLFontStyle(rawValue: rawStyle) ?? .regular
        }
        set{
            UserDefaults.standard.set(newValue.rawValue, forKey: Key.fontStyle)
        }
    }
}
