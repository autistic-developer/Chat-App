//
//  ChatBoxViewModel.swift
//  Chat App
//
//  Created by Lalit Vinde on 05/09/23.
//

import Foundation
import SwiftUI
extension ChatBox{
    class ViewModel : ObservableObject{
        @Published var text:String=""
        let firestoreManager : MessageServiceable
        init(firestoreManager:MessageServiceable = InjectedValues[\.firestoreManager]) {
            self.firestoreManager = firestoreManager
            
        }
        func send(message:String, toId:String){
            guard message != "" else{return}
            Task{
                await firestoreManager.sendMessage(message: message, toId: toId)
                await MainActor.run{
                    self.text=""
                }
            }
        }
        
    }
}
