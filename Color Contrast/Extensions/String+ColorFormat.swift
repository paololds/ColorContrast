//
//  String+ColorFormat.swift
//  Color Contrast
//
//  Created by Paolo Ladisa on 09/10/2018.
//  Copyright © 2018 Paolo. All rights reserved.
//

import Foundation

extension String{
    
    func isMatchingFormat(regex:String?) -> Bool{
        
        guard self.count > 0 else {return false}
        guard let regex = regex, regex.count > 0 else {return false}
        let  result = self.range(of: regex,
                                 options: String.CompareOptions.regularExpression,
                                 range: nil,
                                 locale: nil)
        return result != nil
    }
}
