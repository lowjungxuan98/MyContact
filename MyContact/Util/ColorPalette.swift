//
//  ColorPalette.swift
//  MyContact
//
//  Created by Low Jung Xuan on 08/08/2024.
//

import UIKit

class ColorPalette {
    static let shared = ColorPalette()
    
    private init() {}
    
    let blue_0077B6 = UIColor(hex: "#0077B6")
    let blue_96D3F2_10 = UIColor(hex: "#96D3F2").withAlphaComponent(0.2)
    let white_FFFFFF = UIColor(hex: "#FFFFFF")
    let black_000000 = UIColor(hex: "#000000")
    let gray_CCCCCC = UIColor(hex: "#CCCCCC")
    let gray_060326_59 = UIColor(hex: "#060326").withAlphaComponent(0.59)
    let gray_EBEBEB = UIColor(hex: "#EBEBEB")
    let red_ED1C2E = UIColor(hex: "#ED1C2E")
}

// Extension to initialize UIColor with a hex string
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let mask = 0x000000FF
        let r = Int(rgb >> 16) & mask
        let g = Int(rgb >> 8) & mask
        let b = Int(rgb) & mask

        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
