//
//  Theme.swift
//  Weatherify
//
//  Created by Vido Valianto on 4/27/20.
//  Copyright © 2020 Vido Valianto. All rights reserved.
//

import UIKit

public enum FontSection {
    case title
    case subTitle
    case footer
    case barTitle
    case barBody
    case desc
}

public func appFont(section: FontSection) -> UIFont {
    var font: String
    var size: CGFloat
    var fontTextStyle: UIFont.TextStyle

    switch section {
    case .title:
        font = "AvenirNext-Bold"
        size = 20
        fontTextStyle = .title1
    case .subTitle:
        font = "Avenir-Light"
        size = 14
        fontTextStyle = .title2
    case .footer:
        font = "AvenirNext-Bold"
        size = 14
        fontTextStyle = .footnote
    case .barTitle:
        font = "Avenir-Light"
        size = 8
        fontTextStyle = .caption1
    case .barBody:
        font = "AvenirNext-Bold"
        size = 12
        fontTextStyle = .caption2
    case .desc:
        font = "Avenir-Light"
        size = 14
        fontTextStyle = .title2
    }

    let fontSize = UIFontMetrics(forTextStyle: fontTextStyle).scaledValue(for: size)
    guard let fontUse = UIFont(name: font, size: fontSize) else {
        return UIFont.systemFont(ofSize: fontSize)
    }
    return fontUse
}
