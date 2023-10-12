//
//  MessagesListViewModel.swift
//  Chat App
//
//  Created by Lalit Vinde on 06/09/23.
//

import Foundation
import SwiftUI

extension MessagesList{
    class ViewModel : ObservableObject{
        @Published var messagesList:[Message] = []
        let firestoreManager : MessageServiceable
        init(firestoreManager:MessageServiceable = InjectedValues[\.firestoreManager]) {
            self.firestoreManager = firestoreManager
            
        }
        
        func addMessagesListener(forId:String){
            Task{
                await firestoreManager.addMessagesListener(messageList: Binding<[Message]>(get: {
                    self.messagesList
                }, set: { newValue, _ in
                    DispatchQueue.main.async {
                        self.messagesList=newValue
                        
                    }
                }), forId: forId)
            }
        }
    }
}
