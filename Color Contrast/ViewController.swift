//
//  ViewController.swift
//  Color Contrast
//
//  Created by Paolo on 12/06/2018.
//  Copyright © 2018 Paolo. All rights reserved.
//

import Cocoa

enum PLFontStyle: Int{
    case regular
    case bold
}

class ViewController: NSViewController, PLColorViewDelegate, PLTextAreaDelegate, PLRatioGridViewDelegate {
    
    @IBOutlet weak var textFormatContainerView: NSView?
    @IBOutlet weak var backgroundFormatContainerView: NSView?
    @IBOutlet weak var colorFormatPicker: NSPopUpButton?
    @IBOutlet weak var ratioGridView: PLRatioGridView?
    @IBOutlet weak var WCGAGridView: PLWCAGGridView?
    @IBOutlet weak var textAreaView: PLTextAreaView?
    
    var currentColorFormat:PLColorFormat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerDefaults()
        textAreaView?.delegate = self
        ratioGridView?.delegate = self
        
        let tColor = UserDefaults.standard.string(forKey:UserDefaults.key.colorTextHex.rawValue) ?? "#000000"
        let bColor = UserDefaults.standard.string(forKey:UserDefaults.key.colorBackgroundHex.rawValue) ?? "#ffffff"
        ratioGridView?.textColor = NSColor(hexString: tColor)
        ratioGridView?.backgroundColor = NSColor(hexString: bColor)
        
        let colorConfiguraton = UserDefaults.standard.integer(forKey: UserDefaults.key.colorFormat.rawValue)
        let colorFormat = PLColorFormat(rawValue: colorConfiguraton) ?? .rgb
        loadColorConfiguration(colorFormat: colorFormat)
        refreshContrastRatio()
    }
    
    override func viewDidDisappear() {
        saveDefaults()
    }
    
    //MARK: Color Configuration
    
    private func loadColorConfiguration(colorFormat:PLColorFormat){
        
        if currentColorFormat?.rawValue == colorFormat.rawValue {return}
        currentColorFormat = colorFormat
        colorFormatPicker?.selectItem(at: colorFormat.rawValue)
        
        var textColorView:PLColorView
        var backgroundColorView:PLColorView
        switch colorFormat{
        case .rgb:
            textColorView = PLRGBColorView()
            backgroundColorView = PLRGBColorView()
            break
        case .hex:
            textColorView = PLHEXColorView()
            backgroundColorView = PLHEXColorView()
            break
        }
        
        textColorView.type = .text
        backgroundColorView.type = .background
        
        guard let textContainer = textFormatContainerView else { return }
        guard let backgroundContainer = backgroundFormatContainerView else { return }
        addColorView(colorView: textColorView, container: textContainer)
        addColorView(colorView: backgroundColorView, container: backgroundContainer)
        
        guard let textColor = ratioGridView?.textColor else { return }
        guard let bgColor = ratioGridView?.backgroundColor else { return }
        textColorView.updateColor(color: textColor)
        backgroundColorView.updateColor(color: bgColor)
    }
    
    private func addColorView(colorView:PLColorView, container:NSView){
        container.subviews.removeAll()
        container.addSubview(colorView)
        colorView.delegate = self
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        colorView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        colorView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        colorView.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
    }
    
    @IBAction func colorFormatDidChange(sender:NSPopUpButton){
        guard let colorFormat = PLColorFormat(rawValue: sender.indexOfSelectedItem) else{ return }
        UserDefaults.standard.set(colorFormat.rawValue,
                                  forKey: UserDefaults.key.colorFormat.rawValue)
        loadColorConfiguration(colorFormat: colorFormat)
    }
    
    //MARK: Ratio View
    
    func ratioViewDidChangeValue(color: NSColor?, type: PLColorType?){
        
        guard let type = type else { return }
        var colorFormatView:PLColorView?;
        
        switch type {
        case .text:
            colorFormatView = textFormatContainerView?.subviews.first as? PLColorView
            break
        case .background:
            colorFormatView = backgroundFormatContainerView?.subviews.first as? PLColorView
            break
        }
        
        colorFormatView?.updateColor(color: color)
        refreshContrastRatio()
    }
    
    //MARK: Color View
    
    private func refreshContrastRatio(){
        textAreaView?.updateTextArea()
        ratioGridView?.updateColorContrastRatio()
        guard let ratio = ratioGridView?.contrastRatio else { return }
        WCGAGridView?.setNewRatioValue(value: ratio)
    }
    
    func colorViewDidChangeValue(color: NSColor?, type: PLColorType?) {
        
        guard let type = type else { return }
        guard let color = color else { return }
        
        switch type {
        case .text:
            ratioGridView?.textColor = color
            break
        case .background:
            ratioGridView?.backgroundColor = color
            break
        }
        
        refreshContrastRatio()
    }
    
    //MARK: Text Area View
    
    func textAreaNewTextAndBackgroundColor() -> (NSColor, NSColor)? {
        guard let textColor = ratioGridView?.textColor else {return nil}
        guard let backgroundColor = ratioGridView?.backgroundColor else {return nil}
        return (textColor,backgroundColor)
    }
    
    //MARK: User Defaults
    
    private func registerDefaults(){
        UserDefaults.standard.register(defaults:
            [UserDefaults.key.colorFormat.rawValue : PLColorFormat.rgb.rawValue,
             UserDefaults.key.fontSize.rawValue : 15,
             UserDefaults.key.fontStyle.rawValue : PLFontStyle.regular.rawValue,
             UserDefaults.key.colorTextHex.rawValue : "#000000",
             UserDefaults.key.colorBackgroundHex.rawValue : "#ffffff"
            ])
    }
    
    private func saveDefaults(){
        guard let fontSize = textAreaView?.fontSizeStepper?.integerValue else{ return }
        UserDefaults.standard.set(fontSize,
                                  forKey: UserDefaults.key.fontSize.rawValue)
        guard let selectedStyle = textAreaView?.fontStylePicker?.indexOfSelectedItem else { return }
        UserDefaults.standard.set(selectedStyle,
                                  forKey: UserDefaults.key.fontStyle.rawValue)
        guard let textColor = ratioGridView?.textColor,
            let backgroundColor = ratioGridView?.backgroundColor else { return }
        
        let textHex = textColor.hexValue
        let backgroundHex = backgroundColor.hexValue
        
        UserDefaults.standard.setValue(textHex,
                                       forKey: UserDefaults.key.colorTextHex.rawValue)
        UserDefaults.standard.setValue(backgroundHex,
                                       forKey: UserDefaults.key.colorBackgroundHex.rawValue)
    }
}
