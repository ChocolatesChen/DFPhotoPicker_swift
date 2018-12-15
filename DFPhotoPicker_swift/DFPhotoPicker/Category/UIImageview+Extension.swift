//
//  UIImageview+Extension.swift
//  DFPhotoPicker_swift
//
//  Created by cg on 2018/12/14.
//  Copyright © 2018 df. All rights reserved.
//

import Foundation
import Alamofire
import YYWebImage

extension UIImageView {
    
    func df_setImage(with model: DFPhotoModel?,
                     progress progressBlock: @escaping (_ progress: CGFloat, _ model: DFPhotoModel?) -> Void,
                     completed completedBlock: @escaping (_ image: UIImage?, _ error: Error?, _ model: DFPhotoModel?) -> Void) {
    }

    func df_setImage(with model: DFPhotoModel?,
                     original: Bool,
                     progress progressBlock: @escaping (_ progress: CGFloat, _ model: DFPhotoModel?) -> Void,
                     completed completedBlock: @escaping (_ image: UIImage?, _ error: Error?, _ model: DFPhotoModel?) -> Void) {
        if (model?.networkThumbURL != nil) {model?.networkThumbURL = model?.networkPhotoUrl}
    }

}
