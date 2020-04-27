//
//  UIViewController+presentOnRoot.swift
//  Weatherify
//
//  Created by Vido Valianto on 4/27/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentOnRoot(`with` viewController : UIViewController){
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(navigationController, animated: false, completion: nil)
    }
}
