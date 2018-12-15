//
//  UIImage+Extension.swift
//  DFPhotoPicker_swift
//
//  Created by cg on 2018/12/14.
//  Copyright © 2018 df. All rights reserved.
//

import Foundation
import ImageIO

extension UIImage {
    
    class func frameDuration(at index: Int, source: CGImageSource?) -> TimeInterval {
        var delay = 0.0
        if let imageSRef = source {
            
            guard let imgProperties: NSDictionary = CGImageSourceCopyPropertiesAtIndex(imageSRef, index, nil) else { return delay }
            // 获取该帧图片的属性字典
            if let property = imgProperties[kCGImagePropertyGIFDictionary as String] as? NSDictionary {
                // 获取该帧图片的动画时长
                if let unclampedDelayTime = property[kCGImagePropertyGIFUnclampedDelayTime as String] as? NSNumber {
                    delay = unclampedDelayTime.doubleValue
                    if delay <= 0, let delayTime = property[kCGImagePropertyGIFDelayTime as String] as? NSNumber {
                        delay = delayTime.doubleValue
                    }
                }
                //如果帧数小于0.1,则指定为0.1
                if delay < 0.011 {
                    delay = 0.100
                }
            }
            return delay
        } else {
            return delay
        }
    }
    
    func animatedImageByScalingAndCropping(to size: CGSize) -> UIImage? {
        if self.size.equalTo(size) || size.equalTo(CGSize.zero) {
            return self
        }
        var scaledSize: CGSize = size
        var thumbnailPoint = CGPoint.zero
        //获取较大的缩放比例值,宽高等比缩放
        let widthFactor: CGFloat = size.width / self.size.width
        let heightFactor: CGFloat = size.height / self.size.height
        let scaleFactor: CGFloat = (widthFactor > heightFactor) ? widthFactor : heightFactor
        scaledSize.width = self.size.width * scaleFactor
        scaledSize.height = self.size.height * scaleFactor
        //调整位置,使缩放后的图居中
        if widthFactor > heightFactor {
            thumbnailPoint.y = (size.height - scaledSize.height) * 0.5
        } else if widthFactor < heightFactor {
            thumbnailPoint.x = (size.width - scaledSize.width) * 0.5
        }
        //遍历self.images, 将图片缩放后导出放入数组
        var scaledImages: [AnyHashable] = []
        for image: UIImage? in images {
            UIGraphicsBeginImageContextWithOptions(size, _: false, _: 0.0)
            image?.draw(in: CGRect(x: thumbnailPoint.x, y: thumbnailPoint.y, width: scaledSize.width, height: scaledSize.height))
            let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
            if let anImage = newImage {
                scaledImages.append(anImage)
            }
            UIGraphicsEndImageContext()
        }
        if let anImages = scaledImages as? [UIImage] {
            return UIImage.animatedImage(with: anImages, duration: duration)
        }
        return nil
    }


    
}
