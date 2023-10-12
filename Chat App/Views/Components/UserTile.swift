//
//  UserTile.swift
//  Chat App
//
//  Created by Lalit Vinde on 27/08/23.
//

import SwiftUI

struct UserTile<Content: View>: View {
    let user:User
    @ViewBuilder var content: () -> Content?

    var body: some View {
        HStack{
            ProfilePic(photoURL: user.photoURL)
            HStack(alignment:.top){
                VStack(alignment:.leading,spacing: 2.w){
                    Text(user.name ?? "")
                        .fontWeight(.bold)
                        .textStyle(size: 13.w)
                    Text(user.status ?? "")
                        .textStyle(size: 13.w)
                    
                }
            }
            .alignmentGuide(VerticalAlignment.center, computeValue: { d in
                d[VerticalAlignment.center]+3.w
            })
            .padding(.top, 5.w)
            .padding(.leading, 5.w)
            Spacer()
            HStack(content: content)
            
        }
        .frame(height:50.w)
        .padding(.horizontal, 25.w)
    }
}
extension UserTile{
    init(user:User) where Content == EmptyView {
        self.init(user: user, content: {EmptyView()})
    }

}
struct UserTile_Previews: PreviewProvider {
    struct Container:View{
        var body: some View{
            UserTile(user: User()) {
                
            }
        }
    }
    static var previews: some View {
        Container()
    }
}
