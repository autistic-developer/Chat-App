//
//  Registry.swift
//  Chat App
//
//  Created by Lalit Vinde on 24/08/23.
//
import Foundation

private struct UserDefaultManableKey: InjectionKey {
    static var currentValue: UserDefaultManable = UserDefaultsManager(userDefault: UserDefaults.standard)
}
private struct UserViewableKey : InjectionKey {
    static var currentValue: any UserViewable = UserViewModel()
}
private struct FirestoreManagableKey: InjectionKey {
    static var currentValue: FirestoreManagable = FirestoreManager(userViewModel: InjectedValues[UserViewableKey.self])
}
private struct AuthenticatableKey: InjectionKey {
    static var currentValue: Authenticatable = AuthenticationManager(firestoreManager: InjectedValues[FirestoreManagableKey.self])
   
}
private struct StorageManagableKey: InjectionKey {
    static var currentValue: StorageManagable = StorageManager(authManager: InjectedValues[AuthenticatableKey.self])
}





extension InjectedValues{
    var userDefault : UserDefaultManable{
        get{ Self[UserDefaultManableKey.self] }
        set{ Self[UserDefaultManableKey.self] = newValue}
    }
    var userViewModel : any UserViewable {
        get{ Self[UserViewableKey.self] }
        set{ Self[UserViewableKey.self] = newValue}
    }
    var firestoreManager : FirestoreManagable{
        get{ Self[FirestoreManagableKey.self] }
        set{ Self[FirestoreManagableKey.self] = newValue}
    }
    var authManager : Authenticatable{
        get{ Self[AuthenticatableKey.self] }
        set{ Self[AuthenticatableKey.self] = newValue}
    }
    var storeageManger :  StorageManagable{
        get{ Self[StorageManagableKey.self] }
        set{ Self[StorageManagableKey.self] = newValue}
    }
   
}


