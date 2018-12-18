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
    class func thumbnailImage(forVideo videoURL: URL?, atTime time: TimeInterval) -> UIImage {
        var asset: AVURLAsset? = nil
        if let anURL = videoURL {
            asset = AVURLAsset(url: anURL, options: nil)
        }
        if asset == nil {
            return UIImage()
        }
        var assetImageGenerator: AVAssetImageGenerator? = nil
        if let anAsset = asset {
            assetImageGenerator = AVAssetImageGenerator(asset: anAsset)
        }
        assetImageGenerator?.appliesPreferredTrackTransform = true
        assetImageGenerator?.apertureMode = .encodedPixels
        var thumbnailImageRef: CGImage? = nil
        let thumbnailImageTime = CFTimeInterval(time)
        var _: Error? = nil
        thumbnailImageRef = try! assetImageGenerator?.copyCGImage(at: CMTimeMake(value: Int64(thumbnailImageTime), timescale: 60), actualTime: nil)
        var thumbnailImage: UIImage? = nil
        if let aRef = thumbnailImageRef {
            thumbnailImage = thumbnailImageRef != nil ? UIImage(cgImage: aRef) : nil
        }
        return thumbnailImage!
    }

    class func getDateLocationDetailInformation(with model: DFPhotoDateModel?, completion: @escaping (_ placemark: CLPlacemark?, _ model: DFPhotoDateModel?) -> Void) -> CLGeocoder? {
        let geoCoder = CLGeocoder()
        if let aLocation = model?.location {
            geoCoder.reverseGeocodeLocation(aLocation, completionHandler: { placemarks, error in
                if (placemarks?.count ?? 0) > 0 && error == nil {
                    let placemark: CLPlacemark? = placemarks?.first
                    //if completion
                    
                    completion(placemark, model)
                }
            })
        }
        return geoCoder
    }
    class func getAVAsset(with model: DFPhotoModel?,
                          startRequestIcloud: @escaping (_ model: DFPhotoModel?, _ cloudRequestId: PHImageRequestID) -> Void,
                          progressHandler: @escaping (_ model: DFPhotoModel?, _ progress: Double) -> Void,
                          completion: @escaping (_ model: DFPhotoModel?, _ asset: AVAsset?) -> Void,
                          failed: @escaping (_ model: DFPhotoModel?, _ info: [AnyHashable : Any]?) -> Void)
        -> PHImageRequestID {
        var options = PHVideoRequestOptions()
        options.deliveryMode = .fastFormat
        options.isNetworkAccessAllowed = false
        var requestId = PHImageRequestID(0)
        model?.iCloudDownloading = true
        requestId = PHImageManager.default().requestAVAsset(forVideo: (model?.asset)!, options: options, resultHandler: { asset, audioMix, info in
            var downloadFinined: Bool = !(setSafeBool(info?[PHImageCancelledKey])) && info?[PHImageErrorKey] == nil && !(setSafeBool(info?[PHImageResultIsDegradedKey]))
            if downloadFinined && (asset != nil) {
                DispatchQueue.main.async(execute: {
                    model?.iCloudDownloading = false
                    model?.isICloud = false
                    completion(model, asset)
                })
            } else {
                if (setSafeBool(info?[PHImageResultIsInCloudKey])) &&
                    !(setSafeBool(info?[PHImageCancelledKey])) &&
                    info?[PHImageErrorKey] == nil {
                    var cloudRequestId = PHImageRequestID(0)
                    var cloudOptions = PHVideoRequestOptions()
                    cloudOptions.deliveryMode = .mediumQualityFormat
                    cloudOptions.isNetworkAccessAllowed = true
                    cloudOptions.progressHandler = { progress, error, stop, info in
                        DispatchQueue.main.async(execute: {
                            model?.iCloudProgress = CGFloat(progress)
                            progressHandler(model, progress)
                        })
                    }
                    cloudRequestId = PHImageManager.default().requestAVAsset(forVideo: (model?.asset)!, options: cloudOptions, resultHandler: { asset, audioMix, info in
                        var downloadFinined: Bool = !(setSafeBool(info?[PHImageCancelledKey])) && info[PHImageErrorKey] == nil && !(setSafeBool(info?[PHImageResultIsDegradedKey]))
                        if downloadFinined && (asset != nil) {
                            DispatchQueue.main.async(execute: {
                                model?.iCloudDownloading = false
                                model?.isICloud = false
                                completion(model, asset)
                            })
                        } else {
                            DispatchQueue.main.async(execute: {
                                if !(setSafeBool(info?[PHImageCancelledKey])) {
                                    model?.iCloudDownloading = false
                                }
                                failed(model, info)
                            })
                        }

                    })
                    DispatchQueue.main.async(execute: {
                        model?.iCloudRequestID = cloudRequestId
                        startRequestIcloud(model, cloudRequestId)
                    })


                }

            }

        })

    }

}
