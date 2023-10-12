//
//  FirestoreManager.swift
//  Chat App
//
//  Created by Lalit Vinde on 18/08/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import SwiftUI



protocol FirestoreManagable : MessageServiceable {
    
    func createUser(user: FirebaseAuth.User) async throws -> ()
    func addUserListener() async
    func updateUser(user: User) async throws -> ()
    func requestUser(byUID: String)
    func cancelRequest(forUID: String)
    func acceptRequest(ofUID: String)
    func rejectRequest(ofUID: String)

    func fetchSearchResult(for search:String ) async -> [User]
    func addPendingsListListener(pendingsList: Binding<[User]>)
    func addRequestsListListener(requestsList: Binding<[User]>)
    func addChatsListListener(chatsList: Binding<[User]>)
    
}

protocol MessageServiceable : Actor{
    func sendMessage(message:String, toId:String)
    func addMessagesListener(messageList: Binding<[Message]>, forId:String)
    func addReaction(reactionIdx:Int ,toMessage:Message)
}





final actor FirestoreManager : FirestoreManagable {
    
    
    
    
    private static let REQUESTS="Requests"
    private static let USERS="Users"
    private static let CHATS="Chats"
    private static let PENDINGS="Pendings"
    private static let MESSAGES="Messages"
    
    
    
    private var userViewModel: any UserViewable
    private let firestore = Firestore.firestore()
    private let usersCollection: CollectionReference
    private let chatsCollection: CollectionReference
    
    
    init(userViewModel: any UserViewable ) {
        self.userViewModel = userViewModel
        usersCollection = firestore.collection(Self.USERS)
        chatsCollection = firestore.collection(Self.CHATS)
    }
    func createUser(user: FirebaseAuth.User) async throws -> () {
        
        return try await withCheckedThrowingContinuation{ (control:CheckedContinuation<Void, Error>) in
            do{
                try usersCollection.document(user.uid).setData(from: User(user: user), completion: { error in
                    if let error{
                        control.resume(throwing: error)
                    }
                    else{
                        control.resume(returning: ())
                    }
                })
            }
            catch{
                control.resume(throwing: error)
            }
            
        }
        
    }
    
    func addUserListener() async{
        
        if let uid = Auth.auth().currentUser?.uid
        {
            usersCollection.document(uid).addSnapshotListener { documentSnapshot, error in
                if let documentSnapshot{
                    do{
                        let user =  try documentSnapshot.data(as: User.self)
                        
                        self.userViewModel.user = user
                    }
                    catch{
                        
                    }
                }
            }
        }
    }
    
    func updateUser(user: User) async throws -> () {
        try await withCheckedThrowingContinuation{ (control:CheckedContinuation<Void, Error>) in
            do{
                try usersCollection.document(user.uid).setData(from: user, merge:true, completion: { error in
                    if let error{
                        control.resume(throwing: error)
                    }
                    else{
                        control.resume(returning: ())
                    }
                })
                userViewModel.user = user
            }
            catch{
                control.resume(throwing: error)
            }
            
        }
    }
    
    func requestUser(byUID: String){
        if let uid = userViewModel.user?.uid
        {
            //u request to x
            //add to ur pending list
            usersCollection.document(uid).collection(Self.PENDINGS).document(byUID).setData(["uid":byUID])
            //add to their request list
            usersCollection.document(byUID).collection(Self.REQUESTS).document(uid).setData(["uid":uid])
            
        }
    }
    
    func cancelRequest(forUID: String){
        if let uid = userViewModel.user?.uid
        {
            usersCollection.document(uid).collection(Self.PENDINGS).document(forUID).delete()
            usersCollection.document(forUID).collection(Self.REQUESTS).document(uid).delete()
            
        }
    }
    
    func acceptRequest(ofUID: String){
        if let uid = userViewModel.user?.uid
        {
            
            //u accept one of thre request from ur pending list
            //remove it from ur request list
            usersCollection.document(uid).collection(Self.REQUESTS).document(ofUID).delete()
            //remove it from their pending list
            usersCollection.document(ofUID).collection(Self.PENDINGS).document(uid).delete()
            
            //add to ur chat list
            usersCollection.document(uid).collection(Self.CHATS).document(ofUID).setData(["uid":ofUID])
            //add to there chat list
            usersCollection.document(ofUID).collection(Self.CHATS).document(uid).setData(["uid":uid])
            
            
            
        }
    }
    
    func rejectRequest(ofUID: String) {
        if let uid = userViewModel.user?.uid
        {
            usersCollection.document(uid).collection(Self.REQUESTS).document(ofUID).delete()
            usersCollection.document(ofUID).collection(Self.PENDINGS).document(uid).delete()
            
        }

    }
    
    func fetchSearchResult(for search:String ) async -> [User]{
        let queryDocumentSnapshots =  await withCheckedContinuation({ (continuation : CheckedContinuation<[QueryDocumentSnapshot], Never>) in
            
            usersCollection
                .whereField("keywordsForLookUp", arrayContains: search)
                .getDocuments { querySnapshot, error in
                    if let querySnapshot
                    {
                        continuation.resume(returning: querySnapshot.documents)
                    }
                    else if error != nil{
                        continuation.resume(returning: [])
                    }
                }
            
            
        })
        if let uid = userViewModel.user?.uid
        {
            var result:[User]=[]
            for queryDocumentSnapshot in queryDocumentSnapshots{
                if var user = try? queryDocumentSnapshot.data(as: User.self), uid != user.uid{
                    if
                        let snapshotOfChats = try? await self.usersCollection
                            .document(uid)
                            .collection(Self.CHATS)
                            .whereField("uid", isEqualTo: user.uid)
                            .limit(to: 1)
                            .count
                            .getAggregation(source: .server),
                        Int(truncating: snapshotOfChats.count) == 0,
                        let snapshot = try? await self.usersCollection
                            .document(uid)
                            .collection(Self.PENDINGS)
                            .whereField("uid", isEqualTo: user.uid)
                            .limit(to: 1)
                            .count
                            .getAggregation(source: .server)
                            
                    {
                        if Int(truncating: snapshot.count) > 0 {
                            user.requested=true
                            result.append(user)
                        }
                        else{
                            result.append(user)
                        }
                        
                    }
                }
            }
            return result
        }
        
        return []
    }
    
    func addPendingsListListener(pendingsList: Binding<[User]>){
        
        if let uid = userViewModel.user?.uid
        {
            usersCollection.document(uid).collection(Self.PENDINGS) .addSnapshotListener { querySnapshot, error in
                if let querySnapshot{
                    
                    Task{
                        await self.fetchPendigsList(queryDocumentSnapshots: querySnapshot.documents, pendingsList: pendingsList)
                    }
                }
                else{
                    pendingsList.wrappedValue=[]
                }
            }
        }
        
    }
    
    
    private func fetchPendigsList(queryDocumentSnapshots: [QueryDocumentSnapshot], pendingsList: Binding<[User]>) async{
        
        
        let idList = queryDocumentSnapshots.compactMap { queryDocumentSnapshot in
            queryDocumentSnapshot.documentID
        }
        var resultList:[User]=[]
        for id in idList{
            if let pendingUser = await withCheckedContinuation ({ (continuation:CheckedContinuation< User?, Never>) in
                self.usersCollection.document(id).getDocument(as: User.self) { result in
                    switch result{
                        
                    case .success(let user):
                        continuation.resume(returning: user)
                    case .failure(_):
                        continuation.resume(returning: nil)
                    }
                }
            }){
                resultList.append(pendingUser)
            }
        }
        pendingsList.wrappedValue=resultList
        
        
        
    }
    
    func addRequestsListListener(requestsList: Binding<[User]>){
        
        if let uid = userViewModel.user?.uid
        {
            usersCollection.document(uid).collection(Self.REQUESTS) .addSnapshotListener { querySnapshot, error in
                if let querySnapshot{
                    
                    Task{
                        await self.fetchRequestsList(queryDocumentSnapshots: querySnapshot.documents, requestsList: requestsList)
                    }
                }
                else{
                    requestsList.wrappedValue=[]
                }
            }
        }
        
    }
    
    
    private func fetchRequestsList(queryDocumentSnapshots: [QueryDocumentSnapshot], requestsList: Binding<[User]>) async{
        
        let idList = queryDocumentSnapshots.compactMap { queryDocumentSnapshot in
            queryDocumentSnapshot.documentID
        }
        var resultList:[User]=[]
        for id in idList{
            if let pendingUser = await withCheckedContinuation ({ (continuation:CheckedContinuation< User?, Never>) in
                self.usersCollection.document(id).getDocument(as: User.self) { result in
                    switch result{
                        
                    case .success(let user):
                        continuation.resume(returning: user)
                    case .failure(_):
                        continuation.resume(returning: nil)
                    }
                }
            }){
                resultList.append(pendingUser)
            }
        }
        requestsList.wrappedValue=resultList
        
        
        
    }
    
    func addChatsListListener(chatsList: Binding<[User]>){
        
        if let uid = userViewModel.user?.uid
        {
            usersCollection.document(uid).collection(Self.CHATS).addSnapshotListener{ querySnapshot, error in
                if let querySnapshot{
                    Task{
                        await self.fetchChatsList(queryDocumentSnapshots: querySnapshot.documents, chatsList: chatsList)
                    }
                }
                else{
                    chatsList.wrappedValue=[]
                }
            }
        }
        
    }
    
    private func fetchChatsList(queryDocumentSnapshots: [QueryDocumentSnapshot], chatsList: Binding<[User]>) async{
        
        let idList = queryDocumentSnapshots.compactMap { queryDocumentSnapshot in
            queryDocumentSnapshot.documentID
        }
        var resultList:[User]=[]
        for id in idList{
            if let pendingUser = await withCheckedContinuation ({ (continuation:CheckedContinuation< User?, Never>) in
                self.usersCollection.document(id).getDocument(as: User.self) { result in
                    switch result{
                        
                    case .success(let user):
                        continuation.resume(returning: user)
                    case .failure(_):
                        continuation.resume(returning: nil)
                    }
                }
            }){
                resultList.append(pendingUser)
            }
        }
        chatsList.wrappedValue=resultList
        
        
        
    }
    
    func sendMessage(message: String, toId: String) {
        if let uid = userViewModel.user?.uid
        {
            let senderRef:DocumentReference = chatsCollection.document(uid).collection(toId).document()
            let reciverRef = chatsCollection.document(toId).collection(uid)
            
            try? senderRef.setData(from: Message(fromUID: uid, toUID: toId, isFromCurrentUser: true, message: message, id:senderRef.documentID))
            try? reciverRef.document(senderRef.documentID).setData(from: Message(fromUID: uid, toUID: toId, isFromCurrentUser: false, message: message,id:senderRef.documentID))
        }
        
    }
    
    func addMessagesListener(messageList: Binding<[Message]>, forId:String) {
        if let uid = userViewModel.user?.uid
        {
            chatsCollection.document(uid).collection(forId).order(by: "timeStamp", descending: true).addSnapshotListener{ querySnapshot, error in
                if let querySnapshot{
                    
                    messageList.wrappedValue=querySnapshot.documents.compactMap { queryDocumentSnapshot in
                        try? queryDocumentSnapshot.data(as: Message.self)
                    }
                    
                }
                else{
                    messageList.wrappedValue=[]
                }
            }
        }
    }
    
    func addReaction(reactionIdx: Int, toMessage: Message) {
        if let uid = userViewModel.user?.uid
        {
            let senderRef:DocumentReference = chatsCollection.document(uid).collection(toMessage.fromUID).document(toMessage.id)
            let reciverRef:DocumentReference  = chatsCollection.document(toMessage.fromUID).collection(uid).document(toMessage.id)
            
            senderRef.setData(["reactionIdx":reactionIdx], merge: true)
            reciverRef.setData(["reactionIdx":reactionIdx], merge: true)
        }
    }
    
}
