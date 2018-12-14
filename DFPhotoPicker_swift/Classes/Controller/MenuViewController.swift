//
//  MenuViewController.swift
//  DFPhotoPicker_swift
//
//  Created by cg on 2018/12/13.
//  Copyright © 2018 df. All rights reserved.
//

import UIKit

class MenuViewController: BaseViewController {
    fileprivate let kCellIdentifier = "cell_identifier"
    var dataSource: [Any] = []
    
    private lazy var mainTableview = getMainTableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavMidLabel(text: "PhotoMenus")
        createList()
        self.view.addSubview(mainTableview)
        
        mainTableview.frame = CGRect(x: 0, y: kSystemNavigationBarHeight, width: kScreenWidth, height: kScreenHeight - kSystemNavigationBarHeight)
    }
    func createList(){
        if dataSource.count == 0 {
            dataSource = [ListItem(title: "Demo1", subTitle: "只使用照片选择器功能,不带选好后自动布局(可扩展)", viewControllClass: CustomViewController.self),
                    ListItem(title: "Demo2", subTitle: "使用照片选择器功能并且选好后自动布局", viewControllClass: CustomViewController.self),
                    ListItem(title: "Demo3", subTitle: "附带网络照片功能", viewControllClass: CustomViewController.self),
                    ListItem(title: "Demo4", subTitle: "单选样式支持裁剪", viewControllClass: CustomViewController.self),
                    ListItem(title: "Demo5", subTitle: "同个界面多个选择器", viewControllClass: CustomViewController.self),
                    ListItem(title: "Demo6", subTitle: "拍照/选择照片完之后跳界面", viewControllClass: CustomViewController.self),
                    ListItem(title: "Demo7", subTitle: "传入本地image/video并展示", viewControllClass: CustomViewController.self),
                    ListItem(title: "Demo8", subTitle: "将已选模型(图片和视频)写入临时目录  一键写入^_^", viewControllClass: CustomViewController.self),
                    ListItem(title: "Demo9", subTitle: "cell上添加photoView(附带3DTouch预览)", viewControllClass: CustomViewController.self),
                    ListItem(title: "Demo10", subTitle: "保存草稿功能", viewControllClass: CustomViewController.self),
                    ListItem(title: "Demo11", subTitle: "xib上使用HXPhotoView", viewControllClass: CustomViewController.self),
                    ListItem(title: "Demo12", subTitle: "混合添加资源", viewControllClass: CustomViewController.self),
                    ListItem(title: "Demo13", subTitle: "嵌套其他第三方图片/视频编辑库", viewControllClass: CustomViewController.self)]
        }
    }


}

// MARK: - createUI
extension MenuViewController {
    func getMainTableView() -> BaseUITableView {
        let tb = BaseUITableView.init(frame: .zero, style: .plain)
        tb.separatorStyle = .none
        tb.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleWidth.rawValue | UIView.AutoresizingMask.flexibleHeight.rawValue)
        tb.delegate = self
        tb.dataSource = self
        tb.showsVerticalScrollIndicator = false
        tb.showsHorizontalScrollIndicator = false
        tb.rowHeight = 70
        tb.bounces = false
        
        return tb
    }
}

extension MenuViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: kCellIdentifier)
            cell?.detailTextLabel?.numberOfLines = 0
            cell?.detailTextLabel?.textColor = UIColor.gray
        }
        let item = self.dataSource[indexPath.row] as! ListItem
        cell?.textLabel?.text = item.title
        cell?.detailTextLabel?.text = item.subTitle
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.dataSource[indexPath.row] as! ListItem
        
        if item.viewControllClass is BaseViewController.Type {
            let vc = (item.viewControllClass as! BaseViewController.Type).init()
            vc.setNavMidLabel(text: item.title)
            navigationController?.pushViewController(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
class ListItem: NSObject {
    var title = ""
    var subTitle = ""
    var viewControllClass: AnyClass?

    convenience init(title: String?, subTitle: String?, viewControllClass `class`: AnyClass) {
        self.init()
        
        self.title = title ?? ""
        self.subTitle = subTitle ?? ""
        viewControllClass = `class`
        
    }


}
