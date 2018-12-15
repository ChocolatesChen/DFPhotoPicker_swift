//
//  DFColorMacro.swift
//  DFPhotoPicker_swift
//
//  Created by cg on 2018/12/14.
//  Copyright © 2018 df. All rights reserved.
//

import Foundation
import UIKit

//主题色
let kColorThemeColor        = colorWithHexString("#ed8649")





func RGBA (red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat)->UIColor {
    return UIColor (red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
}

//十六进制色
func colorWithHexString(_ hexString:String)->UIColor {
    
    var cString = hexString.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines).uppercased()
    if (cString.hasPrefix("#")) {
        let index = cString.index(cString.startIndex, offsetBy:1)
        cString = String(cString[index...])
    }
    if (cString.count != 6) {
        return UIColor.red
    }
    let rIndex = cString.index(cString.startIndex, offsetBy: 2)
    let rString = String(cString[..<rIndex])
    let otherString = String(cString[rIndex...])
    let gIndex = otherString.index(otherString.startIndex, offsetBy: 2)
    let gString = String(otherString[..<gIndex])
    let bIndex = cString.index(cString.endIndex, offsetBy: -2)
    let bString = String(cString[bIndex...])
    
    var red:CUnsignedInt = 0, green:CUnsignedInt = 0, blue:CUnsignedInt = 0;
    Scanner(string: rString).scanHexInt32(&red)
    Scanner(string: gString).scanHexInt32(&green)
    Scanner(string: bString).scanHexInt32(&blue)
    return RGBA(red:CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
}
