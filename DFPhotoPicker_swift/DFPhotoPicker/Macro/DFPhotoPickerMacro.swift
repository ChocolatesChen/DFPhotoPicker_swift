//
//  DFPhotoPickerMacro.swift
//  DFPhotoPicker_swift
//
//  Created by cg on 2018/12/13.
//  Copyright © 2018 df. All rights reserved.
//

import Foundation
import UIKit

//自定义调试阶段log
func NSLog(filePath: String = #file, rowCount: Int = #line) {
    #if DEBUG
    let fileName = (filePath as NSString).lastPathComponent.replacingOccurrences(of: ".Swift", with: "")
    print("\n-----NsLog日志-----\n" + fileName + "/" + "\(rowCount)" + "\n------------------\n")
    #endif
}

func NSLog<T>(_ message: T, filePath: String = #file, rowCount: Int = #line) {
    #if DEBUG
    let fileName = (filePath as NSString).lastPathComponent.replacingOccurrences(of: ".Swift", with: "")
    print("\n-----NsLog日志-----\n" + fileName + "/" + "\(rowCount)" + "\n\(message)" + "\n------------------\n")
    #endif
}

func setSafeString(_ value:Any?) -> String{
    return value as? String ?? ""
}

func setSafeInt(_ value:Any?) -> Int {
    return value as? Int ?? 0
}

func setSafeInt64(_ value:Any?) -> Int64 {
    return value as? Int64 ?? Int64(0)
}

func setSafeDouble(_ value:Any?) -> Double {
    return value as? Double ?? 0.0
}

func setSafeBool(_ value:Any?) -> Bool {
    return value as? Bool ?? false
}


//frame
let kScreenHeight           = UIScreen.main.bounds.size.height
let kScreenWidth            = UIScreen.main.bounds.size.width
let kScreenBounds           = UIScreen.main.bounds

let DFEncodeKey = "DFModelArray"

let DFShowLog = true


let DF_UI_IS_IPAD = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad)

let DF_IS_IPHONE4 =  (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 640, height: 960).equalTo((UIScreen.main.currentMode?.size)!) : false)

let DF_IS_IPHONE5 =  (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 640, height: 1136).equalTo((UIScreen.main.currentMode?.size)!) : false)

let DF_IS_IPHONE6 =  (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 750, height: 1334).equalTo((UIScreen.main.currentMode?.size)!) : false)

let DF_IS_IPHONE6_PLUS =  (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1242, height: 2208).equalTo((UIScreen.main.currentMode?.size)!) : false)


let DF_IS_IPHONE6_PLUS_SCALE =  (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1125, height: 2001).equalTo((UIScreen.main.currentMode?.size)!) : false)

let DF_IS_IPHONE_X =  (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1125, height: 2436).equalTo((UIScreen.main.currentMode?.size)!) : false)

//设备
let kDevice_iPhone4          = (kScreenHeight == 480.0)
let kDevice_iPhone5_SE       = (kScreenHeight == 568.0)
let kDevice_iPhone6_7_8      = (kScreenHeight == 667.0)
let kDevice_iPhone6_7_8_Plus = (kScreenHeight == 736.0)
let kDevice_iPhoneX_Xs       = (kScreenHeight == 812.0)
let kDevice_iPhoneXR_Max     = (kScreenHeight == 896.0)
let kDevice_iPhoneX_Series   = kDevice_iPhoneX_Xs || kDevice_iPhoneXR_Max


//设备 系统高度
let kSystemNavigationBarHeight:CGFloat  = (kDevice_iPhoneX_Series ? 88 : 64)
let kSystemTopMargin:CGFloat            = (kDevice_iPhoneX_Series ? 44 : 0)
let kSystemBottomMargin:CGFloat         = (kDevice_iPhoneX_Series ? 34 : 0)

//系统版本
let kSystemVersion = UIDevice.current.systemVersion


let iOS11_Later = (Double(kSystemVersion) ?? 0 >= 11.0)
let iOS9Later   = (Double(kSystemVersion) ?? 0 >= 9.1)
let iOS9_Later  = (Double(kSystemVersion) ?? 0 >= 9.0)
let iOS8_2Later = (Double(kSystemVersion) ?? 0 >= 8.2)

