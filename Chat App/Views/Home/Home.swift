//
//  Home.swift
//  Chat App
//
//  Created by Lalit Vinde on 25/08/23.
//

import SwiftUI

struct Home: View {
    @State private var selection: String = "Chats"
    @StateObject var  userModel: UserViewModel = InjectedValues[\.userViewModel] as! UserViewModel
    @Injected(\.authManager) var authManager:Authenticatable
    @State var editProfilePresented:Bool=false
    let options = ["Chats","Requests","Pendings"]
    
    init(){
        Task{
            await InjectedValues[\.firestoreManager].addUserListener()
        }
    }
    var body: some View {
        
            VStack{
                topBar
                TabBar(selection: $selection, options: options)
                TabView(selection: $selection) {
                    ChatsUsersList()
                        .tag("Chats")
                    RequestsUsersList()
                        .tag("Requests")
                    PendingsUsersList()
                        .tag("Pendings")
                }
               

            }
            .overlay{
                NavigationLink("", isActive: $editProfilePresented) {
                    EditProfile(isEditView: true)
                }
                .hidden()
                .allowsHitTesting(false)

            }
            
            
               
        
        .ignoresSafeArea(edges: .bottom)
        
        .tabViewStyle(.page(indexDisplayMode: .never))

        
    }
    var topBar:some View{
        HStack{
            ProfilePic(photoURL: userModel.user?.photoURL)
            
            VStack(alignment:.leading){
                Text(userModel.user?.name ?? "")
                    .fontWeight(.bold)
                    .textStyle(size: 11.5.w)
                    .lineLimit(1)
                Text(userModel.user?.status ?? "")
                    .textStyle(size: 11.5.w)
                    .lineLimit(1)

            }
            .frame(width: 200.w, alignment: .leading)
            .padding(.leading,10.w)
            
            
            
            Spacer()
            
            Image(systemName: "gear")
                .resizable()
                .scaledToFit()
                .foregroundColor(.gray)
                .background(
                    .clear
                    )

            
                .frame( height: 25.w)
                .contentShape(.contextMenuPreview, Circle())

                .contextMenu{
                    Button {
                        editProfilePresented = true
                    } label: {
                        Label("Edit", image: .IconsSet.edit)
                        
                            .foregroundColor(.black)
                            
                    }

                    Button {
                        Task{
                           await authManager.signOut()
                        }
                    }label: {
                        Label("LogOut", systemImage: "rectangle.portrait.and.arrow.forward")
                    }

                }
//                .clipShape(Circle())

            
        }
        .padding(.horizontal, 10.w)
        .frame(width: 340.w, height: 45.w)
        .padding(.vertical, 5.w)
    }
}



struct Home_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Home()

        }
    }
}
