//
//  PendingList.swift
//  Chat App
//
//  Created by Lalit Vinde on 30/08/23.


import SwiftUI

struct PendingsUsersList: View {
    @StateObject var vm: ViewModel = ViewModel()
    var body: some View {
        ScrollView{
            VStack{
                ForEach(vm.pendingsList, id: \.uid) { user in
                    UserTile(user: user) {
                        
                        DisableButton(text:"Request", isDisabled:true){ isRequested in
                            
                            vm.cancelRequest(forId: user.id)
                        }
                        .frame(width: 120.w , height: 30.w)

                        
                    }
                    .padding(.top,5.w)

                }
                .transition(
                    .asymmetric(
                        insertion: .opacity,
                        removal: .move(edge: .leading)
                    )
                )


            }
            .frame(maxWidth: .infinity)
            .animation(.spring(), value: vm.pendingsList) // <<< here


        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
       


    }
}

struct PendingUsersList_Previews: PreviewProvider {
    static var previews: some View {
        PendingsUsersList()
    }
}
