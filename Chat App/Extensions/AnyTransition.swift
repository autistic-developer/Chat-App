//
//  AnyTransition.swift
//  Chat App
//
//  Created by Lalit Vinde on 18/08/23.
//

import SwiftUI

struct SlideOutAnyTransitionViewModifier : ViewModifier{
    let isActive:Bool
    func body(content: Content) -> some View {
        content
            .brightness(isActive ? -0.15: 0)
            .offset(x:isActive ?  -UIScreen.main.bounds.width/3.5 : 0)
            .zIndex(0)
    }
}

struct SlideInAnyTransitionViewModifier : ViewModifier{
    let isActive:Bool
    func body(content: Content) -> some View {
        content
            .offset(x:isActive ? UIScreen.main.bounds.width : 0)
            .zIndex(1)
        
    }
}


extension AnyTransition{
    static var screenChange: AnyTransition{
        .asymmetric(
            insertion: .modifier(active:  SlideInAnyTransitionViewModifier(isActive: true), identity:  SlideInAnyTransitionViewModifier(isActive: false)),
            removal: .modifier(active:  SlideOutAnyTransitionViewModifier(isActive: true), identity:  SlideOutAnyTransitionViewModifier(isActive: false))
        )
    }
}
