//
//  PendingListViewModel.swift
//  Chat App
//
//  Created by Lalit Vinde on 30/08/23.
//

import Foundation
import SwiftUI

extension RequestsUsersList{
    @MainActor
    class ViewModel: ObservableObject{
        @Published var requestsList:[User] = []
        
        @Injected(\.firestoreManager) private var firestoreManager: FirestoreManagable
        
        init() {
            Task{
                await firestoreManager.addRequestsListListener(requestsList: Binding<[User]>(
                    get: {
                        self.requestsList
                    },
                    set: { newValue, _ in
                        Task{
                            await MainActor.run{
                                self.requestsList = newValue
                            }
                        }
                    }
                )
                )
               
            }
        }
        func acceptRequest(ofId uid: String){
            Task{
                await firestoreManager.acceptRequest(ofUID: uid)
            }
        }
        
        func rejectRequest(ofId uid: String){
            Task{
                await firestoreManager.rejectRequest(ofUID: uid)
            }
        }
        
        
    }
}
