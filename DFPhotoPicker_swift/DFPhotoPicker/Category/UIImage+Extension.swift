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
    class func animatedGIF(with data: Data?) -> UIImage? {
        guard data != nil else {
            return nil
        }
        //通过CFData读取gif文件的数据
        let source: CGImageSource = CGImageSourceCreateWithData(data! as CFData, nil)!
        //获取gif文件的帧数
        let count = CGImageSourceGetCount(source)
        var animatedImage: UIImage?
        if count <= 1 {
            if let aData = data {
                animatedImage = UIImage(data: aData)
            }
        } else {
            //大于一张图片时
            var images: [AnyHashable] = []
            //设置gif播放的时间
            var duration: TimeInterval = 0.0
            for i in 0..<count {
                //获取gif指定帧的像素位图
                let image = CGImageSourceCreateImageAtIndex(source, i, nil)
                if image == nil {
                    continue
                }
                //获取每张图的播放时间
                duration += self.frameDuration(at: i, source: source)
                images.append(UIImage(cgImage: image!, scale: UIScreen.main.scale, orientation: .up))
            }
            if duration == 0.0 {
                //如果播放时间为空
                duration = (1.0 / 10.0) * Double(count)
            }
            if let anImages = images as? [UIImage] {
                animatedImage = UIImage.animatedImage(with: anImages, duration: duration)
            }
        }
        return animatedImage
    }

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
    
    func animatedImageByScalingAndCropping(to size: CGSize) -> UIImage {
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
        var scaledImages: [UIImage] = []
        for image: UIImage in self.images! {
            UIGraphicsBeginImageContextWithOptions(size, _: false, _: 0.0)
            image.draw(in: CGRect(x: thumbnailPoint.x, y: thumbnailPoint.y, width: scaledSize.width, height: scaledSize.height))
            let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
            if let anImage = newImage {
                scaledImages.append(anImage)
            }
            UIGraphicsEndImageContext()
        }
        return UIImage.animatedImage(with: scaledImages, duration: duration)!
        
    }
    func normalizedImage() -> UIImage {
        if imageOrientation == .up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(size, _: false, _: scale)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return normalizedImage
    }
    //  The converted code is limited to 2 KB.
    //  Upgrade your plan to remove this limitation.
    //
    func fullNormalizedImage() -> UIImage? {
        if imageOrientation == .up {
            return self
        }
        
        var transform: CGAffineTransform = .identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: .pi / 2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: -(.pi / 2))
        default:
            break
        }
        
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        
        let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: (cgImage?.bitsPerComponent)!, bytesPerRow: 0, space: (cgImage?.colorSpace)!, bitmapInfo: (cgImage?.bitmapInfo)!.rawValue)
        ctx!.concatenate(transform)
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx!.draw(cgImage!, in: CGRect(x:  0, y: 0, width: size.height, height: size.width))

        default:
            ctx!.draw(cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        
        let cgimg = ctx!.makeImage()
        let img = UIImage(cgImage: cgimg!)
        return img
    }

    func clipImage(_ scale: CGFloat) -> UIImage? {
        let width = size.width
        let height = size.height
        
        let rect = CGRect(x: (width - width / scale) / 2, y: height / 2 - width / scale / 2, width: width / scale, height: width / scale)
        let sourceImageRef = cgImage
        let newCGImage = sourceImageRef?.cropping(to: rect)
        let newImage = UIImage(cgImage: newCGImage!)
        return newImage
    }
    func clipLeftOrRightImage(_ scale: CGFloat) -> UIImage? {
        let width = size.width
        let height = size.height
        
        let rect = CGRect(x: (width - height / scale) / 2, y: height / 2 - height / scale / 2, width: height / scale, height: height / scale)
        let imageRef = cgImage
        let imagePartRef = imageRef?.cropping(to: rect)
        var image: UIImage? = nil
        if let aRef = imagePartRef {
            image = UIImage(cgImage: aRef)
        }
        return image
    }
    func clipNormalizedImage(_ scale: CGFloat) -> UIImage? {
        let width = size.width
        let height = size.height
        
        let rect = CGRect(x: (width - width / scale) / 2, y: height / 2 - height / scale / 2, width: width / scale, height: height / scale)
        let imageRef = cgImage
        let imagePartRef = imageRef?.cropping(to: rect)
        var image: UIImage? = nil
        if let aRef = imagePartRef {
            image = UIImage(cgImage: aRef)
        }
        return image
    }
    func scaleImagetoScale(_ scaleSize: CGFloat) -> UIImage? {
        
        UIGraphicsBeginImageContext(CGSize(width: CGFloat(size.width * scaleSize), height: CGFloat(size.height * scaleSize)))
        
        draw(in: CGRect(x: 0, y: 0, width: CGFloat(size.width * scaleSize), height: CGFloat(size.height * scaleSize)))
        let scaledImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }

    func rotationImage(_ orient: UIImage.Orientation) -> UIImage? {
        var bnds = CGRect.zero
        var copy: UIImage? = nil
        var ctxt: CGContext? = nil
        let imag = cgImage
        var rect = CGRect.zero
        var tran: CGAffineTransform = .identity
        
        rect.size.width = CGFloat(setSafeInt(imag?.width))
        rect.size.height = CGFloat(setSafeInt(imag?.height))
        
        bnds = rect
        switch orient {
        case UIImage.Orientation.up:
            return self
        case UIImage.Orientation.upMirrored:
            tran = CGAffineTransform(translationX: rect.size.width, y: 0.0)
            tran = tran.scaledBy(x: -1.0, y: 1.0)
        case UIImage.Orientation.down:
            tran = CGAffineTransform(translationX: rect.size.width, y: rect.size.height)
            tran = tran.rotated(by: .pi)
        case UIImage.Orientation.downMirrored:
            tran = CGAffineTransform(translationX: 0.0, y: rect.size.height)
            tran = tran.scaledBy(x: 1.0, y: -1.0)
        case UIImage.Orientation.left:
            bnds = swapWidthAndHeight(rect: bnds)
            tran = CGAffineTransform(translationX: 0.0, y: rect.size.width)
            tran = tran.rotated(by: 3.0 * .pi / 2.0)
        case UIImage.Orientation.leftMirrored:
            bnds = swapWidthAndHeight(rect: bnds)
            tran = CGAffineTransform(translationX: rect.size.height, y: rect.size.width)
            tran = tran.scaledBy(x: -1.0, y: 1.0)
            tran = tran.rotated(by: 3.0 * .pi / 2.0)
        case UIImage.Orientation.right:
            bnds = swapWidthAndHeight(rect: bnds)
            tran = CGAffineTransform(translationX: rect.size.height, y: 0.0)
            tran = tran.rotated(by: .pi / 2.0)
        case UIImage.Orientation.rightMirrored:
            bnds = swapWidthAndHeight(rect: bnds)
            tran = CGAffineTransform(scaleX: -1.0, y: 1.0)
            tran = tran.rotated(by: .pi / 2.0)
        default:
            return self
        }
        UIGraphicsBeginImageContext(bnds.size)
        ctxt = UIGraphicsGetCurrentContext()
        
        switch orient {
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored, UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            ctxt!.scaleBy(x: -1.0, y: 1.0)
            ctxt!.translateBy(x: -rect.size.height, y: 0.0)
        default:
            ctxt!.scaleBy(x: 1.0, y: -1.0)
            ctxt!.translateBy(x: 0.0, y: -rect.size.height)
        }
        
        ctxt!.concatenate(tran)
        UIGraphicsGetCurrentContext()?.draw(imag!, in: rect)
        
        copy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return copy;
    }
    //* 交换宽和高
    
    private func swapWidthAndHeight(rect: CGRect) -> CGRect {
        var newRect:CGRect!
        let swap: CGFloat = rect.size.width
        
        newRect.size.width = rect.size.height
        newRect.size.height = swap
        
        return newRect
    }
}
