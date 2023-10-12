//
//  StorageManager.swift
//  Chat App
//
//  Created by Lalit Vinde on 16/08/23.
//

import Foundation

import FirebaseStorage
import UIKit

protocol StorageManagable:Actor{
    func storeProfilePic(img: UIImage) async throws -> String?
}
final actor StorageManager:StorageManagable{
    
    private let authManager:SignInAuthenticatable
    private let storageRef:StorageReference = Storage.storage().reference()
    private let strorageProfilePicsRef:StorageReference
    private let imgMetadata = StorageMetadata()


    init(authManager: SignInAuthenticatable) {
        self.authManager = authManager
        strorageProfilePicsRef = storageRef.child("profile_pics")
        imgMetadata.contentType = "image/jpeg"

    }
    
    ///strore profile pic in firebase strorage
    func storeProfilePic(img: UIImage) async throws -> String? {
        guard let data = img.jpegData(compressionQuality: 1) else {
            return nil
        }
        do {
            if let uid = await authManager.getUid() {
                let imgRef = strorageProfilePicsRef.child(uid)
                let _ = try await imgRef.putDataAsync(data, metadata: imgMetadata)
                return try await imgRef.downloadURL().absoluteString
            }
        } catch {
            throw error
        }
        
        return nil
    }
    
}
