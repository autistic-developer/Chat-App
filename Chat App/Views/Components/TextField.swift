//
//  TextField.swift
//  Chat App
//
//  Created by Lalit Vinde on 13/08/23.
//

import SwiftUI
struct TextField: View {
    let field:some Shape = RoundedRectangle(cornerRadius: 8.w)
    let placeHolder:String
    let text:Binding<String>
    var isValid:Binding<Bool> = .constant(true)
    var body: some View {
        field
            .stroke(!isValid.wrappedValue ? .pink.opacity(0.5) :Color.fieldBorderC , lineWidth: 1.w)
            .overlay {
                HStack{
                    SwiftUI.TextField(placeHolder, text: text)
                        .textFieldStyle(size: 14.w)
                        .autocapitalization(.none)
                        .autocorrectionDisabled(true)
                    if !isValid.wrappedValue{
                        Image(systemName: "exclamationmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.red.opacity(1))
                            .frame(width: 24.w, height: 24.w)
                    }
                }
                .padding(.horizontal,20.w)

            }

    }
}

struct TextField_Previews: PreviewProvider {
    struct Content: View{
        @State var text=""
        @State var isValid=true
        var body: some View{
            TextField(placeHolder: "Enter email", text: $text, isValid: $isValid)
                .frame(width: 319.w, height: 54.w)

        }
    }
    static var previews: some View {
        Content()
    }
}
