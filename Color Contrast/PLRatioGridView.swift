//
//  PLRatioGridView.swift
//  Color Contrast
//
//  Created by Paolo on 15/06/2018.
//  Copyright © 2018 Paolo. All rights reserved.
//

import Cocoa

protocol PLRatioGridViewDelegate: AnyObject {
    func ratioViewDidChangeValue(color: NSColor?, type: PLColorType?)
}

class PLRatioGridView: NSGridView {
    
    @IBOutlet weak private var textColorButton: NSButton?
    @IBOutlet weak private var backgroundColorButton: NSButton?
    @IBOutlet weak private var ratioLabel: NSTextField?
    
    weak var delegate:PLRatioGridViewDelegate?
    
    var contrastRatio: CGFloat = 0.0
    
    var textColor: NSColor? {
        get{
            guard let cgColor = textColorButton?.layer?.backgroundColor else { return nil }
            return NSColor(cgColor: cgColor)
        }
        set{
            textColorButton?.layer?.backgroundColor = newValue?.cgColor
        }
    }
    
    var backgroundColor: NSColor? {
        get{
            guard let cgColor = backgroundColorButton?.layer?.backgroundColor else { return nil }
            return NSColor(cgColor: cgColor)
        }
        set{
            backgroundColorButton?.layer?.backgroundColor = newValue?.cgColor
        }
    }
    
    override func awakeFromNib(){
        super.awakeFromNib()
        textColorButton?.wantsLayer = true
        backgroundColorButton?.wantsLayer = true
        textColorButton?.layer?.borderWidth = 1.0
        backgroundColorButton?.layer?.borderWidth = 1.0
    }
    
    @IBAction func textColorDidPressed(sender:NSButton?){
        presentColorPanel(sender: sender)
    }
    
    @IBAction func backgroundColorDidPressed(sender:NSButton?){
        presentColorPanel(sender: sender)
    }
    
    func presentColorPanel(sender: NSButton?){
        
        let colorPanel = NSColorPanel.shared
        colorPanel.setTarget(self)
        colorPanel.orderFront(self)
        
        if sender === textColorButton {
            colorPanel.setAction(#selector(textColorPanelDidChangeColor(sender:)))
        }else {
            colorPanel.setAction(#selector(backgroundColorPanelDidChangeColor(sender:)))
        }
        
        guard let layerColor = sender?.layer?.backgroundColor else { return }
        guard let currentColor = NSColor(cgColor: layerColor) else { return }
        colorPanel.color = currentColor
    }
    
    @objc func textColorPanelDidChangeColor(sender:NSColorPanel){
        let color = sender.color;
        textColorButton?.layer?.backgroundColor = color.cgColor
        delegate?.ratioViewDidChangeValue(color: color, type: .text)
    }
    
    @objc func backgroundColorPanelDidChangeColor(sender:NSColorPanel){
        let color = sender.color;
        backgroundColorButton?.layer?.backgroundColor = color.cgColor
        delegate?.ratioViewDidChangeValue(color: color, type: .background)
    }
    
    func updateColorContrastRatio(){
        guard let textNSColor = textColor else { return }
        guard let backgroundNSColor = backgroundColor else { return }
        contrastRatio = calculateContrastRatio(firstColor: textNSColor,
                                               secondColor: backgroundNSColor)
        ratioLabel?.stringValue = String(format: "%.2f:1", contrastRatio)
    }
    
    private func calculateContrastRatio(firstColor:NSColor, secondColor:NSColor) -> CGFloat {
        let l1 = getRelativeLuminance(color: firstColor)
        let l2 = getRelativeLuminance(color: secondColor)
        return l1 > l2 ? (l1 + 0.05) / (l2 + 0.05) : (l2 + 0.05) / (l1 + 0.05)
    }
    
    private func getRelativeLuminance(color:NSColor) -> CGFloat{
        let (r,g,b) = color.getRGBFromColor()
        let lR = (r <= 0.03928) ? r/12.92 : pow(((r+0.055)/1.055), 2.4)
        let lG = (g <= 0.03928) ? g/12.92 : pow(((g+0.055)/1.055), 2.4)
        let lB = (b <= 0.03928) ? b/12.92 : pow(((b+0.055)/1.055), 2.4)
        let  l = (0.2126 * lR + 0.7152 * lG + 0.0722 * lB)
        return l
    }
    
}
