//
//  PLColorView.swift
//  Color Contrast
//
//  Created by Paolo on 12/06/2018.
//  Copyright © 2018 Paolo. All rights reserved.
//

import Cocoa

enum PLColorFormat : Int{
    case rgb
    case hex
}

enum PLColorType : Int {
    case text
    case background
}

protocol PLColorViewDelegate:AnyObject {
    func colorViewDidChangeValue(color:NSColor?, type:PLColorType?)
}

class PLColorView: NSView {
    
    var type:PLColorType?
    weak var delegate:PLColorViewDelegate?
    
    func matchFormat(colorString:String?, regex:String?) -> Bool{
        guard let colorString = colorString, colorString.count > 0 else {return false}
        guard let regex = regex, regex.count > 0 else {return false}
        let  result = colorString.range(of: regex,
                                           options: String.CompareOptions.regularExpression,
                                           range: nil,
                                           locale: nil)
        return result != nil
    }
    
    func updateColor(color:NSColor?){

    }
}
