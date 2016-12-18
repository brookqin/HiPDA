//
//  PromptInformationShowable.swift
//  HiPDA
//
//  Created by leizh007 on 2016/11/3.
//  Copyright © 2016年 HiPDA. All rights reserved.
//

import Foundation
import MBProgressHUD

/// ProgressHUD的样式
///
/// - loading: 正在加载
/// - success: 成功
/// - failure: 失败
enum ProgressHUDStyle {
    case loading
    case success(String)
    case failure(String)
}

protocol PromptInformationShowable {
    /// 展示提示信息
    ///
    /// - parameter style: 提示信息的样式
    func showPromptInformation(of style: ProgressHUDStyle);
    
    /// 隐藏提示信息
    func hidePromptInformation();
}

extension PromptInformationShowable where Self: UIViewController {
    /// 展示提示信息
    ///
    /// - parameter style: 提示信息的样式
    func showPromptInformation(of style: ProgressHUDStyle) {
        let hud = MBProgressHUD.showAdded(to: ancestor.view, animated: true)
        hud.bezelView.style = .solidColor
        hud.bezelView.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8)
        hud.backgroundView.style = .solidColor
        hud.backgroundView.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)
        hud.contentColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        hud.label.numberOfLines = 0
        
        func custom(of hud: MBProgressHUD, with image: UIImage, title: String, delay: TimeInterval) {
            hud.mode = .customView
            hud.label.text = title
            hud.customView = UIImageView(image: image)
            hud.hide(animated: true, afterDelay: delay)
        }
        
        switch style {
        case .loading:
            hud.label.text = "正在加载..."
        case .success(let value):
            custom(of: hud, with: #imageLiteral(resourceName: "hud_success"), title: value, delay: 1.0)
        case .failure(let value):
            custom(of: hud, with: #imageLiteral(resourceName: "hud_failure"), title: value, delay: 2.0)
        }
    }
    
    /// 隐藏提示信息
    func hidePromptInformation() {
        MBProgressHUD.hide(for: ancestor.view, animated: true)
    }
}

extension UIViewController: PromptInformationShowable {

}