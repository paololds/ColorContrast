//
//  PLHEXColorView.swift
//  Color Contrast
//
//  Created by Paolo on 13/06/2018.
//  Copyright © 2018 Paolo. All rights reserved.
//

import Cocoa

class PLHEXColorView: PLColorView {
    
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
        gridView.yPlacement = .fill
        self.addSubview(gridView)
        gridView.translatesAutoresizingMaskIntoConstraints = false
        
        gridView.leadingAnchor.constraint(equalTo: self.leadingAnchor ).isActive = true
        gridView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        gridView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        gridView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        let hexLabel = NSTextField(labelWithString: "Hex")
        gridView.addColumn(with: [hexLabel])
        
        let textField = NSTextField(string: "")
        textField.placeholderString = "#ffffff"

        gridView.addColumn(with: [textField])
        
        gridView.cell(atColumnIndex: 0, rowIndex: 0).yPlacement = .center

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(hexColorDidChange(notif:)),
                                               name: NSControl.textDidChangeNotification,
                                               object: nil)
    }
    
    @objc private func hexColorDidChange(notif:Notification) {
        guard let textField = notif.object as? NSTextField, self.subviews.contains(textField)  else {return}
        var stringColor = textField.stringValue
        if !stringColor.hasPrefix("#"){
            stringColor.insert("#", at: stringColor.startIndex)
        }
        let expression = "^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$"
        let result = matchFormat(colorString: stringColor,
                                 regex: expression)
        if result {
            let color = NSColor(hexString: stringColor)
            delegate?.colorViewDidChangeValue(color: color,type: self.type)
        }
    }
    
    override func updateColor(color: NSColor?) {
        guard let hexValue = color?.hexValue else { return }
        guard let textField = self.subviews.first as? NSTextField else {return}
        textField.stringValue = hexValue
    }
}
