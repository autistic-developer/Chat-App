//
//  ProfileVireModel.swift
//  Chat App
//
//  Created by Lalit Vinde on 16/08/23.
//

import Foundation
import UIKit
import FirebaseStorage
import SwiftUI
import Combine

extension Profile{
    @MainActor
    final class ViewModel : ObservableObject{
        
        ///name field binding
        @Published var name:String = ""
        ///name is-valid? binding
        @Published var isNameValid=true

        ///status field binding
        @Published var status:String = ""
        ///status is-valid? binding
        @Published var isStatusValid=true

        ///is sheet presented? binding
        @Published var isSheetPresented:Bool = false
       
        ///binding for ImagerPicker:UIViewControllerRepresentable
        @Published var profilePic:UIImage? = nil
        
        ///is alert presented? binding
        @Published var isAlertPresented=false
        ///is progress-view presented? binding
        @Published var isProgressViewVisible=false
        @Published var photoURL:String?
        var alertMsg = ""
        
        ///to check is profile pic get picked?
        var isProfilePicSelected = false

        ///user model
        @Injected(\.userViewModel) private var userViewModel: any UserViewable
        ///user default
        @Injected(\.userDefault) private var  userDefaultManager : UserDefaultManable
        //firebase storeage manager
        @Injected(\.storeageManger) private var storageManger : StorageManagable
        //firestrore manager
        @Injected(\.firestoreManager) private var firestoreManager : FirestoreManagable
        
        private var nameSubscriber: Cancellable?
        private var statusSubscriber: Cancellable?
        private var userSubscriber: Cancellable?

        init(){
            Task{
                await firestoreManager.addUserListener()
            }
            self.userSubscriber = self.userViewModel.userPublisher.sink(receiveValue: {[weak self] user in
                if let user{
                    Task{
                       
                            self?.name = user.name ?? ""
                            self?.status = user.status ?? ""
                            self?.photoURL = user.photoURL 
                        
                    }
                }
                
            })
        }
        
        func onComplete() -> Bool {
            if !isValidName(){
                isNameValid=false
                nameSubscriber = $name.sink {[weak self] newValue in
                    if self?.name != newValue{
                        self?.isNameValid=true
                        self?.nameSubscriber?.cancel()
                    }
                    
                }
                alertMsg = "Plzz enter full name 🤌🏻"
                isAlertPresented = true
                return false
                
            }
            if !isValidStatus(){
                isStatusValid=false
                statusSubscriber = $status.sink {[weak self] newValue in
                    if self?.status != newValue{
                        self?.isStatusValid=true
                        self?.statusSubscriber?.cancel()
                    }
                }
                alertMsg = "Plzz enter status"
                isAlertPresented = true
                return false

            }
            if var user = userViewModel.user{
                user.name = name
                user.status = status
                user.photoURL = nil
                Task{
                    isProgressViewVisible=true
                    if isProfilePicSelected{
                        do{
                            if let img = profilePic{
                                if let photoURL = try await storageManger.storeProfilePic(img: img){
                                    user.photoURL = photoURL
                                }
                            }
                        }
                        catch{
                            isProgressViewVisible=false
                            alertMsg = error.localizedDescription
                            isAlertPresented = true
                            
                        }
                    }
                    try await firestoreManager.updateUser(user: user)
                    userDefaultManager["isProfileSetted"] = true
                }
                isProgressViewVisible=false

               
            }
            return true
        }
        
        func isValidName() -> Bool{
            return name.trimmingCharacters(in: .whitespaces).split(separator: " ").count==2
        }
        
        func isValidStatus() -> Bool{
            return status.trimmingCharacters(in: .whitespaces).count>0
        }
    }
}
