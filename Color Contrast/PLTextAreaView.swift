//
//  PLTextAreaView.swift
//  Color Contrast
//
//  Created by Paolo on 15/06/2018.
//  Copyright © 2018 Paolo. All rights reserved.
//

import Cocoa

typealias ComparableColor = (NSColor,NSColor)

class PLTextAreaView: NSView {
    
    @IBOutlet private var textArea: NSTextView!
    @IBOutlet private var fontSizeLabel:NSTextField!
    @IBOutlet private var fontSizeStepper:NSStepper!
    @IBOutlet private var fontStylePicker: NSPopUpButton!
    
    let appUserDefaults = AppUserDefaults()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let stepperValue = appUserDefaults.fontSize
        fontSizeStepper.integerValue = stepperValue
        fontSizeLabel.stringValue = String(stepperValue)
        let fontStyleValue = appUserDefaults.fontStyle
        fontStylePicker.selectItem(at: Int(fontStyleValue.rawValue))
    }
    
    @IBAction func fontStyleDidChange(sender:NSPopUpButton){
        updateText()
    }
    
    @IBAction func fontSizeDidChange(sender:NSStepper){
        let stepperValue = sender.integerValue
        fontSizeLabel.stringValue = String(stepperValue)
        updateText()
    }
    
    private func updateText(){
        let fontSize = fontSizeStepper.integerValue
        let selectedStyle = fontStylePicker.indexOfSelectedItem
        let fontStyle = PLFontStyle(rawValue: selectedStyle) ?? .regular
        let font = NSFont.systemFont(ofSize: CGFloat(fontSize),
                                     weight: (fontStyle == .regular) ? .regular : .bold)
        textArea.font = font
        appUserDefaults.fontSize = fontSize
        appUserDefaults.fontStyle = fontStyle
    }
    
    func updateColors(textColor:NSColor, backgroundColor:NSColor){
        textArea.textColor = textColor
        textArea.backgroundColor = backgroundColor
    }
}
