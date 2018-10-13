//
//  ViewController.swift
//  Color Contrast
//
//  Created by Paolo on 12/06/2018.
//  Copyright © 2018 Paolo. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet private var leftContainerView: PLColorFormatContainerView!
    @IBOutlet private var rightContainerView: PLColorFormatContainerView!
    @IBOutlet private var colorFormatPicker: NSPopUpButton!
    @IBOutlet private var colorRatioGridView: PLRatioGridView!
    @IBOutlet private var wcgaGridView: PLWCAGGridView!
    @IBOutlet private var bottomTextAreaView: PLTextAreaView!
    
    let appUserDefaults = AppUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorRatioGridView.delegate = self
        setupColorContainers()
        refreshContrastRatio()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ViewController.textColorViewDidChangeNotification(notification:)),
                                               name: .didChangeTextColor,
                                               object: nil)
    }
    
    func setupColorContainers(){
        
        let colorFormat = appUserDefaults.colorFormat
        
        colorFormatPicker.selectItem(at: colorFormat.rawValue)
        
        leftContainerView.setupColorFormatView(colorFormat: colorFormat,
                                             colorType: .text,
                                             color: colorRatioGridView.textColor)
        rightContainerView.setupColorFormatView(colorFormat: colorFormat,
                                              colorType: .background,
                                              color: colorRatioGridView.backgroundColor)
    }
    
    @IBAction func colorFormatDidChange(sender:NSPopUpButton){
        
        guard let selectedColorFormat = PLColorFormat(rawValue: sender.indexOfSelectedItem) else { return }
        if appUserDefaults.colorFormat == selectedColorFormat { return }
        appUserDefaults.colorFormat = selectedColorFormat
        setupColorContainers()
    }
    
    private func refreshContrastRatio(){
        
        guard let textColor = colorRatioGridView.textColor,
            let backgroundColor = colorRatioGridView.backgroundColor else {
                return
        }
        
        bottomTextAreaView.updateColors(textColor: textColor,
                                        backgroundColor: backgroundColor)
        
        let contrastRatio = calculateContrastRatio(firstColor: textColor,
                                                   secondColor: backgroundColor)
        
        colorRatioGridView.updateContrastRatio(contrastRatio: contrastRatio)
        wcgaGridView.updateContrastRatio(contrastRatio: contrastRatio)
    }
}

// Mark: RatioGridView Delegate
extension ViewController: PLRatioGridViewDelegate{
    
    func ratioViewDidChangeValue(color: NSColor?, colorType: PLColorType?){
        
        guard let colorType = colorType else { return }
        let formatView:PLColorFormatView?;
        
        switch colorType {
        case .text:
            formatView = leftContainerView.colorFormatView
        case .background:
            formatView = rightContainerView.colorFormatView
        }
        
        formatView?.updateColor(color: color)
        refreshContrastRatio()
    }
}

// Mark: Notifications
extension ViewController {
    
    @objc func textColorViewDidChangeNotification(notification:Notification){
        
        guard let notificationObject = notification.object as? ColorFormatObject else { return }
        guard let colorType = notificationObject.type else { return }
        
        switch colorType {
        case .text:
            colorRatioGridView.textColor = notificationObject.color
        case .background:
            colorRatioGridView.backgroundColor = notificationObject.color
        }
        
        refreshContrastRatio()
    }
}

// Mark: Luminance
extension ViewController{
    
    private func calculateContrastRatio(firstColor:NSColor, secondColor:NSColor) -> CGFloat {
        let luminanceFirstColor = getRelativeLuminance(color: firstColor)
        let luminanceSecondColor = getRelativeLuminance(color: secondColor)
        return luminanceFirstColor > luminanceSecondColor ? (luminanceFirstColor + 0.05) / (luminanceSecondColor + 0.05) : (luminanceSecondColor + 0.05) / (luminanceFirstColor + 0.05)
    }
    
    private func getRelativeLuminance(color:NSColor) -> CGFloat{
        let (redColor,greenColor,blueColor,_) = color.getRGBFromColor()
        let luminanceRed = (redColor <= 0.03928) ? redColor/12.92 : pow(((redColor+0.055)/1.055), 2.4)
        let luminanceGreen = (greenColor <= 0.03928) ? greenColor/12.92 : pow(((greenColor+0.055)/1.055), 2.4)
        let luminanceBlue = (blueColor <= 0.03928) ? blueColor/12.92 : pow(((blueColor+0.055)/1.055), 2.4)
        let luminance = (0.2126 * luminanceRed + 0.7152 * luminanceGreen + 0.0722 * luminanceBlue)
        return luminance
    }
}
