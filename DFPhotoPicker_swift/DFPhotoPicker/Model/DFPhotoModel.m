//
//  DFPhotoModel.m
//  DFPhotoPicker_swift
//
//  Created by cf on 17/2/8.
//  Copyright © 2018年 df. All rights reserved.
//

#import "DFPhotoModel.h"
#import "DFPhotoPicker_swift-Swift.h"
#import "UIImage+Extension.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation DFPhotoModel

- (NSURL *)fileURL {
    if (self.type == DFPhotoModelMediaTypeCameraVideo && !_fileURL) {
        _fileURL = self.videoURL;
    }
    if (self.type != DFPhotoModelMediaTypeCameraPhoto) {
        if (self.asset && !_fileURL) {
            _fileURL = [self.asset valueForKey:@"mainFileURL"];
        }
    }
    return _fileURL;
}

- (NSDate *)creationDate {
    if (self.type == DFPhotoModelMediaTypeCameraPhoto || self.type == DFPhotoModelMediaTypeCameraVideo) {
        return _creationDate ?: [NSDate date];
    }
    if (!_creationDate) {
        _creationDate = [self.asset valueForKey:@"creationDate"];
    }
    return _creationDate;
}

- (NSDate *)modificationDate {
    if (self.type == DFPhotoModelMediaTypeCameraPhoto || self.type == DFPhotoModelMediaTypeCameraVideo) {
        if (!_modificationDate) {
            _modificationDate = [NSDate date];
        }
    }
    if (!_modificationDate) {
        _modificationDate = [self.asset valueForKey:@"modificationDate"];
    }
    return _modificationDate;
}

- (NSData *)locationData {
    if (!_locationData) {
        if (self.asset) {
            _locationData = [self.asset valueForKey:@"locationData"];
        }
    }
    return _locationData;
}

- (CLLocation *)location {
    if (!_location) {
        if (self.asset) {
            _location = [self.asset valueForKey:@"location"];
        }
    }
    return _location;
}

- (NSString *)localIdentifier {
    if (self.asset) {
        return self.asset.localIdentifier;
    }
    return _localIdentifier;
}

+ (instancetype)photoModelWithPHAsset:(PHAsset *)asset {
    return [[self alloc] initWithPHAsset:asset];
}

+ (instancetype)photoModelWithImage:(UIImage *)image {
    return [[self alloc] initWithImage:image];
}

+ (instancetype)photoModelWithImageURL:(NSURL *)imageURL {
    return [[self alloc] initWithImageURL:imageURL thumbURL:imageURL];
}

+ (instancetype)photoModelWithVideoURL:(NSURL *)videoURL videoTime:(NSTimeInterval)videoTime {
    return [[self alloc] initWithVideoURL:videoURL videoTime:videoTime];
}

+ (instancetype)photoModelWithVideoURL:(NSURL *)videoURL {
    return [[self alloc] initWithVideoURL:videoURL];
}

+ (instancetype)photoModelWithImageURL:(NSURL *)imageURL thumbURL:(NSURL *)thumbURL {
    return [[self alloc] initWithImageURL:imageURL thumbURL:thumbURL];
}
- (instancetype)initWithImageURL:(NSURL *)imageURL thumbURL:(NSURL *)thumbURL  {
    if (self = [super init]) {
        self.type = DFPhotoModelMediaTypeCameraPhoto;
        self.subType = DFPhotoModelMediaSubTypePhoto;
        self.thumbPhoto = [DFPhotoTools df_imageNamed:@"df_qz_photolist_picture_fail@2x.png"];
        self.previewPhoto = self.thumbPhoto;
        self.imageSize = self.thumbPhoto.size;
        if (!imageURL && thumbURL) {
            imageURL = thumbURL;
        }else if (imageURL && !thumbURL) {
            thumbURL = imageURL;
        }
        self.networkPhotoUrl = imageURL;
        self.networkThumbURL = thumbURL;
        if (imageURL == thumbURL ||
            [imageURL.absoluteString isEqualToString:thumbURL.absoluteString]) {
            self.loadOriginalImage = YES;
        }
    }
    return self;
}

