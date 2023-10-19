//
//  Extensions.swift
//  quick-reminder
//
//  Created by Seigetsu on 2023/09/14.
//

import UIKit

extension UIColor {
    public struct my {
        public static let primaryBackground = UIColor.systemBackground
        public static let secondaryBackground = UIColor.systemGray5
        public static let textFieldBackground = UIColor.dynamicColor(light: .white, dark: .systemGray3)
    }
    
    /// ライト/ダークモード用の色を受け取ってDynamic Colorを生成する。
    public static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        UIColor { traitCollection -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:
                light
            case .dark:
                dark
            @unknown default:
                light
            }
        }
    }
}
