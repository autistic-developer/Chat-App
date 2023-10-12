//
//  UserViewModel.swift
//  Chat App
//
//  Created by Lalit Vinde on 16/08/23.
//

import Foundation
import SwiftUI

protocol UserViewable : ObservableObject {
    var user: User? {get set}
    var userPublisher: Published<User?>.Publisher { get }
}
final class UserViewModel:  UserViewable{
    @Published var user: User? = nil
    var userPublisher: Published<User?>.Publisher {$user}

}
