//
//  UIViewController.swift
//  MosieQi
//
//  Created by Muhammad Shahrukh on 15/09/2022.
//

import Foundation
import UIKit

extension UIViewController {
    var window: UIWindow? {
        if #available(iOS 13, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let delegate = windowScene.delegate as? SceneDelegate, let window = delegate.window else { return nil }
                   return window
        }
        
    }
}
