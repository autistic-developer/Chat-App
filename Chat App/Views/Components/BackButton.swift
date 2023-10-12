//
//  BackButton.swift
//  Chat App
//
//  Created by Lalit Vinde on 13/08/23.
//

import SwiftUI

struct BackButton: View {
    var body: some View {
        HStack{
            Image("back")
                .resizable()
                .scaledToFit()
                .frame(width: 26.w, height: 26.w)
            
            Text("**Back**")
                .textStyle(size: 16.w, color: .secondaryC)
        }
    }
}

struct BackButton_Previews: PreviewProvider {
    static var previews: some View {
        
        BackButton()
    }
}
