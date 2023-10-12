//
//  PendingListViewModel.swift
//  Chat App
//
//  Created by Lalit Vinde on 30/08/23.
//

import Foundation
import SwiftUI

extension PendingsUsersList{
    @MainActor
    class ViewModel: ObservableObject{
        @Published var pendingsList:[User] = []
        
        @Injected(\.firestoreManager) private var firestoreManager: FirestoreManagable
        
        init() {
            Task{
                await firestoreManager.addPendingsListListener(pendingsList: Binding<[User]>(
                    get: {
                        self.pendingsList
                    },
                    set: { newValue, _ in
                        Task{
                            await MainActor.run{
                                self.pendingsList = newValue
                            }
                        }
                    }
                )
                )
               
            }
        }
        func cancelRequest(forId uid: String){
            Task{
                await firestoreManager.cancelRequest(forUID:uid)
            }
        }
        
        
    }
}
