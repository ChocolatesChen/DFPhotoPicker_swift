//
//  BaseUITableView.swift
//  DFPhotoPicker_swift
//
//  Created by cg on 2018/12/13.
//  Copyright © 2018 df. All rights reserved.
//

import UIKit

class BaseUITableView: UITableView {

    //无论外界调用 init 还是 initwithFrame, 最终都会走initwithFrame方法
    override init(frame: CGRect, style: UITableView.Style) {
        super .init(frame: frame, style: style)
        if #available(iOS 11.0, *) {
            if self.responds(to: #selector(getter: UIScrollView.contentInsetAdjustmentBehavior)){
                self.contentInsetAdjustmentBehavior = .never
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)!
    }

}
