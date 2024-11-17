//
//  Color+Extension.swift
//  App
//
//  Created by Kei on 2024/11/15.
//

import SwiftUI

extension Color {
  public init(hexValue: String) {
    let hex = hexValue.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int: UInt64 = 0
    Scanner(string: hex).scanHexInt64(&int)
    
    let red, green, blue, alpha: Double
    switch hex.count {
    case 3:
      (red, green, blue, alpha) = (
        Double((int >> 8) * 17) / 255.0,
        Double((int >> 4 & 0xF) * 17) / 255.0,
        Double((int & 0xF) * 17) / 255.0,
        1.0
      )
    case 6:
      (red, green, blue, alpha) = (
        Double((int >> 16) & 0xFF) / 255.0,
        Double((int >> 8) & 0xFF) / 255.0,
        Double(int & 0xFF) / 255.0,
        1.0
      )
    case 8:
      (red, green, blue, alpha) = (
        Double((int >> 16) & 0xFF) / 255.0,
        Double((int >> 8) & 0xFF) / 255.0,
        Double(int & 0xFF) / 255.0,
        Double((int >> 24) & 0xFF) / 255.0
      )
    default:
      (red, green, blue, alpha) = (1.0, 1.0, 1.0, 1.0)
    }
    
    self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
  }

  public var foregroundColor: Color {
    let uiColor = UIColor(self)
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0
    uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
  
    let luminance = 0.2126 * red + 0.7152 * green + 0.0722 * blue

    return luminance > 0.5 ? .black : .white
  }
}
