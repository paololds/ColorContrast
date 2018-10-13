//
//  NSColor+Conversion.swift
//  Color Contrast
//
//  Created by Paolo on 15/06/2018.
//  Copyright © 2018 Paolo. All rights reserved.
//

import Cocoa

extension NSColor {
    
    typealias RGBColor = (red:CGFloat,green:CGFloat,blue:CGFloat,alpha:CGFloat)
    
    convenience init(hexString:String) {
        
        let hexString =  String(hexString.dropFirst())
        var rgbValue:UInt32 = 0

        Scanner(string: hexString).scanHexInt32(&rgbValue)
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: 1.0)
    }
    
    var hexValue:String{
        
        let (red,green,blue,_) = self.getRGBFromColor()
        let redHex = Int(red*255)<<16
        let greenHex = Int(green*255)<<8
        let blueHex = Int(blue*255)<<0
        
        return String.localizedStringWithFormat("#%06x", (redHex | greenHex | blueHex))
    }
    
    func getRGBFromColor() -> RGBColor{
        
        var redColor : CGFloat = 0.0
        var greenColor : CGFloat = 0.0
        var blueColor : CGFloat = 0.0
        var alphaColor : CGFloat = 1.0
        
        self.getRed(&redColor,
                    green: &greenColor,
                    blue: &blueColor,
                    alpha: &alphaColor)
        
        return (redColor,greenColor,blueColor,alphaColor)
    }
}
