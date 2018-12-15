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
    /**
     headerSection 半透明毛玻璃效果  默认YES  ios9以上才有效果
     */
    var sectionHeaderTranslucent: Bool?
    
    /**
     导航栏标题颜色是否与主题色同步  默认NO;
     - 同步会过滤掉手动设置的导航栏标题颜色
     */
    var navigationTitleSynchColor: Bool?
    
    /**
     主题颜色  默认 tintColor
     - 改变主题颜色后建议也改下原图按钮的图标
     */
    var themeColor: UIColor?
    
    /**
     原图按钮普通状态下的按钮图标名
     - 改变主题颜色后建议也改下原图按钮的图标
     */
    var originalNormalImageName: String?
    
    /**
     原图按钮选中状态下的按钮图标名
     - 改变主题颜色后建议也改下原图按钮的图标
     */
    var originalSelectedImageName: String?

    
    /**
     是否隐藏原图按钮  默认 NO
     */
    var hideOriginalBtn: Bool?
    
    /**
     sectionHeader 是否显示照片的位置信息 默认 5、6不显示，其余的显示
     */
    var sectionHeaderShowPhotoLocation: Bool?
    
    /**
     相机cell是否显示预览
     屏幕宽  320  ->  NO
     other  ->  YES
     */
    var cameraCellShowPreview: Bool?
    
    /**
     横屏时是否隐藏状态栏 默认显示  暂不支持修改
     */
    //var horizontalHideStatusBar: Bool?
    
    /**
     横屏时相册每行个数  默认6个
     */
    var horizontalRowCount: Int = 0
    
    /**
     是否需要显示日期section  默认YES
     */
    var showDateSectionHeader: Bool?
    
    /**
     照片列表按日期倒序 默认 NO
     */
    var reverseDate: Bool?
    
    // MARK: -  < 基本配置 >
    /**
     相册列表每行多少个照片 默认4个 iphone 4s / 5  默认3个
     */
    var rowCount: Int = 0
    
    /**
     最大选择数 等于 图片最大数 + 视频最大数 默认10 - 必填
     */
    var maxNum: Int = 0
    
    /**
     图片最大选择数 默认9 - 必填
     */
    var photoMaxNum: Int = 0
    
    /**
     视频最大选择数 // 默认1 - 必填
     */
    var videoMaxNum: Int = 0
    
    /**
     是否打开相机功能
     */
    var openCamera: Bool?
    
    /**
     是否开启查看GIF图片功能 - 默认开启
     */
    var lookGifPhoto: Bool?
    
    /**
     是否开启查看LivePhoto功能呢 - 默认 NO
     */
    var lookLivePhoto: Bool?
    
    /**
     图片和视频是否能够同时选择 默认支持
     */
    var selectTogether: Bool?
    
    /**
     相机视频录制最大秒数  -  默认60s
     */
    var videoMaximumDuration: TimeInterval = 0.0
    
    /**
     *  删除临时的照片/视频 -
     注:相机拍摄的照片并没有保存到系统相册 或 是本地图片
     如果当这样的照片都没有被选中时会清空这些照片 有一张选中了就不会删..
     - 默认 NO
     */
    var deleteTemporaryPhoto: Bool?
    
    /**
     *  拍摄的 照片/视频 是否保存到系统相册  默认NO
     *  支持添加到自定义相册 - (需9.0以上)
     */
    var saveSystemAblum: Bool?
    
    /**
     拍摄的照片/视频保存到指定相册的名称  默认 BundleName
     (需9.0以上系统才可以保存到自定义相册 , 以下的系统只保存到相机胶卷...)
     */
    var customAlbumName:String?
    
    /**
     *  视频能选择的最大秒数  -  默认 3分钟/180秒
     */
    var videoMaxDuration: TimeInterval = 0.0
    
    /**
     是否为单选模式 默认 NO
     会自动过滤掉gif、livephoto
     */
    var singleSelected: Bool?
    
    /**
     单选模式下选择图片时是否直接跳转到编辑界面  - 默认 YES
     */
    var singleJumpEdit: Bool?
    
    /**
     是否开启3DTouch预览功能 默认 YES
     */
    var open3DTouchPreview: Bool?
    
    /**
     下载iCloud上的资源  默认YES
     */
    var downloadICloudAsset: Bool?
    
    /**
     是否过滤iCloud上的资源 默认NO
     */
    var filtrationICloudAsset: Bool?
    
    /**
     小图照片清晰度 越大越清晰、越消耗性能
     设置太大的话获取图片资源时耗时长且内存消耗大可能会引起界面卡顿
     default：[UIScreen mainScreen].bounds.size.width
     320    ->  0.8
     375    ->  1.4
     other  ->  1.7
     */
    var clarityScale: CGFloat = 0.0

    // MARK: - < block返回的视图 >
    
    /**
     设置导航栏
     */
    var navigationBar: ((_ navigationBar: UINavigationBar?, _ viewController: UIViewController?) -> Void)?

    /**
     照片列表底部View
     */
    var photoListBottomView: ((_ bottomView: DFDatePhotoBottomView?) -> Void)?

    
    /**
     预览界面底部View
     */
    var previewBottomView: ((_ bottomView: DFDatePhotoPreviewBottomView?) -> Void)?
    
    /**
     相册列表的collectionView
     - 旋转屏幕时也会调用
     */
    var albumListCollectionView: ((_ collectionView: UICollectionView?) -> Void)?

    
    /**
     相册列表的tableView
     - 旋转屏幕时也会调用
     */
    var albumListTableView: ((_ tableView: UITableView?) -> Void)?

    
    /**
     弹窗样式的相册列表
     - 旋转屏幕时也会调用
     */
    var popupAlbumTableView: ((_ tableView: UITableView?) -> Void)?

    
    /**
     相片列表的collectionView
     - 旋转屏幕时也会调用
     */
    var photoListCollectionView: ((_ collectionView: UICollectionView?) -> Void)?

    
    /**
     预览界面的collectionView
     - 旋转屏幕时也会调用
     */
    var previewCollectionView: ((_ collectionView: UICollectionView?) -> Void)?

    
    
    
    // MARK: - < 单例 >
    static let shared = DFPhotoConfiguration()
    private init() {
        setup()
    }
    private func setup(){
        
    }
}
