//
//  DFPhotoTools.swift
//  DFPhotoPicker_swift
//
//  Created by cg on 2018/12/14.
//  Copyright © 2018 df. All rights reserved.
//

import UIKit

@objc class DFPhotoTools: NSObject {

    @objc class func df_imageNamed(_ imageName: String?) -> UIImage? {
        var image = UIImage(named: imageName ?? "")
        if image != nil {
            return image
        }
        let path = "DFPhotoPicker.bundle/\(imageName ?? "")"
        image = UIImage(named: path)
        if image != nil {
            return image
        } else {
            let path = "Frameworks/DFPhotoPicker.framework/DFPhotoPicker.bundle/\(imageName ?? "")"
            image = UIImage(named: path)
            if image == nil {
                image = UIImage(named: imageName ?? "")
            }
            return image
        }
    }
    
}
