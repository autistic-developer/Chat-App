//
//  DisableButton.swift
//  Chat App
//
//  Created by Lalit Vinde on 04/09/23.
//

import SwiftUI

struct DisableButton: View{
    let text:String
    @State var isDisabled:Bool
    let action: (Bool)->Void
    var body: some View{
        Button {
            action(isDisabled)
            
            isDisabled.toggle()
        } label: {
            RoundedRectangle(cornerRadius: 8.w)
                .fill(isDisabled ? .gray.opacity(0.5) : Color.secondaryC)
                .overlay{
                    Text(text)
                        .textStyle(size: 14.w, color:  isDisabled ? .gray : .white)
                }
        }
        
        
    }
}
struct DisableButton_Previews: PreviewProvider {
    static var previews: some View {
        DisableButton(text: "Request", isDisabled: true) { isDisabled in
            
        }
    }
}
