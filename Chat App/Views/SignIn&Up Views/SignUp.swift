//
//  SignUp.swift
//  Chat App
//
//  Created by Lalit Vinde on 13/08/23.
//

import SwiftUI

struct SignUp: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var vm = ViewModel(authManager:InjectedValues[\.authManager])
    
    var body: some View {
        ZStack {
            
            VStack(spacing:0){
                
                //MARK: back button
                HStack{
                    BackButton()
                        .onTapGesture {
                            dismiss()
                        }
                    Spacer()
                    
                }
                .padding(.top,20)
                .padding(.leading,20)
                
                Spacer()
                Image(.ImagesSet.appIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120.w, height: 120.w)
                Spacer()
                
                Spacer()
                VStack(spacing:16.w){
                    //MARK: email field
                    TextField(
                        placeHolder:"Enter email",
                        text:
                            Binding<String>(get: {
                                vm.email
                            }, set: { newValue,_ in
                                vm.email=newValue.trimmingCharacters(in: .whitespaces)
                            }
                                           ), isValid: $vm.isEmailValid
                    )
                    .frame(width: 319.w, height: 54.w)
                    
                    
                    //MARK: password field
                    SecureField(placeHolder: "Enter password", text: $vm.password, isSecured: $vm.isSecured,isValid: $vm.isPasswordValid)
                        .frame(width: 319.w, height: 54.w)
                    
                    
                }
                Spacer()
                
                //MARK: sign up button
                Button {
                    vm.signUp()
                } label: {
                    RoundedRectangle(cornerRadius: 8.w)
                        .overlay{
                            Text("**Sign Up**")
                                .textStyle(size: 16.w, color: .white)
                        }
                        .frame(width: 319.w, height: 54.w)
                }
                
                
                
                
                //MARK: sign in
                VStack(spacing:5.w){
                    Text("Already have an account?")
                        .textStyle(size: 13.w)
                    Button{
                        dismiss()
                    }label: {
                        
                        Text("**Sign in here**")
                            .textStyle(size: 13.w, color: .secondaryC)
                    }
                    
                }
                .padding(.vertical, 20.w)
                .padding(.top, 30.w)
                
                
                
            }
        }
        .alert(alertMsg: vm.alertMsg, isAlertPresented: $vm.isAlertPresented)
        .backgroundColor()
        .progressView(isVisible: $vm.isProgressViewVisible)
        .navigationBarBackButtonHidden(true)
        
        
    }
    
    
    let field:some View = RoundedRectangle(cornerRadius: 8.w)
        .stroke(Color.fieldBorderC, lineWidth: 1.w)
        .frame(width: 319.w, height: 54.w)
    
    
    
}

struct SignUp_Previews: PreviewProvider {
   
    struct Container: View{
        @StateObject var userViewModel = UserViewModel()

        var body: some View{
            NavigationView{
                SignUp()
            }
            .environmentObject(userViewModel)
        }
    }
    static var previews: some View {
        Container()
    }
}
