//
//  AuthDataResultModel.swift
//  Chat App
//
//  Created by Lalit Vinde on 14/08/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct User: Decodable, Encodable, Identifiable, Equatable{
    
    var id: String{
        get{
            uid
        }
    }
    let uid:String
    var email:String?
    var photoURL:String?
    var timeStamp:Date?
    var name:String?

    var status:String?
    var isOnline:Bool
    var keywordsForLookUp:[String]{
        var keywords:[[String]]=[]
        
        if let _name = name {
            let firstname_sername = _name.split(separator: " ")
            keywords.append(String(firstname_sername[0]).generateStringSequence())
            keywords.append(String(firstname_sername[1]).generateStringSequence())
            keywords.append(_name.generateStringSequence())
        }
        
        return keywords.flatMap({$0})
    }
    
    var requested:Bool = false
    
    enum CodingKeys: String, CodingKey {
        case uid
        case email
        case photoURL
        case timeStamp
        case name
        case status
        case isOnline
        case keywordsForLookUp
        
    }
    
    init(){
        self.uid="137aus8s8gad"
        self.name="Lalit Vinde"
        self.email="lalit5102001@gmail.com"
        self.status="Heyy you!!!"
        self.photoURL="https://firebasestorage.googleapis.com/v0/b/chat-gpt-cb7c9.appspot.com/o/profile_pics%2FL9pJAj6xAkaF6vSP4THq2kRWuQl1?alt=media&token=b3e0ae5e-0056-47ea-ace5-c2fd1123b683"
        self.isOnline = true
    }
    
    init (user: FirebaseAuth.User)
    {
        self.uid = user.uid
        self.email = user.email
        self.photoURL = user.photoURL?.absoluteString
        self.isOnline = true
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uid = try container.decode(String.self, forKey: .uid)
        self.email = try container.decode(String.self, forKey: .email)
        self.photoURL = try? container.decode(String.self, forKey: .photoURL)
        self.timeStamp = try? container.decode(Date.self, forKey: .timeStamp)
        self.name = try? container.decode(String.self, forKey: .name)
        self.status = try? container.decode(String.self, forKey: .status)
        self.isOnline = ((try? container.decode(Bool.self, forKey: .isOnline)) != nil)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uid, forKey: .uid)
        try container.encode(email, forKey: .email)
        if photoURL != nil{
            try container.encode(photoURL, forKey: .photoURL)
        }
        if timeStamp != nil{
            try container.encode(timeStamp, forKey: .timeStamp)
        }
        if name != nil{
            try container.encode(name, forKey: .name)
        }
        if status != nil{
            try container.encode(status, forKey: .status)
        }
        
        try container.encode(isOnline, forKey: .isOnline)
        
        try container.encode(keywordsForLookUp, forKey: .keywordsForLookUp)
        
    }
    
}

extension String{
    func generateStringSequence() -> [String]{
        
        var subStrings:[String]=[]
        for i in 1...self.count{
            subStrings.append( String(self.prefix(i)).lowercased() )
        }
        return subStrings
    }
}

