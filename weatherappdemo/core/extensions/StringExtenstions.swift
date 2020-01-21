//
//  StringExtenstions.swift
//  weatherappdemo
//
//  Created by Sachin Rao on 20/01/20.
//

import Foundation
import UIKit
extension String{
    func replacingLastOccurrenceOfString(_ string: String,
                                         with replacementString: String,
                                         caseInsensitive: Bool = true) -> String{
        let options: String.CompareOptions
        if caseInsensitive {
            options = [.backwards, .caseInsensitive]
        } else {
            options = [.backwards]
        }
        if let range = self.range(of: string,
                                  options: options,
                                  range: nil,
                                  locale: nil) {
            return self.replacingCharacters(in: range, with: replacementString)
        }
        return self
    }
    
    
    /// Converts 6 length string to color, will remove # if present
    func convertToColor()->UIColor{
        var cString:String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
