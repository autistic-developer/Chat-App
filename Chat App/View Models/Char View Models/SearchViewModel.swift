//
//  SearchViewModel.swift
//  Chat App
//
//  Created by Lalit Vinde on 28/08/23.
//

import SwiftUI
import Combine

extension SearchView{
    @MainActor 
    class ViewModel: ObservableObject{
        @Published var searchResult:[User] = []
        @Published var searchText: String = ""
        
        @Injected(\.firestoreManager) private var firestoreManager:FirestoreManagable
        
        private var searchSubscriber:Cancellable?
        init(){

            searchSubscriber = $searchText.sink{ query in
                Task{

                    self.searchResult = await self.firestoreManager.fetchSearchResult(for: query.lowercased())
                }
            }
        }
        
        func sendRequest(toId uid: String){
            Task{
                await firestoreManager.requestUser(byUID:uid)
            }
        }
        
        func cancelRequest(forId uid: String){
            Task{
                await firestoreManager.cancelRequest(forUID:uid)
            }
        }
    }
}
