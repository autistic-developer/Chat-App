//
//  ProfilePic.swift
//  Chat App
//
//  Created by Lalit Vinde on 27/08/23.
//

import SwiftUI
import Kingfisher

struct ProfilePic: View {
    
    let photoURL:String?
    var body: some View {
        
        KFImage(URL(string:photoURL ?? ""))
            .placeholder { progress in
                Image(.ImagesSet.profile)
                    .resizable()
                    .scaledToFit()
                    
            }
            .fade(duration: 0.25)
            .resizable()
            .scaledToFit()
            .clipShape(Circle())

    }
}

struct ProfilePic_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePic( photoURL: "https://firebasestorage.googleapis.com/v0/b/chat-gpt-cb7c9.appspot.com/o/profile_pics%2FFWx1epGITuMlVzGDPmEgn9X0Xp22?alt=media&token=27174059-27ca-49df-aefd-d0ec702fe0ec")
    }
}
