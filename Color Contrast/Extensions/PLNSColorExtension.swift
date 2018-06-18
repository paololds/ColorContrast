//
//  PLNSColorExtension.swift
//  Color Contrast
//
//  Created by Paolo on 15/06/2018.
//  Copyright © 2018 Paolo. All rights reserved.
//

import Cocoa

extension NSColor {
    
    convenience init(hexString:String) {
        let hexString =  String(hexString.dropFirst())
        var rgbValue:UInt32 = 0
        Scanner(string: hexString).scanHexInt32(&rgbValue)
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: 1.0)
    }
    
    var hexValue:String {
        let (red,green,blue) = self.getRGBFromColor()
        let redHex = Int(red*255)<<16
        let greenHex = Int(green*255)<<8
        let blueHex = Int(blue*255)<<0
        return String.localizedStringWithFormat("#%06x", (redHex | greenHex | blueHex))
    }
    
    func getRGBFromColor() -> (CGFloat,CGFloat,CGFloat){
        var r:CGFloat = 0.0, g:CGFloat = 0.0, b:CGFloat = 0.0
        self.getRed(&r,
                    green: &g,
                    blue: &b,
                    alpha: nil)
        return (r,g,b)
    }
}
