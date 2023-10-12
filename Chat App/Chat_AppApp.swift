//
//  Chat_AppApp.swift
//  Chat App
//
//  Created by Lalit Vinde on 12/08/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
class AppDelegate: NSObject, UIApplicationDelegate {
    @Injected(\.userDefault) private var userDefaultManager:UserDefaultManable
    @Injected(\.userViewModel) private var userViewModel:any UserViewable
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        Auth.auth().addStateDidChangeListener {[weak self] auth, user in

            if let user {
                self?.userDefaultManager["isLogedIn"] = true
                
                self?.userViewModel.user = User(user: user)

            }
            else{
                self?.userDefaultManager["isLogedIn"] = false
                self?.userDefaultManager["isProfileSetted"] = false
            }

        }
        
        return true
    }
    
}

@main
struct Chat_AppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("isLogedIn") var isLogedIn : Bool?
    @AppStorage("isProfileSetted") var isProfileSetted : Bool?


    var body: some Scene {
        WindowGroup {
            NavigationView{
                ZStack{
                    if let _isLogedIn = isLogedIn, _isLogedIn{
                        if let _isProfileSetted = isProfileSetted, _isProfileSetted{
                            Home()
                                .backgroundColor()
                                .transition(.screenChange)


                        }
                        else{
                            Profile(isEditView: false)
                                .transition(.screenChange)

                        }
                    }
                    else{
                        NavigationView{
                            SignIn()
                        }
                        .transition(.screenChange)


                    }
                }

                .animation(.spring(), value: isLogedIn)
                .animation(.spring(), value: isProfileSetted)

            }
            .navigationViewStyle(.stack)

        }
    }
}

//@main
//struct Chat_AppApp: App {
//        @State var selection = "Chats"
//        let tabs:[String] = ["Chats","Request","Pending"]
//        var body: some Scene {
//            WindowGroup {
//                VStack{
//                    TabBar(selection: $selection, options: tabs)
//                    TabView(selection: $selection) {
//                        ForEach(tabs, id:\.self){ tab in
//                            Text(tab)
//                                .tag(tab)
//                        }
//                    }
//                }
//                .tabViewStyle(.page(indexDisplayMode: .never))
//
//            }
//    }
//}
