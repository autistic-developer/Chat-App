//
//  MessagesList.swift
//  Chat App
//
//  Created by Lalit Vinde on 06/09/23.
//

import SwiftUI
import Firebase

struct MessagesList: View {
    let forId:String
    @State var currentTimestamp = Timestamp()
    @StateObject var vm = ViewModel()
    @Binding var selectedMsgId:String

   
    var body: some View {
        GeometryReader { geometry in
            ScrollView{
                VStack{
                    Spacer()
                    LazyVStack(alignment:.trailing){
                        ForEach(vm.messagesList){ message in
                            ChatBubble(message: message)
                                .onLongPressGesture(perform: {
                                    selectedMsgId=message.id
                                })
                                .if(!message.isFromCurrentUser && selectedMsgId==message.id, transform: { view in
                                    view
                                        .anchorPreference(key: MessagePreferenceKey.self, value: .bounds, transform: {MessagePreferenceValue(message: message, anchor: $0) })
                                        .hidden()
                                        .zIndex(1)
                                        
                                    
                                })
                                .transition(
                                    message.timeStamp.compare(currentTimestamp).rawValue == -1 ? .identity :
                                    .move(edge: message.isFromCurrentUser ? .trailing : .leading ).combined(with: .opacity)
                                    
                                )
        
                                
                                
                        }
                    }
                   
                }
                .frame(minHeight: geometry.size.height)
               

            }
            
            
        }
        .rotationEffect(Angle(degrees: 180))
        .rotation3DEffect(Angle(degrees: 180), axis: (x: 0, y: 1, z: 0))
        .animation(.spring(), value: vm.messagesList)
        .onAppear{
            currentTimestamp=Timestamp()
            vm.addMessagesListener(forId: forId)
        }
        
    }
    
}



extension View{
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
            if condition {
                transform(self)
            } else {
                self
            }
        }
}
struct MessagePreferenceValue:Equatable{
    let message:Message
    let anchor: Anchor<CGRect>?
}
struct MessagePreferenceKey : PreferenceKey{
    static var defaultValue: MessagePreferenceValue? = nil
    
    static func reduce(value: inout MessagePreferenceValue?, nextValue: () -> MessagePreferenceValue?) {
        value = nextValue()
    }
    
    typealias Value = MessagePreferenceValue?
        
    
}

struct MessagesList_Previews: PreviewProvider {
    static var previews: some View {
        MessagesList(forId: "", selectedMsgId: .constant(""))
    }
}
