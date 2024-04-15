//
//  HexColor.swift
//  DashMart
//
//  Created by Максим Самороковский on 15.04.2024.
//

import Foundation
import SwiftUI

extension Color {
    init(hex string: String) {
        var string: String = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if string.hasPrefix("#") {
           _ = string.removeFirst()
        }
        let scanner = Scanner(string: string)
        
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        
        let mask = 0x0000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red = Double(r) / 255.0
        let green = Double(g) / 255.0
        let blue = Double(b) / 255.0
        
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1)
    }
}
