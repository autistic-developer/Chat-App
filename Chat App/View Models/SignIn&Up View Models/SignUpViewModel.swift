//
//  SignUpViewModel.swift
//  Chat App
//
//  Created by Lalit Vinde on 14/08/23.
//

import Foundation
import Combine
import SwiftUI

extension SignUp{
    @MainActor
    final class ViewModel : ObservableObject{

        ///email binder
        @Published var email:String=""
        @Published var isEmailValid=true
        
        ///password binder
        @Published var password:String=""
        @Published var isPasswordValid=true
        
        ///to hide and show eye icon on password field
        @Published var isSecured:Bool=true
        
        ///alert binder
        @Published var isAlertPresented=false
        
        ///alert message
        var alertMsg = ""
        ///progress view binder
        @Published var isProgressViewVisible=false
        
        ///subscriber for email
        private var emailSubscriber: Cancellable?
        ///subscriber for password
        private var passwordSubscriber: Cancellable?
        
        ///user model
        @Injected(\.userViewModel) private var userViewModel: any UserViewable
        ///auth manager
        private let authManager : SignUpAuthenticatable

        init(authManager:SignUpAuthenticatable){
            self.authManager=authManager
        }
        
        func signUp(){
            password=password.trimmingCharacters(in: .whitespaces)
            
            if !isValidEmail(){
                isEmailValid=false
                emailSubscriber = $email.sink {[weak self] emailVal in
                    if let result = self?.isValidEmail(), result{
                        self?.isEmailValid=true
                        self?.emailSubscriber?.cancel()
                    }
                    
                }
                alertMsg="Please enter valid email 🤌🏻!!"
                isAlertPresented=true
                return
            }
            if !isValidPassword(){
                isPasswordValid=false
                passwordSubscriber = $password.sink {[weak self] passVal in
                    if self?.password != passVal{
                        self?.isPasswordValid=true
                        self?.passwordSubscriber?.cancel()
                    }
                }
                alertMsg="⚠️ Plzz enter strong password"
                isAlertPresented=true
                return
            }
            Task{
                isProgressViewVisible=true
                do{
                    try await authManager.createUser(email: email, password: password)
                }
                catch {
                    isProgressViewVisible=false
                    alertMsg=error.localizedDescription
                    isAlertPresented=true
                }
                isProgressViewVisible=false
            }
        }
        
        func isValidEmail() -> Bool{
            var returnVal=false
            let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
            do {
                let regex = try NSRegularExpression (pattern: emailRegEx)
                let nsString = email as NSString
                let result = regex.firstMatch(in: email, range: NSRange (location: 0, length:nsString.length))
                if let _ = result
                {
                    returnVal=true
                }
            } catch let error as NSError {
                print ("invalid regex: \(error.localizedDescription)")
                
            }
            return returnVal
        }
        
        func isValidPassword() -> Bool{
            var returnVal=false
            let passRegEx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$"
            do {
                let regex = try NSRegularExpression (pattern: passRegEx)
                let nsString = password as NSString
                let result = regex.firstMatch(in: password, range: NSRange (location: 0, length:nsString.length))
                if let _ = result
                {
                    returnVal=true
                }
            } catch let error as NSError {
                print ("invalid regex: \(error.localizedDescription)")
                
            }

            return returnVal
        }
        
        
        
    }
}
