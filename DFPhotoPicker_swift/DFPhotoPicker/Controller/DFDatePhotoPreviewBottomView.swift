//
//  DFDatePhotoPreviewBottomView.swift
//  DFPhotoPicker_swift
//
//  Created by cg on 2018/12/14.
//  Copyright © 2018 df. All rights reserved.
//

import UIKit

protocol DFDatePhotoPreviewBottomViewDelegate: NSObjectProtocol {
    func datePhotoPreviewBottomViewDidItem(_ model: DFPhotoModel?, currentIndex: Int, before beforeIndex: Int)
    func datePhotoPreviewBottomViewDidDone(_ bottomView: DFDatePhotoPreviewBottomView?)
    func datePhotoPreviewBottomViewDidEdit(_ bottomView: DFDatePhotoPreviewBottomView?)
}

class DFDatePhotoPreviewBottomView: UIView {

    var bgView: UIToolbar?
    weak var delagate: DFDatePhotoPreviewBottomViewDelegate?
    var modelArray:NSMutableArray?
    var selectCount: Int = 0
    var currentIndex: Int = 0
    var hideEditBtn = false
    var enabled = false
    var outside = false
    var tipView: UIToolbar?
    var tipLb: UILabel?
    var showTipView = false
    var tipStr = ""


}

class DFDatePhotoPreviewBottomViewCell: UICollectionViewCell {
    var model: DFPhotoModel?
    var selectColor: UIColor?
    
    func cancelRequest() {
    }
}
