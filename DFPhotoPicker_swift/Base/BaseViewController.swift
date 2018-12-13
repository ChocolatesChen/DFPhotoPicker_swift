//
//  BaseViewController.swift
//  DFPhotoPicker_swift
//
//  Created by cg on 2018/12/13.
//  Copyright © 2018 df. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    ///子类可直接覆盖deinit方法
    deinit {
        print(String(describing: type(of: self))+" deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /***************************************************************/
        ///navbar基本设置
        
        if self.navigationController != nil {
            if self.navigationController!.viewControllers.count > 1 {
                let leftBarItem = UIBarButtonItem.init(image: UIImage.init(named: "返回"), style: .plain, target: self, action: #selector(leftBarAction))
                self.navigationItem.leftBarButtonItem = leftBarItem
            } else if self.navigationController!.viewControllers.count == 1 && self.presentingViewController != nil {
                let leftBarItem = UIBarButtonItem.init(image: UIImage.init(named: "关闭"), style: .plain, target: self, action: #selector(leftBarAction))
                self.navigationItem.leftBarButtonItem = leftBarItem
            }
        }
        
        ///基本设置
        if self.responds(to: #selector(getter: UIViewController.automaticallyAdjustsScrollViewInsets)) {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        view.backgroundColor = kColorBackgroundColor
        //self.view.frame 不用设置，系统会在viewDidLayoutSubviews自动设置
        
        /***************************************************************/
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    ///点击左按钮方法
    @objc func leftBarAction() {
        
        guard let navigationController = self.navigationController else { return }
        
        if self.presentingViewController != nil {
            if navigationController.viewControllers.count == 1 {
                self.dismiss(animated: true, completion: nil)
            } else {
                navigationController.popViewController(animated: true)
            }
        } else {
            if navigationController.viewControllers.count > 1 {
                navigationController.popViewController(animated: true)
            }
        }
    }
    
    ///点击右按钮方法
    @objc func rightBarAction() {}
}
extension BaseViewController {
    ///自定义提示
    
    final func showAlertAction(_ value:String, title:String? = nil,
                               cancelTuple:(String,(()->())?)? = nil,
                               okTuple:(String,(()->())?)? = ("OK",nil),
                               alignment:NSTextAlignment? = .left) {
        DispatchQueue.main.async {
            var theTitle = "Notification"
            if title != nil {
                theTitle = title!
            }
            self.alertAction(words: value, title: theTitle, cancelTuple: cancelTuple, okTuple: okTuple, alignment: alignment)
        }
    }
    
    private func alertAction(words:String, title:String,
                             cancelTuple:(String,(()->())?)? = nil,
                             okTuple:(String,(()->())?)? = nil,
                             alignment:NSTextAlignment? = nil) {
        
        let alertController = UIAlertController.init(title: title, message: words, preferredStyle: .alert)
        
        if let cancelT = cancelTuple {
            let cancelAction = UIAlertAction.init(title: cancelT.0, style: .default) { (alert) in
                if let cc = cancelT.1 {
                    cc()
                }
            }
            alertController.addAction(cancelAction)
        }
        
        if let okT = okTuple {
            let okAction = UIAlertAction.init(title: okT.0, style: .default) { (action) in
                if let ac = okT.1 {
                    ac()
                }
            }
            okAction.setValue(kColorThemeColor, forKey: "titleTextColor")
            alertController.addAction(okAction)
        }
        
        var messageLabel:UILabel!
        let subviews = alertController.view.subviews[0].subviews[0].subviews[0].subviews[0].subviews[0]
        if #available(iOS 12.0, *) {
            messageLabel = subviews.subviews[2] as? UILabel
        }else{
            messageLabel = subviews.subviews[1] as? UILabel
        }
        
        if messageLabel != nil && messageLabel!.text != "" {
            let attributeText = NSMutableAttributedString.init(string: words)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 3
            paragraphStyle.firstLineHeadIndent = 0
            paragraphStyle.paragraphSpacing = 7
            paragraphStyle.lineBreakMode = .byWordWrapping
            attributeText.addAttributes([NSAttributedString.Key.paragraphStyle:paragraphStyle], range: NSMakeRange(0, words.count-1))
            messageLabel!.attributedText = attributeText
            messageLabel!.lineBreakMode = .byWordWrapping
            if alignment != nil {
                messageLabel!.textAlignment = alignment!
            }
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    final func showActionSheet(title:String, message:String? = nil,
                               ac1_title:String, ac1_action:(()->())? = nil,
                               ac2_title:String? = nil, ac2_action:(()->())? = nil,
                               ac3_title:String? = nil, ac3_action:(()->())? = nil) {
        
        DispatchQueue.main.async {
            let actionSheet = UIAlertController.init(title: title, message: message, preferredStyle: .actionSheet)
            let action1 = UIAlertAction.init(title: ac1_title, style: .default) { (action) in
                if let ac1_actionA = ac1_action {
                    ac1_actionA()
                }
            }
            actionSheet.addAction(action1)
            
            if let ac2_titleA = ac2_title {
                let action2 = UIAlertAction.init(title: ac2_titleA, style: .default) { (action) in
                    if let ac2_actionA = ac2_action {
                        ac2_actionA()
                    }
                }
                actionSheet.addAction(action2)
            }
            
            if let ac3_titleA = ac3_title {
                let action3 = UIAlertAction.init(title: ac3_titleA, style: .default) { (action) in
                    if let ac3_actionA = ac3_action {
                        ac3_actionA()
                    }
                }
                actionSheet.addAction(action3)
            }
            
            let action4 = UIAlertAction.init(title: "cancel", style: .cancel) { (action) in
                
            }
            actionSheet.addAction(action4)
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
}
