//
//  AuthenticationManager.swift
//  Chat App
//
//  Created by Lalit Vinde on 14/08/23.
//

import Foundation
import FirebaseAuth
protocol SignUpAuthenticatable: Actor{
    func createUser(email:String, password:String) async throws
}
protocol SignInAuthenticatable: Actor{
    func signIn(email:String, password:String) async throws
    func getUid() -> String?
}
protocol Authenticatable : SignUpAuthenticatable, SignInAuthenticatable {
   func signOut()
}
final actor AuthenticationManager : Authenticatable{
    private let firestoreManager: FirestoreManagable
    private let auth:Auth = Auth.auth()
    
    init(firestoreManager: FirestoreManagable) {
        self.firestoreManager = firestoreManager
    }
    
    func createUser(email:String, password:String) async throws{
        let authDataResult:AuthDataResult = try await auth.createUser(withEmail: email, password: password)
        try await firestoreManager.createUser(user: authDataResult.user)
    }
    
    func signIn(email:String, password:String) async throws{
        try await auth.signIn(withEmail: email, password: password)
    }
    
    func getUid() -> String?{
        if let user = auth.currentUser{
            return user.uid
        }
        return nil
    }
    
    func signOut() {
        try? auth.signOut()
    }
  
//    func getCurrectUser() -> FirebaseAuth.User?{
//        auth.currentUser
//    }
    
}
