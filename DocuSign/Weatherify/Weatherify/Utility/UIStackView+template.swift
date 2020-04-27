//
//  UIStackView+template.swift
//  Weatherify
//
//  Created by Vido Valianto on 4/13/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import UIKit

extension UIStackView {
    convenience init(_ axis: NSLayoutConstraint.Axis = NSLayoutConstraint.Axis.vertical,
                     subviews: [UIView])
    {
        self.init(arrangedSubviews: subviews)
        self.axis = axis
        self.distribution = UIStackView.Distribution.fillEqually
        self.alignment = UIStackView.Alignment.leading
        self.spacing = 1
    }

    convenience init(_ axis: NSLayoutConstraint.Axis = NSLayoutConstraint.Axis.vertical,
                     subviews: [UIView],
                     alignment: UIStackView.Alignment = .leading)
    {
        self.init(arrangedSubviews: subviews)
        self.axis = axis
        self.distribution = UIStackView.Distribution.fillEqually
        self.alignment = alignment
        self.spacing = 1
    }
}
