//
//  PLRatioGridView.swift
//  Color Contrast
//
//  Created by Paolo on 15/06/2018.
//  Copyright © 2018 Paolo. All rights reserved.
//

import Cocoa

protocol PLRatioGridViewDelegate: AnyObject {
    func ratioViewDidChangeValue(color: NSColor?, colorType: PLColorType?)
}

class PLRatioGridView: NSGridView {
    
    @IBOutlet private var rightColorArea: NSButton!
    @IBOutlet private var leftColorArea: NSButton!
    @IBOutlet private var coloRatioLabel: NSTextField!
    
    weak var delegate:PLRatioGridViewDelegate?
    
    var textColor: NSColor? {
        get{
            guard let cgColor = leftColorArea.layer?.backgroundColor else { return nil }
            return NSColor(cgColor: cgColor)
        }
        set{
            leftColorArea.layer?.backgroundColor = newValue?.cgColor
        }
    }
    
    var backgroundColor: NSColor? {
        get{
            guard let cgColor = rightColorArea.layer?.backgroundColor else { return nil }
            return NSColor(cgColor: cgColor)
        }
        set{
            rightColorArea.layer?.backgroundColor = newValue?.cgColor
        }
    }
    
    
    override func awakeFromNib(){
        super.awakeFromNib()
        leftColorArea.wantsLayer = true
        rightColorArea.wantsLayer = true
        leftColorArea.layer?.borderWidth = 1.0
        rightColorArea.layer?.borderWidth = 1.0
        textColor = NSColor(hexString: "#000000")
        backgroundColor = NSColor(hexString: "#ffffff")
    }
    
    func updateContrastRatio(contrastRatio:CGFloat){
        coloRatioLabel.stringValue = String(format: "%.2f:1", contrastRatio)
    }
    
    @IBAction func textColorDidPressed(sender:NSButton?){
        presentColorPanel(sender: sender)
    }
    
    @IBAction func backgroundColorDidPressed(sender:NSButton?){
        presentColorPanel(sender: sender)
    }
}


// MARK: Color Panel

extension PLRatioGridView {
    
    private func presentColorPanel(sender: NSButton?){
        
        let colorPanel = NSColorPanel.shared
        colorPanel.setTarget(self)
        colorPanel.orderFront(self)
        
        if sender === leftColorArea {
            colorPanel.setAction(#selector(textColorPanelDidChangeColor(sender:)))
        }else {
            colorPanel.setAction(#selector(backgroundColorPanelDidChangeColor(sender:)))
        }
        
        guard let layerColor = sender?.layer?.backgroundColor else { return }
        guard let currentColor = NSColor(cgColor: layerColor) else { return }
        colorPanel.color = currentColor
    }
    
    @objc private func textColorPanelDidChangeColor(sender:NSColorPanel){
        let color = sender.color;
        leftColorArea.layer?.backgroundColor = color.cgColor
        delegate?.ratioViewDidChangeValue(color: color, colorType: .text)
    }
    
    @objc private func backgroundColorPanelDidChangeColor(sender:NSColorPanel){
        let color = sender.color;
        rightColorArea.layer?.backgroundColor = color.cgColor
        delegate?.ratioViewDidChangeValue(color: color, colorType: .background)
    }
}
