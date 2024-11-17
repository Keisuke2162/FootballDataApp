//
//  UIColor+Extension.swift
//  App
//
//  Created by Kei on 2024/11/15.
//

import UIKit

public extension UIColor {
    convenience init(hex: String) {
        let hexString = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&int)

        let red, green, blue, alpha: CGFloat
        switch hexString.count {
        case 3: // RGB (12-bit)
            (red, green, blue, alpha) = (
                CGFloat((int >> 8) * 17) / 255.0,
                CGFloat((int >> 4 & 0xF) * 17) / 255.0,
                CGFloat((int & 0xF) * 17) / 255.0,
                1.0
            )
        case 6: // RGB (24-bit)
            (red, green, blue, alpha) = (
                CGFloat((int >> 16) & 0xFF) / 255.0,
                CGFloat((int >> 8) & 0xFF) / 255.0,
                CGFloat(int & 0xFF) / 255.0,
                1.0
            )
        case 8: // ARGB (32-bit)
            (red, green, blue, alpha) = (
                CGFloat((int >> 16) & 0xFF) / 255.0,
                CGFloat((int >> 8) & 0xFF) / 255.0,
                CGFloat(int & 0xFF) / 255.0,
                CGFloat((int >> 24) & 0xFF) / 255.0
            )
        default:
            (red, green, blue, alpha) = (1.0, 1.0, 1.0, 1.0) // 無効なコードの場合は白
        }

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
