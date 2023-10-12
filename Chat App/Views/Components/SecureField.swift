//
//  SecureField.swift
//  Chat App
//
//  Created by Lalit Vinde on 14/08/23.
//

import SwiftUI

struct SecureField: View{
    let field:some Shape = RoundedRectangle(cornerRadius: 8.w)
    let placeHolder:String
    let text:Binding<String>
    let isSecured:Binding<Bool>
    var isValid:Binding<Bool> = .constant(true)
    var body: some View{
        field
            .stroke(!isValid.wrappedValue ? .pink.opacity(0.5) :Color.fieldBorderC , lineWidth: 1.w)
            .overlay {
                HStack{
                    if isSecured.wrappedValue{
                        SwiftUI.SecureField("Enter password", text: text)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .textFieldStyle(size: 14.w)
                    }
                    else{
                        SwiftUI.TextField("Enter password", text: text)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .textContentType(.password)
                            .textFieldStyle(size: 14.w)
                        
                    }
                    if !isValid.wrappedValue{
                        Image(systemName: "exclamationmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.red.opacity(1))
                            .frame(width: 24.w, height: 24.w)
                    }
                    else{
                        Button {
                            isSecured.wrappedValue.toggle()
                        } label: {
                            Image(systemName: isSecured.wrappedValue ?   "eye.fill" : "eye.slash.fill")
                        }.tint(.gray.opacity(0.7))

                    }
                }
                .padding(.horizontal,20.w)
            }
        
    }
}

struct SecureField_Previews: PreviewProvider {
    struct Content: View{
        @State var text=""
        @State var isSecured = true
        @State var isValid = true
        var body: some View{
            SecureField(placeHolder: "Enter password", text: $text, isSecured: $isSecured, isValid: $isValid)
                .frame(width: 319.w, height: 54.w)
            
        }
    }
    static var previews: some View {
        Content()
    }
}
