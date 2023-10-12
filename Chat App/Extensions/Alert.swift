//
//  Alert.swift
//  Chat App
//
//  Created by Lalit Vinde on 17/08/23.
//

import SwiftUI

struct AlertViewModifier: ViewModifier{
    let alertMsg:String
    let isAlertPresented:Binding<Bool>
    func body(content: Content) -> some View {
        ZStack{
            content
            if isAlertPresented.wrappedValue{
               
                Color.gray.opacity(0.5).transition(
                    .opacity.animation(.spring(response: 0.4)
                                      )
                ).ignoresSafeArea()
                .zIndex(1)
                alertView().transition(.scale(scale: 0.95).combined(with: .opacity).animation(.spring(response: 0.4)
                                                                   )
                ).zIndex(2)
                
                
                    
            }
        }
       
    }
    
    func alertView() -> some View{
        
        return Rectangle()
            .fill(.white.opacity(0.9))
            .background(Material.ultraThin)
            .clipShape(RoundedRectangle(cornerRadius: 15.w))
            .frame(width: 220.w, height: 130.w)
            .overlay{
                VStack(spacing:0){
                    Spacer()
                    Text(alertMsg)
                        .textStyle(size: 15.w)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 10.w)
                        
                    Spacer()
                    Divider()
                    Button {
                        isAlertPresented.wrappedValue=false
                    } label: {
                        Text("OK")
                            .textStyle(size: 15.w, color: .secondaryC)
                        
                    }.padding(.vertical, 10.w)
                    
                }
                .padding(.horizontal,20.w)
            }
        
    }
}

extension View{
    func alert(alertMsg:String, isAlertPresented:Binding<Bool>) -> some View {
        modifier(AlertViewModifier(alertMsg: alertMsg, isAlertPresented: isAlertPresented))
    }
}
