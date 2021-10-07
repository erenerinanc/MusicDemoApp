//
//  UINavigationController+Ext.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 7.10.2021.
//

import Foundation
import UIKit

extension UINavigationController {
    func pushViewControllerFromLeft(controller: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = .push
        transition.subtype = .fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)
        pushViewController(controller, animated: true)
    }
}
