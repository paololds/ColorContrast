//
//  PLWCAGGridView.swift
//  Color Contrast
//
//  Created by Paolo on 15/06/2018.
//  Copyright © 2018 Paolo. All rights reserved.
//

import Cocoa

class PLWCAGGridView: NSGridView {
    
    @IBOutlet weak private var wcagAANormalTextField:NSTextField?
    @IBOutlet weak private var wcagAAANormalTextField:NSTextField?
    @IBOutlet weak private var wcagAALargeTextField:NSTextField?
    @IBOutlet weak private var wcagAAALargeTextField:NSTextField?
    
    func setNewRatioValue(value: CGFloat){
        
        let okValue = "Ok"
        let failValue = "Fail"
        
        if value >= 7 {
            wcagAANormalTextField?.stringValue = okValue
            wcagAAANormalTextField?.stringValue = okValue
            wcagAALargeTextField?.stringValue = okValue
            wcagAAALargeTextField?.stringValue = okValue
        }else if value >= 4.5{
            wcagAANormalTextField?.stringValue = okValue
            wcagAAANormalTextField?.stringValue = failValue
            wcagAALargeTextField?.stringValue = okValue
            wcagAAALargeTextField?.stringValue = okValue
        }else if value >= 3{
            wcagAANormalTextField?.stringValue = failValue
            wcagAAANormalTextField?.stringValue = failValue
            wcagAALargeTextField?.stringValue = okValue
            wcagAAALargeTextField?.stringValue = failValue
        }else{
            wcagAANormalTextField?.stringValue = failValue
            wcagAAANormalTextField?.stringValue = failValue
            wcagAALargeTextField?.stringValue = failValue
            wcagAAALargeTextField?.stringValue = failValue
        }
    }
}
