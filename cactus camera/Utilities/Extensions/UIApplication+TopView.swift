//
//  UIApplication+TopView.swift
//  CactusCamera
//
//  Created by GK Naidu on 01/11/25.
//

import UIKit

extension UIApplication {
    var topMostViewController: UIViewController? {
        guard let windowScene = connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }),
              let window = windowScene.windows.first(where: { $0.isKeyWindow }),
              var top = window.rootViewController
        else {
            return nil
        }

        while let presented = top.presentedViewController {
            top = presented
        }

        if let nav = top as? UINavigationController {
            return nav.visibleViewController ?? nav.topViewController
        }

        if let tab = top as? UITabBarController {
            return tab.selectedViewController
        }

        return top
    }
}
