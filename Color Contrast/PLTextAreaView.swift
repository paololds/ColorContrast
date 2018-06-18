//
//  PLTextAreaView.swift
//  Color Contrast
//
//  Created by Paolo on 15/06/2018.
//  Copyright © 2018 Paolo. All rights reserved.
//

import Cocoa

protocol PLTextAreaDelegate:AnyObject {
    func textAreaNewTextAndBackgroundColor() -> (NSColor,NSColor)?
}

class PLTextAreaView: NSView {
    @IBOutlet weak var textArea: NSTextView?
    @IBOutlet weak private var fontSizeLabel:NSTextField?
    @IBOutlet weak var fontSizeStepper:NSStepper?
    @IBOutlet weak var fontStylePicker: NSPopUpButton?
    weak var delegate:PLTextAreaDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        let stepperValue = UserDefaults.standard.integer(forKey: PLUserDefaultsKey.fontSize)
        fontSizeStepper?.integerValue = stepperValue
        fontSizeLabel?.stringValue = String(stepperValue)
        let fontStyleValue = UserDefaults.standard.integer(forKey: PLUserDefaultsKey.fontStyle)
        fontStylePicker?.selectItem(at: fontStyleValue)
    }
    
    @IBAction func fontStyleDidChange(sender:NSPopUpButton){
        updateTextArea()
    }
    
    @IBAction func fontSizeDidChange(sender:NSStepper){
        let stepperValue = sender.integerValue
        fontSizeLabel?.stringValue = String(stepperValue)
        updateTextArea()
    }
    
    func updateTextArea(){
        guard let fontSize = fontSizeStepper?.integerValue else { return }
        guard let selectedStyle = fontStylePicker?.indexOfSelectedItem else { return }
        let fontStyle = PLFontStyle(rawValue: selectedStyle) ?? .regular
        var fontWeight:NSFont.Weight
        
        switch fontStyle {
        case .regular:
            fontWeight = .regular
            break
        case .bold:
            fontWeight = .bold
            break
        }
        
        let font = NSFont.systemFont(ofSize: CGFloat(fontSize),
                                     weight: fontWeight)
        textArea?.font = font
        
        guard let (textColor, backgroundColor) = delegate?.textAreaNewTextAndBackgroundColor() else { return }
        textArea?.textColor = textColor
        textArea?.backgroundColor = backgroundColor
    }
}
