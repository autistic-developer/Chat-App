//
//  ReactionSelectionPopUp.swift
//  Chat App
//
//  Created by Lalit Vinde on 09/09/23.
//

import SwiftUI

struct ReactionSelectionPopUp: View {
    let message:Message
    static let reactions = ["❤️","🔥","👍🏻","👎🏻"]
    @State var isAppeared = false
    @Binding var showReactionPopUp:Bool
    init(message: Message, showReactionPopUp: Binding<Bool> = .constant(false)){
        self.message = message
        self._showReactionPopUp = showReactionPopUp
    }

    let vm = ViewModel()
    var body: some View {
        HStack{
            ForEach(Self.reactions.indices, id: \.self) { idx in
                Text(Self.reactions[idx])
                    .onTapGesture {
                        vm.addReaction(reactionIdx: idx, toMessage: message)
                        showReactionPopUp=false
                    }
                    .scaleEffect( isAppeared ? 1 : 0.01)
                    .animation(.spring( dampingFraction: 0.5, blendDuration: 0).delay(0.24 + 0.04 * Double(idx)), value: isAppeared)
                                        
            }

        }

        .padding(.vertical,10.w)
        .padding(.horizontal,15.w)
        .background{
                Capsule()
                    .fill(.white)
                    .background(alignment:.top){
                        Ellipse()
                            .fill(.white)
                        
                            .overlay(alignment: message.isFromCurrentUser ? .topTrailing : .topLeading){
                                Circle()
                                    .fill(.white)
                                    .padding(.all,4.5.w)
                                    .offset(x:(message.isFromCurrentUser ? 1 : -1) *  8.w, y: -12.w)
                            }
                            .frame(width: 18.w, height: 15.w)
                            .offset(x:(message.isFromCurrentUser ? 1 : -1) * 25.w, y:-6.w)
                            .compositingGroup()
                        
                        
                        
                    }
                    .compositingGroup()
                    .scaleEffect( isAppeared ? 1 : 0.01, anchor: .top)
                    .animation(.spring( dampingFraction: 0.65, blendDuration: 0), value: isAppeared)
                    .shadow(color:.black.opacity(0.05),radius: 6.w)
            


        }

        .onAppear{
            isAppeared=true
        }
        .onDisappear{
            isAppeared=false

        }

    }
}

struct ReactionSelectionPopUp_Previews: PreviewProvider {
    static var previews: some View {
        ReactionSelectionPopUp(message: Message(fromUID: "" ,toUID: "", isFromCurrentUser: true, message: "", id: ""))
    }
}
