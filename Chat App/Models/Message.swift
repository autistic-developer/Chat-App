//
//  Message.swift
//  Chat App
//
//  Created by Lalit Vinde on 05/09/23.
//

import Foundation
import Firebase

class Message: Identifiable, Codable, Equatable, Hashable{
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id==rhs.id && lhs.reactionIdx == rhs.reactionIdx
    }
    
//    let id:String
    let id: String
    let toUID:String
    let fromUID:String
    let isFromCurrentUser:Bool
    let message:String
    let reactionIdx:Int?
    let timeStamp:Timestamp
    
    init( fromUID:String, toUID:String ,isFromCurrentUser:Bool,message: String, reactionIdx:Int? = nil, id:String, timeStamp: Timestamp = Timestamp()) {
        self.toUID = toUID
        self.fromUID = fromUID
        self.isFromCurrentUser = isFromCurrentUser
        self.message = message
        self.reactionIdx = reactionIdx
        self.id = id
        self.timeStamp=timeStamp
        
    }
    
}
