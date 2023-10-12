//
//  ChatsListViewModel.swift
//  Chat App
//
//  Created by Lalit Vinde on 04/09/23.
//

import Foundation
import SwiftUI

extension ChatsUsersList{
    @MainActor
    class ViewModel: ObservableObject{
        @Published var chatsList:[User] = []
        
        @Injected(\.firestoreManager) private var firestoreManager: FirestoreManagable
        
        init() {
            print("h")

            Task{
                await firestoreManager.addChatsListListener(chatsList: Binding<[User]>(
                    get: {
                        self.chatsList
                    },
                    set: { newValue, _ in
                        Task{
                            await MainActor.run{
                                
                                self.chatsList = newValue
                                print("h")
                            }
                        }
                    }
                )
                )
               
            }
        }
        
        
        
    }
}
