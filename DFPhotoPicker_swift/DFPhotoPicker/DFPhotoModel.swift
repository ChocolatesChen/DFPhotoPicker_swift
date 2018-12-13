//
//  DFPhotoModel.swift
//  DFPhotoPicker_swift
//
//  Created by cg on 2018/12/13.
//  Copyright © 2018 df. All rights reserved.
//

import UIKit
import MJExtension
import Photos

enum HXPhotoModelMediaType : Int {
    case photo       = 0 //!< 照片
    case livePhoto   = 1 //!< LivePhoto
    case photoGif    = 2 //!< gif图
    case video       = 3 //!< 视频
    case audio       = 4 //!< 预留
    case cameraPhoto = 5 //!< 通过相机拍的照片
    case cameraVideo = 6 //!< 通过相机录制的视频
    case camera      = 7 //!< 跳转相机
}

enum HXPhotoModelMediaSubType : Int {
    case photo = 0 //!< 照片
    case video //!< 视频
}

enum HXPhotoModelVideoState : Int {
    case normal = 0 //!< 普通状态
    case undersize //!< 视频时长小于3秒
    case oversize //!< 视频时长超出限制
}

class DFPhotoModel: NSObject,NSCoding {
    func encode(with aCoder: NSCoder) {
        self.mj_encode(aCoder)
    }
    //父类的init方法是必须去实现的
    override init() {
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self.mj_decode(aDecoder)
    }
    

}
