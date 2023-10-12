//
//  ProgressView.swift
//  Chat App
//
//  Created by Lalit Vinde on 19/08/23.
//

import SwiftUI

struct ProgressViewModifier : ViewModifier{
    let isVisible: Binding<Bool>
    func body(content: Content) -> some View {
        content
            .blur(radius:isVisible.wrappedValue ? 4.w : 0)
            
            .overlay{
                if isVisible.wrappedValue{
                    ZStack{
                        Color.white.opacity(0.1).ignoresSafeArea()
                        
                        ProgressView()
                            .controlSize(.regular)
                            .contrast(-0.5)
                            .transition(.scale)
                    }
                    .transition(.opacity)
                }
            }
            .animation(.easeOut(duration: 0.7), value: isVisible.wrappedValue)

    }
}

extension View{
    
    func progressView(isVisible: Binding<Bool>)-> some View{
        modifier(ProgressViewModifier(isVisible: isVisible))
        
    }
}

struct ProgressView_Previews: PreviewProvider {
    struct Content: View{
        @State var isVisible=true
        var body: some View{
            Color.white.ignoresSafeArea()
                .progressView(isVisible: $isVisible)

        }
    }
    static var previews: some View {
        Content()
    }
}
