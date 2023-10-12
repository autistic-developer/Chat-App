//
//  ChatsList.swift
//  Chat App
//
//  Created by Lalit Vinde on 04/09/23.
//

import SwiftUI

struct ChatsUsersList: View {
    @State var isSheetPresented:Bool = false
    
    @StateObject var vm: ViewModel = ViewModel()
    var body: some View {
        ZStack(alignment:.bottomTrailing){
            ScrollView{
                VStack{
                    ForEach(vm.chatsList, id: \.uid) { user in
                        NavigationLink {
                            ChatBox(user: user)
                        } label:{
                            UserTile(user: user)
                                .padding(.top,5.w)
                        }
                        
                    }
                    .transition(
                        .asymmetric(
                            insertion: .opacity,
                            removal: .move(edge: .leading)
                        )
                    )
                    
                    
                }
                .frame(maxWidth: .infinity)
                .animation(.spring(), value: vm.chatsList) // <<< here
                
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Circle()
                .foregroundColor(.secondaryC)
                .overlay{
                    Image(systemName: "plus")
                    
                        .resizable()
                        .scaledToFit()
                    
                        .foregroundColor(.white)
                        .frame(width: 20.w, height: 20.w)
                }
                .frame(width: 55.w, height: 55.w)
                .onTapGesture {
                    isSheetPresented.toggle()
                }
                .padding(.all,30.w)
        }
        .sheet(isPresented: $isSheetPresented) {
            SearchView()
        }
        .ignoresSafeArea( edges: .bottom)
        
        
    }
}

struct ChatsUsersList_Previews: PreviewProvider {
    static var previews: some View {
        ChatsUsersList()
    }
}
