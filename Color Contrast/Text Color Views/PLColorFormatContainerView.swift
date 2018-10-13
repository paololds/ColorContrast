//
//  PLColorFormatContainerView.swift
//  Color Contrast
//
//  Created by Paolo Ladisa on 13/10/2018.
//  Copyright © 2018 Paolo. All rights reserved.
//

import Cocoa

class PLColorFormatContainerView : NSView {
    
    var colorFormatView:PLColorFormatView?{
        return self.subviews.first as? PLColorFormatView
    }
    
    func setupColorFormatView(colorFormat format:PLColorFormat, colorType type:PLColorType,color:NSColor?){
        
        removeCurrentColorFormatView()
        
        var formatView : PLColorFormatView
        switch format {
        case .rgb:
            formatView = PLRGBColorFormatView()
        case .hex:
            formatView = PLHEXColorFormatView()
        }
        
        formatView.type = type
        self.addSubview(formatView)
        formatView.translatesAutoresizingMaskIntoConstraints = false
        formatView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        formatView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        formatView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        formatView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        formatView.updateColor(color: color)
    }
    
    func updateColor(_ color:NSColor?){
        colorFormatView?.updateColor(color: color)
    }
    
    private func removeCurrentColorFormatView(){
        self.subviews.removeAll()
    }
}
