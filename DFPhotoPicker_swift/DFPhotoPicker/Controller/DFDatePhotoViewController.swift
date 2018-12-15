//
//  DFDatePhotoViewController.swift
//  DFPhotoPicker_swift
//
//  Created by cg on 2018/12/14.
//  Copyright © 2018 df. All rights reserved.
//

import UIKit
import Photos

protocol DFDatePhotoViewControllerDelegate: NSObjectProtocol {
    
    /**
     点击取消
     
     @param datePhotoViewController self
     */
    func datePhotoViewControllerDidCancel(_ datePhotoViewController: DFDatePhotoViewController?)

    /**
     点击完成时获取图片image完成后的回调
     选中了原图返回的就是原图
     需 requestImageAfterFinishingSelection = YES 才会有回调
     
     @param datePhotoViewController self
     @param imageList 图片数组
     */
    func datePhotoViewController(_ datePhotoViewController: DFDatePhotoViewController?,
                                 didDoneAllImage imageList: [UIImage]?,
                                 original: Bool)
    
    func datePhotoViewController(_ datePhotoViewController: DFDatePhotoViewController?,
                                 allAssetList: [PHAsset]?,
                                 photoAssets photoAssetList: [PHAsset]?,
                                 videoAssets videoAssetList: [PHAsset]?,
                                 original: Bool)

    /**
     点击完成按钮
     
     @param datePhotoViewController self
     @param allList 已选的所有列表(包含照片、视频)
     @param photoList 已选的照片列表
     @param videoList 已选的视频列表
     @param original 是否原图
     */
    func datePhotoViewController(_ datePhotoViewController: DFDatePhotoViewController?,
                                 didDoneAllList allList: [DFPhotoModel]?,
                                 photos photoList: [DFPhotoModel]?,
                                 videos videoList: [DFPhotoModel]?,
                                 original: Bool)

    /**
     改变了选择
     
     @param model 改的模型
     @param selected 是否选中
     */
    func datePhotoViewControllerDidChangeSelect(_ model: DFPhotoModel?, selected: Bool)

    
}

class DFDatePhotoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


@objc protocol DFDatePhotoBottomViewDelegate: NSObjectProtocol {
    func datePhotoBottomViewDidPreviewBtn()
    func datePhotoBottomViewDidDoneBtn()
    func datePhotoBottomViewDidEditBtn()
}
class DFDatePhotoBottomView : UIView {
    
    weak var delegate: DFDatePhotoBottomViewDelegate?
    var manager: DFPhotoManager?
    var previewBtnEnabled = false
    var doneBtnEnabled = false
    var selectCount: Int = 0
    var originalBtn: UIButton?
    var bgView: UIToolbar?

    
}
