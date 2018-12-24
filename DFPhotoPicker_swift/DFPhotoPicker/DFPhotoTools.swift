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
            let options = PHVideoRequestOptions()
            options.deliveryMode = .fastFormat
            options.isNetworkAccessAllowed = false
            var requestId = PHImageRequestID(0)
            model?.iCloudDownloading = true
            requestId = PHImageManager.default().requestAVAsset(forVideo: (model?.asset)!, options: options, resultHandler: { asset, audioMix, info in
                let downloadFinined: Bool = !(setSafeBool(info?[PHImageCancelledKey])) && info?[PHImageErrorKey] == nil && !(setSafeBool(info?[PHImageResultIsDegradedKey]))
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
                        let cloudOptions = PHVideoRequestOptions()
                        cloudOptions.deliveryMode = .mediumQualityFormat
                        cloudOptions.isNetworkAccessAllowed = true
                        cloudOptions.progressHandler = { progress, error, stop, info in
                            DispatchQueue.main.async(execute: {
                                model?.iCloudProgress = CGFloat(progress)
                                progressHandler(model, progress)
                            })
                        }
                        cloudRequestId = PHImageManager.default().requestAVAsset(forVideo: (model?.asset)!, options: cloudOptions, resultHandler: { asset, audioMix, info in
                            let downloadFinined: Bool = !(setSafeBool(info?[PHImageCancelledKey])) && info?[PHImageErrorKey] == nil && !(setSafeBool(info?[PHImageResultIsDegradedKey]))
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
                    } else {
                        DispatchQueue.main.async(execute: {
                            if !(setSafeBool(info?[PHImageCancelledKey])) {
                                model?.iCloudDownloading = false
                            }
                            failed(model, info)
                        })
                    }
                }
            })
            model?.iCloudRequestID = requestId
            return requestId
            
    }
    @available(iOS 9.1, *)
    class func getLivePhoto(with model: DFPhotoModel?,
                            size: CGSize,
                            startRequestICloud: @escaping (_ model: DFPhotoModel?, _ iCloudRequestId: PHImageRequestID) -> Void, progressHandler: @escaping (_ model: DFPhotoModel?, _ progress: Double) -> Void,
                            completion: @escaping (_ model: DFPhotoModel?, _ livePhoto: PHLivePhoto?) -> Void, failed: @escaping (_ model: DFPhotoModel?, _ info: [AnyHashable : Any]?) -> Void)
        -> PHImageRequestID {
            let option = PHLivePhotoRequestOptions()
            option.deliveryMode = .highQualityFormat
            option.isNetworkAccessAllowed = false
            var requestId = PHImageRequestID(0)
            model?.iCloudDownloading = true
            requestId = PHImageManager.default().requestLivePhoto(for: (model?.asset)!, targetSize: size, contentMode: .aspectFill, options: option, resultHandler: { livePhoto, info in
                let downloadFinined: Bool = !(setSafeBool(info?[PHImageCancelledKey])) && info?[PHImageErrorKey] == nil && !(setSafeBool(info?[PHImageResultIsDegradedKey]))
                if downloadFinined && (livePhoto != nil) {
                    DispatchQueue.main.async(execute: {
                        model?.isICloud = false
                        model?.iCloudDownloading = false
                        completion(model, livePhoto)
                    })
                } else {
                    if (setSafeBool(info?[PHImageResultIsInCloudKey])) && !(setSafeBool(info?[PHImageCancelledKey])) && info?[PHImageErrorKey] == nil {
                        var iCloudRequestId = PHImageRequestID(0)
                        let iCloudOption = PHLivePhotoRequestOptions()
                        iCloudOption.deliveryMode = .highQualityFormat
                        iCloudOption.isNetworkAccessAllowed = true
                        iCloudOption.progressHandler = { progress, error, stop, info in
                            DispatchQueue.main.async(execute: {
                                model?.iCloudProgress = CGFloat(progress)
                                progressHandler(model, progress)
                            })
                        }
                        iCloudRequestId = PHImageManager.default().requestLivePhoto(for: (model?.asset)!, targetSize: size, contentMode: .aspectFill, options: iCloudOption, resultHandler: { livePhoto, info in
                            let downloadFinined: Bool = !(setSafeBool(info?[PHImageCancelledKey])) && info?[PHImageErrorKey] == nil && !(setSafeBool(info?[PHImageResultIsDegradedKey]))
                            if downloadFinined && livePhoto != nil {
                                DispatchQueue.main.async(execute: {
                                    model?.isICloud = false
                                    model?.iCloudDownloading = false
                                    completion(model, livePhoto)
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
                            model?.iCloudRequestID = requestId
                            startRequestICloud(model, iCloudRequestId)
                        })
                    } else {
                        DispatchQueue.main.async(execute: {
                            if !(setSafeBool(info?[PHImageCancelledKey])) {
                                model?.iCloudDownloading = false
                            }
                            failed(model, info)
                        })
                    }
                }
            })
            model?.iCloudRequestID = requestId
            return requestId
    }
    
    class func getImageData(with model: DFPhotoModel?, startRequestIcloud: @escaping (_ model: DFPhotoModel?, _ cloudRequestId: PHImageRequestID) -> Void, progressHandler: @escaping (_ model: DFPhotoModel?, _ progress: Double) -> Void, completion: @escaping (_ model: DFPhotoModel?, _ imageData: Data?, _ orientation: UIImage.Orientation) -> Void, failed: @escaping (_ model: DFPhotoModel?, _ info: [AnyHashable : Any]?) -> Void) -> PHImageRequestID {
        let option = PHImageRequestOptions()
        option.deliveryMode = .highQualityFormat
        option.resizeMode = .fast
        option.isNetworkAccessAllowed = false
        option.isSynchronous = false
        if model?.type == DFPhotoModelMediaTypePhotoGif {
            option.version = .original
        }
        model?.iCloudDownloading = true
        let requestID: PHImageRequestID = PHImageManager.default().requestImageData(for: (model?.asset)!, options: option, resultHandler: { imageData, dataUTI, orientation, info in
            let downloadFinined: Bool = !(setSafeBool(info?[PHImageCancelledKey])) && info?[PHImageErrorKey] == nil && !(setSafeBool(info?[PHImageResultIsDegradedKey]))
            if downloadFinined && (imageData != nil) {
                DispatchQueue.main.async(execute: {
                    model?.iCloudDownloading = false
                    model?.isICloud = false
                    completion(model, imageData, orientation)
                })
            } else {
                if (setSafeBool(info?[PHImageResultIsInCloudKey])) && !(setSafeBool(info?[PHImageCancelledKey])) && info?[PHImageErrorKey] == nil {
                    var cloudRequestId = PHImageRequestID(0)
                    let option = PHImageRequestOptions()
                    option.deliveryMode = .highQualityFormat
                    option.resizeMode = .fast
                    option.isNetworkAccessAllowed = true
                    option.version = .original
                    option.progressHandler = { progress, error, stop, info in
                        DispatchQueue.main.async(execute: {
                            model?.iCloudProgress = CGFloat(progress)
                            progressHandler(model, progress)
                        })
                    }
                    cloudRequestId = PHImageManager.default().requestImageData(for: (model?.asset)!, options: option, resultHandler: { imageData, dataUTI, orientation, info in
                        let downloadFinined: Bool = !(setSafeBool(info?[PHImageCancelledKey])) && info?[PHImageErrorKey] == nil && !(setSafeBool(info?[PHImageResultIsDegradedKey]))
                        if downloadFinined && imageData != nil {
                            DispatchQueue.main.async(execute: {
                                model?.iCloudDownloading = false
                                model?.isICloud = false
                                completion(model, imageData, orientation)
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
                } else {
                    DispatchQueue.main.async(execute: {
                        if !(setSafeBool(info?[PHImageCancelledKey])) {
                            model?.iCloudDownloading = false
                        }
                        failed(model, info)
                    })
                }
            }
        })
        model?.iCloudRequestID = requestID
        return requestID
    }
    class func getImagePath(with model: DFPhotoModel?,
                            startRequestIcloud: @escaping (DFPhotoModel?, PHContentEditingInputRequestID) -> Void,
                            progressHandler: @escaping (DFPhotoModel?, Double) -> Void,
                            completion: @escaping (DFPhotoModel?, String?) -> Void,
                            failed: @escaping (DFPhotoModel?, [AnyHashable : Any]?) -> Void) -> PHContentEditingInputRequestID {
        let options = PHContentEditingInputRequestOptions()
        options.isNetworkAccessAllowed = false
        return (model?.asset.requestContentEditingInput(with: options, completionHandler: { contentEditingInput, info in
            let downloadFinined: Bool = !(setSafeBool(info[PHContentEditingInputCancelledKey])) && info[PHContentEditingInputErrorKey] == nil
            
            if downloadFinined && contentEditingInput?.fullSizeImageURL?.relativePath != nil {
                DispatchQueue.main.async(execute: {
                    completion(model, contentEditingInput?.fullSizeImageURL?.relativePath)
                })
            } else {
                if (setSafeBool(info[PHContentEditingInputResultIsInCloudKey])) && !(setSafeBool(info[PHContentEditingInputCancelledKey])) && info[PHContentEditingInputErrorKey] == nil {
                    let iCloudOptions = PHContentEditingInputRequestOptions()
                    iCloudOptions.isNetworkAccessAllowed = true
                    iCloudOptions.progressHandler = { progress, stop in
                        DispatchQueue.main.async(execute: {
                            progressHandler(model, progress)
                        })
                    }
                    
                    let iCloudRequestID: PHContentEditingInputRequestID = (model?.asset.requestContentEditingInput(with: iCloudOptions, completionHandler: { contentEditingInput, info in
                        let downloadFinined: Bool = !(setSafeBool(info[PHContentEditingInputCancelledKey])) && info[PHContentEditingInputErrorKey] == nil
                        
                        if downloadFinined && contentEditingInput?.fullSizeImageURL?.relativePath != nil {
                            DispatchQueue.main.async(execute: {
                                completion(model, contentEditingInput?.fullSizeImageURL?.relativePath)
                            })
                        } else {
                            DispatchQueue.main.async(execute: {
                                failed(model, info)
                            })
                        }
                    }))!
                    DispatchQueue.main.async(execute: {
                        startRequestIcloud(model, iCloudRequestID)
                    })

                } else {
                    DispatchQueue.main.async(execute: {
                        failed(model, info)
                    })
                }
            }
        }))!
    }
    class func getPhotoFor(_ asset: PHAsset?,
                           size: CGSize,
                           completion: @escaping (_ image: UIImage?, _ info: [AnyHashable : Any]?) -> Void) -> PHImageRequestID {
        let option = PHImageRequestOptions()
        option.resizeMode = .fast
        
        if let anAsset = asset {
            return PHImageManager.default().requestImage(for: anAsset, targetSize: size, contentMode: .aspectFill, options: option, resultHandler: { result, info in
                
                let downloadFinined: Bool = !(setSafeBool(info?[PHImageCancelledKey])) && info?[PHImageErrorKey] == nil
                
                if downloadFinined && result != nil {
                    DispatchQueue.main.async(execute: {
                        completion(result, info)
                    })
                }
            })
        }
        return 0
    }
    class func getHighQualityFormatPhoto(for asset: PHAsset?,
                                         size: CGSize,
                                         completion: @escaping (_ image: UIImage?, _ info: [AnyHashable : Any]?) -> Void,
                                         error: @escaping (_ info: [AnyHashable : Any]?) -> Void) -> PHImageRequestID {
        let option = PHImageRequestOptions()
        option.deliveryMode = .highQualityFormat
        option.resizeMode = .fast
        option.isNetworkAccessAllowed = false
        
        var requestID: PHImageRequestID? = nil
        if let anAsset = asset {
            requestID = PHImageManager.default().requestImage(for: anAsset, targetSize: size, contentMode: .aspectFill, options: option, resultHandler: { result, info in
                
                let downloadFinined: Bool = !(setSafeBool(info?[PHImageCancelledKey])) && info?[PHImageErrorKey] == nil && !(setSafeBool(info?[PHImageResultIsDegradedKey] ))
                if downloadFinined && result != nil {
                    DispatchQueue.main.async(execute: {
                        completion(result, info)
                    })
                } else {
                    DispatchQueue.main.async(execute: {
                        error(info)
                    })
                }
            })
        }
        return requestID ?? 0
    }
    class func getImageWith(_ model: DFAlbumModel?,
                            size: CGSize,
                            completion: @escaping (_ image: UIImage?, _ model: DFAlbumModel?) -> Void) -> PHImageRequestID {
        let option = PHImageRequestOptions()
        option.resizeMode = .fast
        if let anAsset = model?.asset {
            return PHImageManager.default().requestImage(for: anAsset, targetSize: size, contentMode: .aspectFill, options: option, resultHandler: { result, info in
                let downloadFinined: Bool = !(setSafeBool(info?[PHImageCancelledKey])) && info?[PHImageErrorKey] == nil
                if downloadFinined && result != nil {
                    DispatchQueue.main.async(execute: {
                        completion(result, model)
                    })
                }
            })
        }
        return 0
    }
    class func getImageWith(_ model: DFAlbumModel?,
                            asset: PHAsset?,
                            size: CGSize,
                            completion: @escaping (_ image: UIImage?, _ model: DFAlbumModel?) -> Void) -> PHImageRequestID {
        let option = PHImageRequestOptions()
        option.resizeMode = .fast
        if let anAsset = asset {
            return PHImageManager.default().requestImage(for: anAsset, targetSize: size, contentMode: .aspectFill, options: option, resultHandler: { result, info in
                let downloadFinined: Bool = !(setSafeBool(info?[PHImageCancelledKey])) && info?[PHImageErrorKey] == nil
                if downloadFinined && result != nil {
                    DispatchQueue.main.async(execute: {
                        completion(result, model)
                        
                    })
                }
            })
        }
        return 0
    }
    class func getImageWith(_ model: DFPhotoModel?,
                            completion: @escaping (_ image: UIImage?, _ model: DFPhotoModel?) -> Void) -> PHImageRequestID {
        let option = PHImageRequestOptions()
        option.resizeMode = .fast
        if let anAsset = model?.asset {
            return PHImageManager.default().requestImage(for: anAsset, targetSize: model?.requestSize ?? CGSize.zero, contentMode: .aspectFill, options: option, resultHandler: { result, info in
                let downloadFinined: Bool = !(setSafeBool(info?[PHImageCancelledKey])) && info?[PHImageErrorKey] == nil
                if downloadFinined && result != nil {
                    DispatchQueue.main.async(execute: {
                        //if completion
                        
                        completion(result, model)
                        
                    })
                }
            })
        }
        return 0
    }
    @available(iOS 9.1, *)
    class func fetchLivePhoto(for asset: PHAsset?,
                              size: CGSize,
                              completion: @escaping (PHLivePhoto?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID {
        let option = PHLivePhotoRequestOptions()
        option.deliveryMode = .highQualityFormat
        option.isNetworkAccessAllowed = false
        
        if let anAsset = asset {
            return PHCachingImageManager.default().requestLivePhoto(for: anAsset, targetSize: size, contentMode: .aspectFill, options: option, resultHandler: { livePhoto, info in
                let downloadFinined: Bool = !(setSafeBool(info?[PHLivePhotoInfoCancelledKey])) && info?[PHLivePhotoInfoErrorKey] == nil
                if downloadFinined && livePhoto != nil {
                    DispatchQueue.main.async(execute: {
                        completion(livePhoto, info)
                    })
                }
            })
        }
        return 0
    }
    /**
     获取视频的时长
     */
    class func getNewTime(fromDurationSecond duration: Int) -> String? {
        var newTime: String
        if duration < 10 {
            newTime = String(format: "00:0%zd", duration)
        } else if duration < 60 {
            newTime = String(format: "00:%zd", duration)
        } else {
            let min: Int = duration / 60
            let sec: Int = duration - (min * 60)
            if sec < 10 {
                newTime = String(format: "%zd:0%zd", min, sec)
            } else {
                newTime = String(format: "%zd:%zd", min, sec)
            }
        }
        return newTime
    }
    /**
     相册名称转换
     */
    class func transFormPhotoTitle(_ englishName: String?) -> String? {
        var photoName: String
        if (englishName == "Bursts") {
            photoName = "连拍快照"
        } else if (englishName == "Recently Added") || (englishName == "最後に追加した項目") || (englishName == "최근 추가된 항목") {
            photoName = "最近添加"
        } else if (englishName == "Screenshots") || (englishName == "スクリーンショット") || (englishName == "스크린샷") {
            photoName = "屏幕快照"
        } else if (englishName == "Camera Roll") || (englishName == "カメラロール") || (englishName == "카메라 롤") {
            photoName = "相机胶卷"
        } else if (englishName == "Selfies") || (englishName == "셀카") {
            photoName = "自拍"
        } else if (englishName == "My Photo Stream") {
            photoName = "我的照片流"
        } else if (englishName == "Videos") || (englishName == "ビデオ") {
            photoName = "视频"
        } else if (englishName == "All Photos") || (englishName == "すべての写真") || (englishName == "비디오") {
            photoName = "所有照片"
        } else if (englishName == "Slo-mo") || (englishName == "スローモーション") {
            photoName = "慢动作"
        } else if (englishName == "Recently Deleted") || (englishName == "最近削除した項目") {
            photoName = "最近删除"
        } else if (englishName == "Favorites") || (englishName == "お気に入り") || (englishName == "최근 삭제된 항목") {
            photoName = "个人收藏"
        } else if (englishName == "Panoramas") || (englishName == "パノラマ") || (englishName == "파노라마") {
            photoName = "全景照片"
        } else {
            photoName = englishName ?? ""
        }
        return photoName
    }
    class func fetchPhotosBytes(_ photos: [Any]?, completion: @escaping (String?) -> Void) {
        var dataLength: Int = 0
        var assetCount: Int = 0
        DispatchQueue.global(qos: .default).async(execute: {
            for i in 0..<(photos?.count ?? 0) {
                let model = photos?[i] as? DFPhotoModel
                if model?.type == DFPhotoModelMediaTypeCameraPhoto {
                    var imageData: Data?
                    if ((model?.thumbPhoto)?.pngData() != nil) {
                        //返回为png图像。
                        imageData = (model?.thumbPhoto)?.pngData()
                    } else {
                        //返回为JPEG图像。
                        if let aPhoto = model?.thumbPhoto {
                            imageData = aPhoto.jpegData(compressionQuality: 1.0)
                        }
                    }
                    dataLength += imageData?.count ?? 0
                    assetCount += 1
                    if assetCount >= (photos?.count ?? 0) {
                        let bytes = self.getBytesFromDataLength(dataLength)
                        DispatchQueue.main.async(execute: {
                            completion(bytes)
                        })
                    }
                } else {
                    if let anAsset = model?.asset {
                        PHImageManager.default().requestImageData(for: anAsset, options: nil, resultHandler: { imageData, dataUTI, orientation, info in
                            dataLength += imageData?.count ?? 0
                            assetCount += 1
                            if assetCount >= (photos?.count ?? 0) {
                                let bytes = self.getBytesFromDataLength(dataLength)
                                DispatchQueue.main.async(execute: {
                                    completion(bytes)
                                })
                            }
                        })
                    }
                }
            }
        })
    }
    class func getVideoEachFrame(with asset: AVAsset?, total: Int, size: CGSize, complete: @escaping (AVAsset?, [UIImage]?) -> Void) {
        let duration:CMTime = (asset?.duration)!
        let durationS = round(Double(duration.value)) / Double((duration.timescale))
        let average = TimeInterval(CGFloat(durationS) / CGFloat(total))
        var generator : AVAssetImageGenerator?
        if let anAsset = asset {
            generator = AVAssetImageGenerator(asset: anAsset)
            generator?.maximumSize = size
            generator?.appliesPreferredTrackTransform = true
            generator?.requestedTimeToleranceBefore = .zero
            generator?.requestedTimeToleranceAfter = .zero
        }
        var arr: [AnyHashable] = []
        for i in 1...total {
            let time: CMTime = CMTimeMake( value: Int64((Double(i) * average) * Double(duration.timescale)), timescale: duration.timescale)
            let value = NSValue(time: time)
            arr.append(value)
        }
        var arrImages: [AnyHashable] = []
        var count: Int = 0
        
        generator?.generateCGImagesAsynchronously(forTimes: arr as! [NSValue], completionHandler: { requestedTime, image, actualTime, result, error in
            switch result {
            case .succeeded:
                if let anImage = image {
                    arrImages.append(UIImage(cgImage: anImage))
                }
            case .failed:
                break
            case .cancelled:
                break
            }
            count += 1
            if count == arr.count {
                DispatchQueue.main.async(execute: {
                    complete(asset, arrImages as? [UIImage])
                })
            }
        })
    }
    class func getBytesFromDataLength(_ dataLength: Int) -> String? {
        var bytes: String
        if Double(dataLength) >= 0.1 * (1024 * 1024) {
            bytes = String(format: "%0.1fM", Double(dataLength / 1024) / 1024.0)
        } else if dataLength >= 1024 {
            bytes = String(format: "%0.0fK", Double(dataLength) / 1024.0)
        } else {
            bytes = String(format: "%zdB", dataLength)
        }
        return bytes
    }
    class func saveVideoToCustomAlbum(withName albumName: String?, videoURL: URL?) {
        if !(videoURL != nil) {
            return
        }
        PHPhotoLibrary.requestAuthorization({ status in
            if status != .authorized {
                return
            }
            DispatchQueue.main.async(execute: {
                if !iOS9_Later {
                    if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum((videoURL?.path)!) {
                        //保存相册核心代码
                        UISaveVideoAtPathToSavedPhotosAlbum((videoURL?.path)!, nil, nil, nil)
                    }
                    return
                }
                var error: Error? = nil
                // 保存相片到相机胶卷
                var createdAsset: PHObjectPlaceholder? = nil
                try? PHPhotoLibrary.shared().performChangesAndWait({
                    createdAsset = PHAssetCreationRequest.creationRequestForAssetFromVideo(atFileURL: videoURL!)?.placeholderForCreatedAsset
                })
                
                if error != nil {
                    if DFShowLog {
                        NSLog("保存失败")
                    }
                    return
                }
                
                // 拿到自定义的相册对象
                var collection: PHAssetCollection? = self.createCollection(albumName)
                if collection == nil {
                    if DFShowLog {
                        NSLog("保存自定义相册失败")
                    }
                    return
                }
                
                try? PHPhotoLibrary.shared().performChangesAndWait({
                    if let aCollection = collection {
                        PHAssetCollectionChangeRequest(for: aCollection)?.insertAssets([createdAsset] as NSFastEnumeration, at: NSIndexSet(index: 0) as IndexSet)
                    }
                })
                
                if error != nil {
                    if DFShowLog {
                        NSLog("保存自定义相册失败")
                    }
                } else {
                    if DFShowLog {
                        NSLog("保存成功")
                    }
                }
            })
        })
    }
    class func savePhotoToCustomAlbum(withName albumName: String?, photo: UIImage?) {
        if photo == nil {
            return
        }
        // 判断授权状态
        PHPhotoLibrary.requestAuthorization({ status in
            if status != .authorized {
                return
            }
            DispatchQueue.main.async(execute: {
                if !iOS9_Later {
                    UIImageWriteToSavedPhotosAlbum(photo!, nil, nil, nil)
                    return
                }
                var error: Error? = nil
                // 保存相片到相机胶卷
                var createdAsset: PHObjectPlaceholder? = nil
                try? PHPhotoLibrary.shared().performChangesAndWait({
                    if let aPhoto = photo {
                        createdAsset = PHAssetCreationRequest.creationRequestForAsset(from: aPhoto).placeholderForCreatedAsset
                    }
                })
                
                if error != nil {
                    if DFShowLog {
                        NSLog("保存失败")
                    }
                    return
                }
                
                // 拿到自定义的相册对象
                let collection: PHAssetCollection? = self.createCollection(albumName)
                if collection == nil {
                    if DFShowLog {
                        NSLog("保存自定义相册失败")
                    }
                    return
                }
                try? PHPhotoLibrary.shared().performChangesAndWait({
                    if let aCollection = collection {
                        PHAssetCollectionChangeRequest(for: aCollection)?.insertAssets([createdAsset] as NSFastEnumeration, at: NSIndexSet(index: 0) as IndexSet)
                    }
                })
                
                if error != nil {
                    if DFShowLog {
                        NSLog("保存自定义相册失败")
                    }
                } else {
                    if DFShowLog {
                        NSLog("保存成功")
                    }
                }
            })
        })
    }
    // 创建自己要创建的自定义相册
    class func createCollection(_ albumName: String?) -> PHAssetCollection? {
        let title = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
        let collections: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        
        var createCollection: PHAssetCollection? = nil
        collections.enumerateObjects { (collections, index, stop) in
            if (collections.localizedTitle == title) {
                createCollection = collections
                stop.pointee = true
            }
        }
        if createCollection == nil {
            var createCollectionID: String? = nil
            
            do {
                try PHPhotoLibrary.shared().performChangesAndWait({
                    let title = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
                    createCollectionID = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: title ?? "").placeholderForCreatedAssetCollection.localIdentifier
                })
            } catch {
                if DFShowLog {
                    NSLog("创建相册失败...")
                }
                return nil
            }
            // 创建相册之后我们还要获取此相册  因为我们要往进存储相片
            createCollection = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [createCollectionID!], options: nil).firstObject
        }
        
        return createCollection
    }
    class func getTextWidth(_ text: String?, height: CGFloat, fontSize: CGFloat) -> CGFloat {
        
        return self.getTextWidth(text, height: height, font: UIFont.systemFont(ofSize: fontSize))
    }
    
    class func getTextWidth(_ text: String?, height: CGFloat, font: UIFont?) -> CGFloat {
        var newSize: CGSize? = nil
        if let aFont = font {
            newSize = text?.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: aFont], context: nil).size
        }
        
        return newSize?.width ?? 0.0
    }
    class func getTextHeight(_ text: String?, width: CGFloat, font: UIFont?) -> CGFloat {
        var newSize: CGSize? = nil
        if let aFont = font {
            newSize = text?.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: aFont], context: nil).size
        }
        
        return newSize?.height ?? 0.0
    }
    class func isIphone6() -> Bool {
        
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let platform = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        if (platform == "iPhone7,2") {
            //6
            return true
        }
        if (platform == "iPhone8,1") {
            //6s
            return true
        }
        if (platform == "iPhone9,1") || (platform == "iPhone9,3") {
            //7
            return true
        }
        if (platform == "iPhone10,1") || (platform == "iPhone10,4") {
            //8
            return true
        }
        return false
    }
    class func platform() -> Bool {
        
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let platform = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        var have = false
        if (platform == "iPhone8,1") {
            // iphone6s
            have = true
        } else if (platform == "iPhone8,2") {
            // iphone6s plus
            have = true
        } else if (platform == "iPhone9,1") {
            // iphone7
            have = true
        } else if (platform == "iPhone9,2") {
            // iphone7 plus
            have = true
        } else if (platform == "iPhone10,1") {
            // iphone7 plus
            have = true
        } else if (platform == "iPhone10,2") {
            // iphone7 plus
            have = true
        } else if (platform == "iPhone10,3") {
            // iphone7 plus
            have = true
        } else if (platform == "iPhone10,4") {
            // iphone7 plus
            have = true
        } else if (platform == "iPhone10,5") {
            // iphone7 plus
            have = true
        } else if (platform == "iPhone10,6") {
            // iphone7 plus
            have = true
        }
        return have
    }
    class func getHighQualityFormatPhoto(_ asset: PHAsset?,
                                         size: CGSize,
                                         succeed: @escaping (_ image: UIImage?) -> Void,
                                         failed: @escaping () -> Void) -> PHImageRequestID {
        let option = PHImageRequestOptions()
        option.deliveryMode = .highQualityFormat
        option.resizeMode = .fast
        option.isNetworkAccessAllowed = false
        var requestID: PHImageRequestID? = nil
        if let anAsset = asset {
            requestID = PHImageManager.default().requestImage(for: anAsset, targetSize: size, contentMode: .aspectFill, options: option, resultHandler: { result, info in
                let downloadFinined: Bool = !(setSafeBool(info?[PHImageCancelledKey])) && info?[PHImageErrorKey] == nil && !(setSafeBool(info?[PHImageResultIsDegradedKey]))
                if downloadFinined && result != nil {
                    DispatchQueue.global(qos: .default).async(execute: {
                        succeed(result)
                    })
                } else {
                    failed()
                }
            })
        }
        return requestID ?? 0
    }
    class func getPlayerItem(with asset: PHAsset?,
                             startRequestIcloud: @escaping (_ cloudRequestId: PHImageRequestID) -> Void,
                             progressHandler: @escaping (_ progress: Double) -> Void,
                             completion: @escaping (_ playerItem: AVPlayerItem?) -> Void,
                             failed: @escaping (_ info: [AnyHashable : Any]?) -> Void) -> PHImageRequestID {
        let options = PHVideoRequestOptions()
        options.deliveryMode = .fastFormat
        options.isNetworkAccessAllowed = false
        if let anAsset = asset {
            return PHImageManager.default().requestPlayerItem(forVideo: anAsset, options: options, resultHandler: { playerItem, info in
                let downloadFinined: Bool = !(setSafeBool(info?[PHImageCancelledKey])) && info?[PHImageErrorKey] == nil && !(setSafeBool(info?[PHImageResultIsDegradedKey]))
                if downloadFinined && (playerItem != nil) {
                    DispatchQueue.main.async(execute: {
                        completion(playerItem)
                    })
                } else {
                    if (setSafeBool(info?[PHImageResultIsInCloudKey])) {
                        var cloudRequestId = PHImageRequestID(0)
                        let cloudOptions = PHVideoRequestOptions()
                        cloudOptions.deliveryMode = .mediumQualityFormat
                        cloudOptions.isNetworkAccessAllowed = true
                        cloudOptions.progressHandler = { progress, error, stop, info in
                            DispatchQueue.main.async(execute: {
                                progressHandler(progress)
                            })
                        }
                        cloudRequestId = PHImageManager.default().requestPlayerItem(forVideo: anAsset, options: cloudOptions, resultHandler: { playerItem, info in
                            let downloadFinined: Bool = !(setSafeBool(info?[PHImageCancelledKey])) && info?[PHImageErrorKey] == nil && !(setSafeBool(info?[PHImageResultIsDegradedKey]))
                            if downloadFinined && (playerItem != nil) {
                                DispatchQueue.main.async(execute: {
                                    completion(playerItem)
                                })
                            } else {
                                DispatchQueue.main.async(execute: {
                                    failed(info)
                                })
                            }
                        })
                        DispatchQueue.main.async(execute: {
                            startRequestIcloud(cloudRequestId)
                        })
                    } else {
                        DispatchQueue.main.async(execute: {
                            failed(info)
                        })
                    }
                }

            })
        }
        return 0
    }

    
}
