//
//  PLColorFormatView.swift
//  Color Contrast
//
//  Created by Paolo on 12/06/2018.
//  Copyright © 2018 Paolo. All rights reserved.
//

import Cocoa

enum PLColorType : Int {
    case text
    case background
}

typealias ColorFormatObject = (color:NSColor?,type:PLColorType?)

class PLColorFormatView:NSView {
    
    var type:PLColorType?
    
    func setupView(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(PLColorFormatView.colorDidChange(notification:)),
                                               name: NSControl.textDidChangeNotification,
                                               object: nil)
    }
    
    @objc func colorDidChange(notification:Notification){}
    
    func updateColor(color:NSColor?){}
    
}
