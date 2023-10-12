//
//  UserDefaultsManager.swift
//  Chat App
//
//  Created by Lalit Vinde on 16/08/23.
//

import Foundation
protocol UserDefaultManable{
    subscript(key: String) -> Any? {get set}
}
final class UserDefaultsManager:UserDefaultManable{
    let userDefault: UserDefaults
    
    init(userDefault: UserDefaults) {
        self.userDefault = userDefault
    }
    
    subscript(key: String) -> Any?{
        get {
            userDefault.object(forKey: key)
        }
        set(newValue) {
            userDefault.set(newValue, forKey: key)
        }
    }
}

