//
//  General.swift
//  Chat App
//
//  Created by Lalit Vinde on 17/08/23.
//

import SwiftUI

struct BackgroundViewModfier : ViewModifier {
    let color:Color
    func body(content: Content) -> some View {
        ZStack{
            color.cornerRadius(10.w).ignoresSafeArea()
            content
        }
           
    }
    
}

extension View{
    func backgroundColor(color: Color = Color.white) -> some View{
        modifier(BackgroundViewModfier(color: color))
    }
}
