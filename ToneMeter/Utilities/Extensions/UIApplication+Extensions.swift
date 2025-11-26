//
//  UIApplication+Extensions.swift
//  ToneMeter
//
//  Created by 송형욱 on 11/26/25.
//

import UIKit

extension UIApplication {
  var rootViewController: UIViewController? {
    guard let windowScene = connectedScenes.first as? UIWindowScene,
          let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
      return nil
    }
    
    return findTopViewController(controller: window.rootViewController)
  }
  
  private func findTopViewController(controller: UIViewController?) -> UIViewController? {
    if let navigationController = controller as? UINavigationController {
      return findTopViewController(controller: navigationController.visibleViewController)
    }
    
    if let tabController = controller as? UITabBarController {
      if let selected = tabController.selectedViewController {
        return findTopViewController(controller: selected)
      }
    }
    
    if let presented = controller?.presentedViewController {
      return findTopViewController(controller: presented)
    }
    
    return controller
  }
}

