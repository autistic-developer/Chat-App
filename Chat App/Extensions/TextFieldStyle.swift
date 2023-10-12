//
//  TextField.swift
//  Chat App
//
//  Created by Lalit Vinde on 13/08/23.
//

import SwiftUI

struct TextFieldStyle: ViewModifier{
    let size:Double
    func body(content: Content) -> some View {
            content
            .font(.custom(.FontSet.cascadia, size: size))
        }
}

extension View{
    func textFieldStyle(size:Double) -> some View {
        modifier(TextFieldStyle(size: size))
    }
}
