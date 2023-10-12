//
//  Color.swift
//  Clock
//
//  Created by Lalit Vinde on 26/07/23.
//

import SwiftUI
extension Color {
    init(hex: UInt32, alpha: Double = 1.0) {
        let red = Double((hex >> 16 ) & 0xFF) / 255.0
        let green = Double((hex >> 8) & 0xFF) / 255.0
        let blue = Double(hex & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, opacity: alpha)
    }
}

extension Color{
    static let primaryC: Color = Color("primary")
    static let secondaryC: Color = Color("secondary")
    static let fieldBorderC: Color = Color("fieldBorder")

}
