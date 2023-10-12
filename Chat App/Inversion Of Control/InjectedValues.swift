//
//  InjectionValue.swift
//  Chat App
//
//  Created by Lalit Vinde on 23/08/23.
//

struct InjectedValues{
    private static var current = InjectedValues ()
    
    static subscript<T>(keyPath:WritableKeyPath<InjectedValues , T>) -> T {
        get{ current[keyPath: keyPath] }
        set{ current[keyPath: keyPath] = newValue}
    }
    
    static subscript<K>(key: K.Type) -> K.Value where K : InjectionKey{
        get{ key.currentValue }
        set{ key.currentValue = newValue }
    }
}
