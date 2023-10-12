//
//  ChatMessage.swift
//  Chat App
//
//  Created by Lalit Vinde on 05/09/23.
//

import SwiftUI
import UIKit

struct MessageShape:Shape{
    let isFromCurrentUser:Bool
    let showReactionPopup:Bool=false
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [
                .topLeft,
                .topRight,
                isFromCurrentUser ? .bottomLeft : .bottomRight
            ],
            cornerRadii: CGSize(width: 15.w, height: 15.w)
        )
        return Path(path.cgPath)
        
    }
}
struct ChatBubble: View {
    let message:Message
    @Binding var showReactionPopUp:Bool
    init(message: Message, showReactionPopUp: Binding<Bool> = .constant(false)) {
        self.message = message
        self._showReactionPopUp = showReactionPopUp
    }
    static let reactions = ["❤️","🔥","👍🏻","👎🏻"]
    var body: some View {
            
            if message.isFromCurrentUser{
                chatBubble
                    .overlay(alignment:.trailing){
                        reactionPoUp
                    }

                
                
            }
            else{
                HStack{
                    chatBubble
                        .overlay(alignment:.leading){
                            reactionPoUp
                        }

                    Spacer()
                    
                }
                
            }
            
           
    
        
        
        
    }
    
    @ViewBuilder
    var reactionPoUp:some View{
        if showReactionPopUp {
            ReactionSelectionPopUp(message: message, showReactionPopUp: $showReactionPopUp)
                .offset(x:(message.isFromCurrentUser ? -1 : 1 ) * 15.w,y:53.w)
                .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))

        }
    }
    @ViewBuilder
    var chatBubble : some View{
        let itsMe=message.isFromCurrentUser
        Text(message.message)
            .textStyle(size: 14.w, color: itsMe ? .white : .black.opacity(0.7))
            .padding(.horizontal,15.w)
            .padding(.vertical, 10.w)
            .background{
                MessageShape(isFromCurrentUser: itsMe)
                    .fill( itsMe ?  Color.secondaryC : Color.gray.opacity(0.3))
                
            }
            .overlay(alignment: itsMe ? .topTrailing : .topLeading){
                if message.reactionIdx != nil {
                    Text(Self.reactions[message.reactionIdx!])
                        .font(.system(size: 11.5.w))
                        .padding(.all,5.w)
                        .background{
                            Circle()
                                .fill(.white)
                                .overlay{
                                    Capsule()
                                        .stroke(itsMe ? .blue : Color.gray.opacity(0.5), lineWidth: 2.w)
                                }
                            
                        }
                        .offset(x:(itsMe ? 1 : -1) * 10.w,y: 15.5.w)
                        .transition(.scale)
                    
                    
                }
            }
            .animation(.spring(), value: message.reactionIdx)

            
        
            .padding(itsMe ? .trailing : .leading, 15.w)
            .frame(maxWidth: UIScreen.main.bounds.width/1.5, alignment: itsMe ? .trailing : .leading)
            .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
    }
}


struct ChatBubble_Previews: PreviewProvider {
    struct Container : View{
        
        var body: some View{
            GeometryReader { geometry in
                
                ScrollView{
                    VStack{
                        Spacer()
                        LazyVStack(alignment:.trailing){
                            ForEach(1..<5) { i in
                                if i != 1{
                                    
                                    ChatBubble(message: Message(fromUID: "" ,toUID: "", isFromCurrentUser: true, message: "hello", reactionIdx: i%3,id:"\(i)") )
                                }
                                else{
                                    ChatBubble(message: Message(fromUID: "" ,toUID: "",isFromCurrentUser: false, message: "last", reactionIdx: i%3,id: "\(i)")
                                              )
                                }
                                
                            }
                            //
                            
                        }
                        
                    }
                    .frame(minHeight: geometry.size.height)
                    
                    
                }
            }
            
            .rotationEffect(Angle(degrees: 180))
            .rotation3DEffect(Angle(degrees: 180), axis: (x: 0, y: 1, z: 0))
            
            
            
            
            
        }
        
    }
    static var previews: some View {
        
        
        Container()
        
        
    }
}
