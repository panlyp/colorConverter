//
//  ColorExtensions.swift
//  ColorConverter
//
//  Created by user on 29/10/2020.
//

import SwiftUI
import AppKit

extension Color {
    var redComponent: Int? {
        let val = description
        guard val.hasPrefix("#") else { return nil }
        let r1 = val.index(val.startIndex, offsetBy: 1)
        let r2 = val.index(val.startIndex, offsetBy: 2)
        return Int(val[r1...r2], radix: 16) ?? -1
    }

    var greenComponent: Int? {
        let val = description
        guard val.hasPrefix("#") else { return nil }
        let g1 = val.index(val.startIndex, offsetBy: 3)
        let g2 = val.index(val.startIndex, offsetBy: 4)
        return Int(val[g1...g2], radix: 16) ?? -1
    }

    var blueComponent: Int? {
        let val = description
        guard val.hasPrefix("#") else { return nil }
        let b1 = val.index(val.startIndex, offsetBy: 5)
        let b2 = val.index(val.startIndex, offsetBy: 6)
        return Int(val[b1...b2], radix: 16) ?? -1
    }

    var opacityComponent: Int? {
        let val = description
        guard val.hasPrefix("#") else { return nil }
        let b1 = val.index(val.startIndex, offsetBy: 7)
        let b2 = val.index(val.startIndex, offsetBy: 8)
        return Int(val[b1...b2], radix: 16) ?? -1
    }
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
