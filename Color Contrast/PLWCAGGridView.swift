//
//  PLWCAGGridView.swift
//  Color Contrast
//
//  Created by Paolo on 15/06/2018.
//  Copyright © 2018 Paolo. All rights reserved.
//

import Cocoa

enum WCAGValue : CGFloat {
    case AALarge = 3.0
    case AANormal_AAALarge = 4.5
    case AAANormal = 7.0
}

enum WCAGResult : String {
    case ok = "Ok"
    case fail  = "Fail"
}

class PLWCAGGridView: NSGridView {
    
    @IBOutlet private var wcagAANormalTextField:NSTextField!
    @IBOutlet private var wcagAAANormalTextField:NSTextField!
    @IBOutlet private var wcagAALargeTextField:NSTextField!
    @IBOutlet private var wcagAAALargeTextField:NSTextField!
    
    func updateContrastRatio(contrastRatio: CGFloat){
        wcagAAANormalTextField.stringValue = (contrastRatio >= WCAGValue.AAANormal.rawValue) ? WCAGResult.ok.rawValue : WCAGResult.fail.rawValue
        wcagAANormalTextField.stringValue = (contrastRatio >= WCAGValue.AANormal_AAALarge.rawValue) ? WCAGResult.ok.rawValue : WCAGResult.fail.rawValue
        wcagAAALargeTextField.stringValue = (contrastRatio >= WCAGValue.AANormal_AAALarge.rawValue) ? WCAGResult.ok.rawValue : WCAGResult.fail.rawValue
        wcagAALargeTextField.stringValue = (contrastRatio >= WCAGValue.AALarge.rawValue) ? WCAGResult.ok.rawValue : WCAGResult.fail.rawValue
    }
}
