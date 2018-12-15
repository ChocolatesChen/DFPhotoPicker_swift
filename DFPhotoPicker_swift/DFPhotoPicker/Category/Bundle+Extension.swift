//
//  Bundle+Extension.swift
//  DFPhotoPicker_swift
//
//  Created by cg on 2018/12/14.
//  Copyright © 2018 df. All rights reserved.
//

import Foundation

extension Bundle {
    
    class func df_photopickerBundle() -> Bundle {
        var dfBundle: Bundle? = nil
        if dfBundle == nil {
            var path = Bundle.main.path(forResource: "DFPhotoPicker", ofType: "bundle")
            if path == nil {
                path = Bundle.main.path(forResource: "DFPhotoPicker", ofType: "bundle", inDirectory: "Frameworks/DFPhotoPicker.framework/")
            }
            dfBundle = Bundle(path: path ?? "")
        }
        return dfBundle!
    }

    class func df_localizedString(forKey key: String?) -> String? {
        return self.df_localizedString(forKey: key, value: nil)
    }
    
    class func df_localizedString(forKey key: String?, value: String?) -> String? {
        var bundle: Bundle? = nil
        var value = value
        if bundle == nil {
            var language = NSLocale.preferredLanguages.first
            if language?.hasPrefix("en") ?? false {
                language = "en"
            } else if language?.hasPrefix("zh") ?? false {
                if Int((language as NSString?)?.range(of: "Hans").location ?? 0) != NSNotFound {
                    language = "zh-Hans" // 简体中文
                }
            } else {
                language = "en"
            }
            
            bundle = Bundle(path: Bundle.df_photopickerBundle().path(forResource: language, ofType: "lproj") ?? "")
        }
        value = bundle?.localizedString(forKey: key ?? "", value: value, table: nil)
        return Bundle.main.localizedString(forKey: key ?? "", value: value, table: nil)
    }

}
