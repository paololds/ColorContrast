//
//  PLRGBColorView.swift
//  Color Contrast
//
//  Created by Paolo on 13/06/2018.
//  Copyright © 2018 Paolo. All rights reserved.
//

import Cocoa

class PLRGBColorView: PLColorView {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.commonInit()
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.commonInit()
    }
    
    private func commonInit(){
        let gridView = NSGridView()
        gridView.xPlacement = .fill
        gridView.yPlacement = .center
        self.addSubview(gridView)
        gridView.translatesAutoresizingMaskIntoConstraints = false
        
        gridView.leadingAnchor.constraint(equalTo: self.leadingAnchor ).isActive = true
        gridView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        gridView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        gridView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        let redLabel = NSTextField(labelWithString: "Red")
        let greenLabel = NSTextField(labelWithString: "Green")
        let blueLabel = NSTextField(labelWithString: "Blue")
        
        gridView.addColumn(with: [redLabel,greenLabel,blueLabel])
        
        let redTextField = NSTextField(string: "")
        let greenTextField = NSTextField(string: "")
        let blueTextField = NSTextField(string: "")
        
        redTextField.alignment = .right
        greenTextField.alignment = .right
        blueTextField.alignment = .right
        
        redTextField.placeholderString = "0-255"
        greenTextField.placeholderString = "0-255"
        blueTextField.placeholderString = "0-255"

        redTextField.nextKeyView = greenTextField
        greenTextField.nextKeyView = blueTextField
        blueTextField.nextKeyView = redTextField
        
        gridView.addColumn(with: [redTextField,greenTextField,blueTextField])
        
        gridView.cell(for: redTextField)?.yPlacement = .fill
        gridView.cell(for: greenTextField)?.yPlacement = .fill
        gridView.cell(for: blueTextField)?.yPlacement = .fill

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(colorDidChange(notif:)),
                                               name: NSControl.textDidChangeNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(colorDidChange(notif:)),
                                               name: NSControl.textDidChangeNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(colorDidChange(notif:)),
                                               name: NSControl.textDidChangeNotification,
                                               object: nil)
    }
    
    @objc private func colorDidChange(notif:Notification){
        
        guard let gridView = self.subviews.first as? NSGridView else{ return }
        guard let textField = notif.object as? NSTextField, gridView.subviews.contains(textField) else {return}
        
        guard let redTextField = gridView.cell(atColumnIndex: 1, rowIndex: 0).contentView as? NSTextField,
            let greenTextField = gridView.cell(atColumnIndex: 1, rowIndex: 1).contentView as? NSTextField,
            let blueTextField = gridView.cell(atColumnIndex: 1, rowIndex: 2).contentView as? NSTextField else {return}
        
        let expression = "^([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])$"
        
        let redResult = matchFormat(colorString: redTextField.stringValue,
                                    regex: expression)
        let greenResult = matchFormat(colorString: greenTextField.stringValue,
                                 regex: expression)
        let blueResult = matchFormat(colorString: blueTextField.stringValue,
                                 regex: expression)
        
        if redResult && greenResult && blueResult {
            guard let red = Float(redTextField.stringValue), let green = Float(greenTextField.stringValue), let blue = Float(blueTextField.stringValue) else {return}
            
            let color = NSColor(red: CGFloat(red/255),
                            green: CGFloat(green/255),
                            blue: CGFloat(blue/255),
                            alpha: 1.0)
            delegate?.colorViewDidChangeValue(color: color,type: self.type)
        }
    }
    
    override func updateColor(color: NSColor?) {
        guard let (red,green,blue) = color?.getRGBFromColor() else { return }
        guard let gridView = self.subviews.first as? NSGridView else{ return }
        guard let redTextField = gridView.cell(atColumnIndex: 1, rowIndex: 0).contentView as? NSTextField,
            let greenTextField = gridView.cell(atColumnIndex: 1, rowIndex: 1).contentView as? NSTextField,
            let blueTextField = gridView.cell(atColumnIndex: 1, rowIndex: 2).contentView as? NSTextField else { return }
        
        redTextField.stringValue = String(Int(red*255))
        greenTextField.stringValue = String(Int(green*255))
        blueTextField.stringValue = String(Int(blue*255))
    }
}
