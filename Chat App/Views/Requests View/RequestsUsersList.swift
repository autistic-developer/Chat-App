//
//  RequestsList.swift
//  Chat App
//
//  Created by Lalit Vinde on 04/09/23.
//

import SwiftUI

struct RequestsUsersList: View {
    @StateObject var vm: ViewModel = ViewModel()

    var body: some View {
        ScrollView{
            VStack{
                ForEach(vm.requestsList, id: \.uid) { user in
                    UserTile(user: user) {
                        
                        DisableButton(text:"Accept", isDisabled:false){ isRequested in
                            
                            vm.acceptRequest(ofId: user.id)
                        }
                        .frame(width: 70.w, height: 30.w)
                        
                      
                        DisableButton(text:"Reject", isDisabled:false){ isRequested in
                            vm.rejectRequest(ofId: user.id) 
                        }.frame(width: 70.w , height: 30.w)
                        
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
            .animation(.spring(), value: vm.requestsList) // <<< here


        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
       


    }
}

struct RequestsUsersList_Previews: PreviewProvider {
    static var previews: some View {
        RequestsUsersList()
    }
}