- (instancetype)initWithPHAsset:(PHAsset *)asset{
    if (self = [super init]) {
        self.asset = asset;
        self.type = DFPhotoModelMediaTypePhoto;
        self.subType = DFPhotoModelMediaSubTypePhoto;
    }
    return self;
}

- (void)setPhotoManager:(DFPhotoManager *)photoManager {
    _photoManager = photoManager;
    if (self.asset.mediaType == PHAssetMediaTypeImage) {
        self.subType = DFPhotoModelMediaSubTypePhoto;
        if ([[self.asset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
            if (photoManager.configuration.singleSelected) {
                self.type = DFPhotoModelMediaTypePhoto;
            }else {
                self.type = photoManager.configuration.lookGifPhoto ? DFPhotoModelMediaTypePhotoGif : DFPhotoModelMediaTypePhoto;
            }
        }else if (self.asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive){
            if (iOS9Later) {
                if (!photoManager.configuration.singleSelected) {
                    self.type = photoManager.configuration.lookLivePhoto ? DFPhotoModelMediaTypeLivePhoto : DFPhotoModelMediaTypePhoto;
                }else {
                    self.type = DFPhotoModelMediaTypePhoto;
                }
            }else {
                self.type = DFPhotoModelMediaTypePhoto;
            }
        }else {
            self.type = DFPhotoModelMediaTypePhoto;
        }
    }else if (self.asset.mediaType == PHAssetMediaTypeVideo) {
        self.type = DFPhotoModelMediaTypeVideo;
        self.subType = DFPhotoModelMediaSubTypeVideo;
    }
}

- (instancetype)initWithVideoURL:(NSURL *)videoURL {
    if (self = [super init]) {
        self.type = DFPhotoModelMediaTypeCameraVideo;
        self.subType = DFPhotoModelMediaSubTypeVideo;
        self.videoURL = videoURL; 
        UIImage  *image = [DFPhotoTools thumbnailImageForVideo:videoURL atTime:0.1f];
        NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                         forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:videoURL options:opts];
        float second = 0;
        second = urlAsset.duration.value/urlAsset.duration.timescale;
        
        NSString *time = [DFPhotoTools getNewTimeFromDurationSecond:second];
        self.videoDuration = second;
        self.videoURL = videoURL;
        self.videoTime = time;
        self.thumbPhoto = image;
        self.previewPhoto = image;
        self.imageSize = self.thumbPhoto.size;
    }
    return self;
}
- (instancetype)initWithVideoURL:(NSURL *)videoURL videoTime:(NSTimeInterval)videoTime {
    if (self = [super init]) {
        self.type = DFPhotoModelMediaTypeCameraVideo;
        self.subType = DFPhotoModelMediaSubTypeVideo;
        self.videoURL = videoURL;
        if (videoTime <= 0) {
            videoTime = 1;
        }
        UIImage  *image = [DFPhotoTools thumbnailImageForVideo:videoURL atTime:0.1f];
        NSString *time = [DFPhotoTools getNewTimeFromDurationSecond:videoTime];
        self.videoDuration = videoTime;
        self.videoURL = videoURL;
        self.videoTime = time;
        self.thumbPhoto = image;
        self.previewPhoto = image;
        self.imageSize = self.thumbPhoto.size;
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        self.type = DFPhotoModelMediaTypeCameraPhoto;
        self.subType = DFPhotoModelMediaSubTypePhoto;
        if (image.imageOrientation != UIImageOrientationUp) {
            image = [image normalizedImage];
        }
        self.thumbPhoto = image;
        self.previewPhoto = image;
        self.imageSize = image.size;
    }
    return self;
}

- (CGSize)imageSize
{
    if (_imageSize.width == 0 || _imageSize.height == 0) {
        if (self.asset) {
            if (self.asset.pixelWidth == 0 || self.asset.pixelHeight == 0) {
                _imageSize = CGSizeMake(200, 200);
            }else {
                _imageSize = CGSizeMake(self.asset.pixelWidth, self.asset.pixelHeight);
            }
        }else {
            _imageSize = self.thumbPhoto.size;
        }
    }
    return _imageSize;
}
- (NSString *)videoTime {
    if (!_videoTime) {
        NSString *timeLength = [NSString stringWithFormat:@"%0.0f",self.asset.duration];
        _videoTime = [DFPhotoTools getNewTimeFromDurationSecond:timeLength.integerValue];
    }
    return _videoTime;
}
- (CGSize)endImageSize
{
    if (_endImageSize.width == 0 || _endImageSize.height == 0) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height - kSystemNavigationBarHeight;
        CGFloat imgWidth = self.imageSize.width;
        CGFloat imgHeight = self.imageSize.height;
        CGFloat w;
        CGFloat h;
        imgHeight = width / imgWidth * imgHeight;
        if (imgHeight > height) {
            w = height / self.imageSize.height * imgWidth;
            h = height;
        }else {
            w = width;
            h = imgHeight;
        }
        if (w == NAN) {
            w = 0;
        }
        if (h == NAN) {
            h = 0;
        }
        _endImageSize = CGSizeMake(w, h);
    }
    return _endImageSize;
}
- (CGSize)previewViewSize {
    if (_previewViewSize.width == 0 || _previewViewSize.height == 0) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        CGFloat imgWidth = self.imageSize.width;
        CGFloat imgHeight = self.imageSize.height;
        CGFloat w;
        CGFloat h;
        
        if (imgWidth > width) {
            h = width / self.imageSize.width * imgHeight;
            w = width;
        }else {
            w = width;
            h = width / imgWidth * imgHeight;
        }
        if (h > height + 20) {
            h = height;
        }
        _previewViewSize = CGSizeMake(w, h);
    }
    return _previewViewSize;
}
- (CGSize)endDateImageSize {
    if (_endDateImageSize.width == 0 || _endDateImageSize.height == 0) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
//        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
//        if (orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft){
//            if (kDevice_iPhoneX_Series) {
//                height = [UIScreen mainScreen].bounds.size.height - kSystemTopMargin - 21;
//            }
//        }
        CGFloat imgWidth = self.imageSize.width;
        CGFloat imgHeight = self.imageSize.height;
        CGFloat w;
        CGFloat h;
        imgHeight = width / imgWidth * imgHeight;
        if (imgHeight > height) {
            w = height / self.imageSize.height * imgWidth;
            h = height;
        }else {
            w = width;
            h = imgHeight;
        }
        _endDateImageSize = CGSizeMake(w, h);
    }
    return _endDateImageSize;
}
- (CGSize)requestSize {
    if (_requestSize.width == 0 || _requestSize.height == 0) {
        CGFloat width = ([UIScreen mainScreen].bounds.size.width - 1 * self.rowCount - 1 ) / self.rowCount;
        CGSize size = CGSizeMake(width * self.clarityScale, width * self.clarityScale);
        _requestSize = size;
    }
    return _requestSize;
}
- (CGSize)dateBottomImageSize {
    if (_dateBottomImageSize.width == 0 || _dateBottomImageSize.height == 0) {
        CGFloat width = 0;
        CGFloat height = 50;
        CGFloat imgWidth = self.imageSize.width;
        CGFloat imgHeight = self.imageSize.height;
        if (imgHeight > height) {
            width = imgWidth * (height / imgHeight);
        }else {
            width = imgWidth * (imgHeight / height);
        }
        if (width < 50 / 16 * 9) {
            width = 50 / 16 * 9;
        }
        _dateBottomImageSize = CGSizeMake(width, height);
    }
    return _dateBottomImageSize;
}
- (NSString *)barTitle {
    if (!_barTitle) {
        NSString *language = [NSLocale preferredLanguages].firstObject;
        if ([self.creationDate isToday]) {
            _barTitle = [NSBundle df_localizedStringForKey:@"今天"];
        }else if ([self.creationDate isYesterday]) {
            _barTitle = [NSBundle df_localizedStringForKey:@"昨天"];
        }else if ([self.creationDate isSameWeek]) {
            _barTitle = [self.creationDate getNowWeekday];
        }else if ([self.creationDate isThisYear]) {
            if ([language hasPrefix:@"en"]) {
                // 英文
                _barTitle = [NSString stringWithFormat:@"%@ %@",[self.creationDate dateStringWithFormat:@"MMM dd"],[self.creationDate getNowWeekday]];
            } else if ([language hasPrefix:@"zh"]) {
                // 中文
                _barTitle = [NSString stringWithFormat:@"%@ %@",[self.creationDate dateStringWithFormat:@"MM月dd日"],[self.creationDate getNowWeekday]];
                
            }else if ([language hasPrefix:@"ko"]) {
                // 韩语
                _barTitle = [NSString stringWithFormat:@"%@ %@",[self.creationDate dateStringWithFormat:@"MM월dd일"],[self.creationDate getNowWeekday]];
            }else if ([language hasPrefix:@"ja"]) {
                // 日语
                _barTitle = [NSString stringWithFormat:@"%@ %@",[self.creationDate dateStringWithFormat:@"MM月dd日"],[self.creationDate getNowWeekday]];
            }else {
                // 英文
                _barTitle = [NSString stringWithFormat:@"%@ %@",[self.creationDate dateStringWithFormat:@"MMM dd"],[self.creationDate getNowWeekday]];
            }
        }else {
            if ([language hasPrefix:@"en"]) {
                // 英文
                _barTitle = [self.creationDate dateStringWithFormat:@"MMM dd, yyyy"];
            } else if ([language hasPrefix:@"zh"]) {
                // 中文
                _barTitle = [self.creationDate dateStringWithFormat:@"yyyy年MM月dd日"];
                
            }else if ([language hasPrefix:@"ko"]) {
                // 韩语
                _barTitle = [self.creationDate dateStringWithFormat:@"yyyy년MM월dd일"];
            }else if ([language hasPrefix:@"ja"]) {
                // 日语
                _barTitle = [self.creationDate dateStringWithFormat:@"yyyy年MM月dd日"];
            }else {
                // 其他
                _barTitle = [self.creationDate dateStringWithFormat:@"MMM dd, yyyy"];
            }
        }
    }
    return _barTitle;
}
- (NSString *)barSubTitle {
    if (!_barSubTitle) {
        _barSubTitle = [self.creationDate dateStringWithFormat:@"HH:mm"];
    }
    return _barSubTitle;
}
- (void)dealloc {
    if (self.iCloudRequestID) {
        if (self.iCloudDownloading) {
            [[PHImageManager defaultManager] cancelImageRequest:self.iCloudRequestID];
        }
    }
//    [self cancelImageRequest];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.type = [aDecoder decodeIntegerForKey:@"type"];
        self.subType = [aDecoder decodeIntegerForKey:@"subType"];
        if (self.type == DFPhotoModelMediaTypeCameraPhoto ||
            self.type == DFPhotoModelMediaTypeCameraVideo) {
            self.thumbPhoto = [aDecoder decodeObjectForKey:@"thumbPhoto"];
            self.previewPhoto = [aDecoder decodeObjectForKey:@"previewPhoto"];
        }
        self.localIdentifier = [aDecoder decodeObjectForKey:@"localIdentifier"];
        self.videoDuration = [aDecoder decodeFloatForKey:@"videoDuration"];
        self.selected = [aDecoder decodeBoolForKey:@"selected"];
        self.videoURL = [aDecoder decodeObjectForKey:@"videoURL"];
        self.networkPhotoUrl = [aDecoder decodeObjectForKey:@"networkPhotoUrl"];
        self.networkThumbURL = [aDecoder decodeObjectForKey:@"networkThumbURL"];
        self.creationDate = [aDecoder decodeObjectForKey:@"creationDate"];
        self.modificationDate = [aDecoder decodeObjectForKey:@"modificationDate"];
        self.locationData = [aDecoder decodeObjectForKey:@"locationData"];
        self.location = [aDecoder decodeObjectForKey:@"location"];
        self.videoTime = [aDecoder decodeObjectForKey:@"videoTime"];
        self.selectIndexStr = [aDecoder decodeObjectForKey:@"videoTime"];
        self.cameraIdentifier = [aDecoder decodeObjectForKey:@"cameraIdentifier"];
        self.fileURL = [aDecoder decodeObjectForKey:@"fileURL"];
        self.gifImageData = [aDecoder decodeObjectForKey:@"gifImageData"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    if (self.type == DFPhotoModelMediaTypeCameraPhoto ||
        self.type == DFPhotoModelMediaTypeCameraVideo) {
        [aCoder encodeObject:self.thumbPhoto forKey:@"thumbPhoto"];
        [aCoder encodeObject:self.previewPhoto forKey:@"previewPhoto"];
    }
    [aCoder encodeObject:self.localIdentifier forKey:@"localIdentifier"];
    [aCoder encodeInteger:self.type forKey:@"type"];
    [aCoder encodeInteger:self.subType forKey:@"subType"];
    [aCoder encodeFloat:self.videoDuration forKey:@"videoDuration"];
    [aCoder encodeBool:self.selected forKey:@"selected"];
    [aCoder encodeObject:self.videoURL forKey:@"videoURL"];
    [aCoder encodeObject:self.networkPhotoUrl forKey:@"networkPhotoUrl"];
    [aCoder encodeObject:self.networkThumbURL forKey:@"networkThumbURL"];
    [aCoder encodeObject:self.creationDate forKey:@"creationDate"];
    [aCoder encodeObject:self.modificationDate forKey:@"modificationDate"];
    [aCoder encodeObject:self.locationData forKey:@"locationData"];
    [aCoder encodeObject:self.location forKey:@"location"];
    [aCoder encodeObject:self.videoTime forKey:@"videoTime"];
    [aCoder encodeObject:self.selectIndexStr forKey:@"selectIndexStr"];
    [aCoder encodeObject:self.cameraIdentifier forKey:@"cameraIdentifier"];
    [aCoder encodeObject:self.fileURL forKey:@"fileURL"];
    [aCoder encodeObject:self.gifImageData forKey:@"gifImageData"]; 
}

@end

@implementation DFPhotoDateModel
- (NSString *)dateString {
    if (!_dateString) {
        
        NSString *language = [NSLocale preferredLanguages].firstObject;
        if ([self.date isToday]) {
            _dateString = [NSBundle df_localizedStringForKey:@"今天"];
        }else if ([self.date isYesterday]) {
            _dateString = [NSBundle df_localizedStringForKey:@"昨天"];
        }else if ([self.date isSameWeek]) {
            _dateString = [self.date getNowWeekday];
        }else if ([self.date isThisYear]) {
            if ([language hasPrefix:@"en"]) {
                // 英文
                _dateString = [NSString stringWithFormat:@"%@ %@",[self.date dateStringWithFormat:@"MMM dd"],[self.date getNowWeekday]];
            } else if ([language hasPrefix:@"zh"]) {
                // 中文
                _dateString = [NSString stringWithFormat:@"%@ %@",[self.date dateStringWithFormat:@"MM月dd日"],[self.date getNowWeekday]];
            } else {
                // 英文
                _dateString = [NSString stringWithFormat:@"%@ %@",[self.date dateStringWithFormat:@"MMM dd"],[self.date getNowWeekday]];
            }
        }else {
            if ([language hasPrefix:@"en"]) {
                // 英文
                _dateString = [self.date dateStringWithFormat:@"MMMM dd, yyyy"];
            } else if ([language hasPrefix:@"zh"]) {
                // 中文
                _dateString = [self.date dateStringWithFormat:@"yyyy年MM月dd日"];
            } else {
                // 其他
                _dateString = [self.date dateStringWithFormat:@"MMMM dd, yyyy"];
            } 
        }
    }
    return _dateString;
}
- (NSMutableArray *)locationList {
    if (!_locationList) {
        _locationList = [NSMutableArray array];
    }
    return _locationList;
}

@end
