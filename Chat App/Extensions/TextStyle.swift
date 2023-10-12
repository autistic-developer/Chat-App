//
//  Font.swift
//  Chat App
//
//  Created by Lalit Vinde on 12/08/23.
//

import SwiftUI

struct TextStyle: ViewModifier{
    let size:Double
    let color:Color
    func body(content: Content) -> some View {
            content
                .foregroundColor(color)
                .font(.custom(.FontSet.cascadia, size: size))
        }
}
extension View{
    func textStyle(size:Double, color:Color = .primaryC) -> some View {
        modifier(TextStyle(size: size, color:color))
    }
}
