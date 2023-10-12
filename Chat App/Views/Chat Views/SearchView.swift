//
//  SearchView.swift
//  Chat App
//
//  Created by Lalit Vinde on 28/08/23.
//

import SwiftUI

struct SearchView: View {
    @StateObject var vm = ViewModel()
    var body: some View {
        VStack{
            RoundedRectangle(cornerRadius: 10.w)
                .fill(.gray.opacity(0.1))
                .overlay{
                    HStack{
                        SwiftUI.TextField("Search", text: $vm.searchText)
                            .textFieldStyle(size: 14.w)
                            .autocapitalization(.none)
                            .autocorrectionDisabled(true)
                        Image(systemName: "magnifyingglass")
                    }
                    .padding(.horizontal, 20.w)
                    
                }
                .frame(width: 340.w, height: 50.w)
                .padding(.vertical, 20.w)
            ScrollView{
                ForEach(vm.searchResult, id: \.uid) { user in
                    UserTile(user: user) {
                        
                        DisableButton(text:"Request",isDisabled:user.requested){ isRequested in
                            if isRequested{
                                vm.cancelRequest(forId: user.id)
                            }
                            else{
                                vm.sendRequest(toId: user.uid)
                            }
                            
                        }
                        .frame(width: 120.w , height: 30.w)

                        
                    }
                    .padding(.top,5.w)
                }
                .transition(.slide)
                
                
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    
}


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
