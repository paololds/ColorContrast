//
//  PLHEXColorFormatView.swift
//  Color Contrast
//
//  Created by Paolo on 13/06/2018.
//  Copyright © 2018 Paolo. All rights reserved.
//

import Cocoa

class PLHEXColorFormatView: PLColorFormatView {

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setupView()
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.setupView()
    }

    override func setupView() {
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
        
        super.setupView()
    }
    
    override func colorDidChange(notification:Notification){
        guard let gridView = self.subviews.first as? NSGridView else{ return }
        guard let hexTextField = notification.object as? NSTextField, gridView.subviews.contains(hexTextField) else {return}
        
        var stringColor = hexTextField.stringValue
        if !stringColor.hasPrefix("#"){
            stringColor.insert("#", at: stringColor.startIndex)
        }
        let expression = "^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$"
        let result = stringColor.isMatchingFormat(regex: expression)
        if result {
            let color = NSColor(hexString: stringColor)
            let notificationObject = ColorFormatObject(color,type)
            NotificationCenter.default.post(name: .didChangeTextColor, object: notificationObject)
        }
    }
    
    override func updateColor(color: NSColor?) {
        guard let hexValue = color?.hexValue else { return }
        guard let gridView = self.subviews.first as? NSGridView else{ return }
        guard let hexTextField = gridView.cell(atColumnIndex: 1, rowIndex: 0).contentView as? NSTextField else {return}
        hexTextField.stringValue = hexValue
    }
}
