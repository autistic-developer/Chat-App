//
//  InjectionKey.swift
//  Chat App
//
//  Created by Lalit Vinde on 23/08/23.
//

public protocol InjectionKey{
    associatedtype Value
    
    static var currentValue : Self.Value {get set}
}

