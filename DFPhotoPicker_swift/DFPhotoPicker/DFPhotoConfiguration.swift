//
//  DFPhotoConfiguration.swift
//  DFPhotoPicker_swift
//
//  Created by cg on 2018/12/13.
//  Copyright © 2018 df. All rights reserved.
//

import Foundation
import UIKit

enum DFPhotoConfigurationCameraType : Int {
    case photo = 0 //!< 拍照
    case video = 1 //!< 录制
    case typePhotoAndVideo //!< 拍照和录制一起
}
enum DFPhotoAlbumShowMode : Int {
    case `default` //!< 默认的
    case popup //!< 弹窗
}
class DFPhotoConfiguration {
    /**
     照片列表是否按照片日期排序  默认YES
     */
    var creationDateSort: Bool?
    
    /**
     相册列表展示方式
     */
    var albumShowMode: DFPhotoAlbumShowMode?
    
    /**
     模型数组保存草稿时存在本地的文件名称 default HXPhotoPickerModelArray
     如果有多个地方保存了草稿请设置不同的fileName
     */
    var localFileName: String?
    
    /**
     只针对 照片、视频不能同时选并且视频只能选择1个的时候隐藏掉视频cell右上角的选择按钮
     */
    var specialModeNeedHideVideoSelectBtn: Bool?
    
    /**
     在照片列表选择照片完后点击完成时是否请求图片
     选中了原图则是原图，没选中则是高清图
     并赋值给model的 thumbPhoto 和 previewPhoto 属性
     */
    var requestImageAfterFinishingSelection: Bool?
    
    /**
     视频是否可以编辑   default NO
     */
    var videoCanEdit: Bool?
    
    /**
     是否替换照片编辑界面   default NO
     */
    var replacePhotoEditViewController: Bool?
    
    /**
     图片编辑完成调用这个block 传入模型
     beforeModel 编辑之前的模型
     afterModel  编辑之后的模型
     */
    var usePhotoEditComplete: ((_ beforeModel: DFPhotoModel?, _ afterModel: DFPhotoModel?) -> Void)?
    
    /**
     是否替换视频编辑界面   default NO
     
     */
    var replaceVideoEditViewController: Bool?
    
    /**
     将要跳转编辑界面 在block内实现跳转
     isOutside 是否是HXPhotoView预览时的编辑
     beforeModel 编辑之前的模型
     */
    var shouldUseEditAsset: ((_ viewController: UIViewController?, _ isOutside: Bool, _ manager: DFPhotoManager?, _ beforeModel: DFPhotoModel?) -> Void)?
    
    /**
     视频编辑完成调用这个block 传入模型
     beforeModel 编辑之前的模型
     afterModel  编辑之后的模型
     */
    var useVideoEditComplete: ((_ beforeModel: DFPhotoModel?, _ afterModel: DFPhotoModel?) -> Void)?
    
    /**
     照片是否可以编辑   default YES
     */
    var photoCanEdit:Bool?

    /**
     过渡动画枚举
     时间函数曲线相关
     UIViewAnimationOptionCurveEaseInOut
     UIViewAnimationOptionCurveEaseIn
     UIViewAnimationOptionCurveEaseOut   -->    default
     UIViewAnimationOptionCurveLinear
     */
    var transitionAnimationOption: UIView.AnimationOptions?
    
    /**
     push动画时长 default 0.45f
     */
    var pushTransitionDuration: TimeInterval = 0.0
    
    /**
     po动画时长 default 0.35f
     */
    var popTransitionDuration: TimeInterval = 0.0
    
    /**
     手势松开时返回的动画时长 default 0.35f
     */
    var popInteractiveTransitionDuration: TimeInterval = 0.0
    
    /**
     是否可移动的裁剪框
     */
    var movableCropBox:Bool?

    /**
     可移动的裁剪框是否可以编辑大小
     */
    var movableCropBoxEditSize:Bool?
    
    /**
     可移动裁剪框的比例 (w,h)
     一定要是宽比高哦!!!
     当 movableCropBox = YES && movableCropBoxEditSize = YES
     如果不设置比例即可自由编辑大小
     */
    var movableCropBoxCustomRatio = CGPoint.zero
    
    /**
     是否替换相机控制器
     使用自己的相机时需要调用下面两个block
     */
    var replaceCameraViewController:Bool?
    
    /**
     将要跳转相机界面 在block内实现跳转
     demo1 里有示例（使用的是系统相机）
     */
    var shouldUseCamera: ((_ viewController: UIViewController?, _ cameraType: DFPhotoConfigurationCameraType, _ manager: DFPhotoManager?) -> Void)?
    
    /**
     相机拍照完成调用这个block 传入模型
     */
    var useCameraComplete: ((_ model: DFPhotoModel?) -> Void)?

    // MARK: - < UI相关 >
    /**
     弹窗方式的相册列表竖屏时的高度
     */
    var popupTableViewHeight: CGFloat = 0.0
    
    /**
     弹窗方式的相册列表横屏时的高度
     */
    var popupTableViewHorizontalHeight: CGFloat = 0.0

    /**
     弹窗方式的相册列表Cell选中的颜色
     */
    var popupTableViewCellSelectColor: UIColor?
    
    /**
     弹窗方式的相册列表Cell底部线的颜色
     */
    var popupTableViewCellLineColor: UIColor?
    
    /**
     弹窗方式的相册列表Cell的背景颜色
     */
    var popupTableViewCellBgColor: UIColor?
    
    /**
     弹窗方式的相册列表Cell上相册名称的颜色
     */
    var popupTableViewCellAlbumNameColor: UIColor?

    /**
     弹窗方式的相册列表Cell上相册名称的字体
     */
    var popupTableViewCellAlbumNameFont: UIFont?

    /**
     弹窗方式的相册列表Cell上照片数量的颜色
     */
    var popupTableViewCellPhotoCountColor: UIColor?

    /**
     弹窗方式的相册列表Cell上照片数量的字体
     */
    var popupTableViewCellPhotoCountFont: UIFont?
    
    /**
     弹窗方式的相册列表Cell的高度
     */
    var popupTableViewCellHeight: CGFloat = 0.0

    /**
     显示底部照片详细信息 default YES
     */
    var showBottomPhotoDetail: Bool?

    
    /**
     完成按钮是否显示详情 default YES
     */
    var doneBtnShowDetail: Bool?
    
    /**
     是否支持旋转  默认YES
     - 如果不需要建议设置成NO
     */
    var supportRotation: Bool?
    
    /**
     状态栏样式 默认 UIStatusBarStyleDefault
     */
    var statusBarStyle: UIStatusBarStyle?
    
    /**
     cell选中时的背景颜色
     */
    var cellSelectedBgColor: UIColor?

    /**
     cell选中时的文字颜色
     */
    var cellSelectedTitleColor: UIColor?

    /**
     选中时数字的颜色
     */
    var selectedTitleColor: UIColor?

    /**
     sectionHeader悬浮时的标题颜色 ios9以上才有效果
     */
    var sectionHeaderSuspensionTitleColor: UIColor?

    /**
     sectionHeader悬浮时的背景色 ios9以上才有效果
     */
    var sectionHeaderSuspensionBgColor: UIColor?

    /**
     导航栏标题颜色
     */
    var navigationTitleColor: UIColor?

    /**
     导航栏背景颜色
     */
    var navBarBackgroudColor: UIColor?

    
    // MARK: - < 单例 >
    static let shared = DFPhotoConfiguration()
    private init() {
        
    }
    private func setup(){
        
    }
}
