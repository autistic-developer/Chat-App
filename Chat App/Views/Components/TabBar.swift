//
//  TabBar.swift
//  Chat App
//
//  Created by Lalit Vinde on 25/08/23.
//

import SwiftUI


struct TabBar: View {
    @Binding var selection:String
    let options:[String]
    @Namespace var heroTab
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12.w)
            .fill(.black.opacity(0.02))
            .overlay{
                HStack(spacing: 6.w) {
                    ForEach(options, id: \.self) { option in
                       
                        Tab(name: option, selection: $selection, heroTab: heroTab)
                    }
                }
                .padding(.horizontal, 6.w)
                .padding(.vertical, 6.w)
            }
            .frame(width: 340.w, height: 50.w)
        
    }
    
}
struct Tab: View{
    let name: String
    @Binding var selection:String
    let heroTab: Namespace.ID
    
    
    var body: some View{
        ZStack{
            if name==selection{
                RoundedRectangle(cornerRadius: 8.w)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.06), radius: 2.w, y: 1.w)
                    .matchedGeometryEffect(id: "tab", in: heroTab)
                
            }
            RoundedRectangle(cornerRadius: 8.w)
                .hidden()
                .overlay{
                    Text(name)
                        .textStyle(size: 14.w, color: name==selection ? .secondaryC : .gray.opacity(0.4))
                }
            
            
            
        }
        .onTapGesture{
            withAnimation {
                selection=name

            }
        }
        .animation(.spring(), value: selection)

        
    }
}
struct TabBar_Previews: PreviewProvider {
    struct Container: View{
        @State var selection = "Chats"
        let tabs:[String] = ["Chats","Request","Pending"]
        var body: some View{
            VStack{
                TabBar(selection: $selection, options: tabs)
                TabView(selection: $selection) {
                    ForEach(tabs, id:\.self){ tab in
                        Text(tab)
                            .textStyle(size: 14.w)
                            .tag(tab)
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
        }
    }
    static var previews: some View {
        Container()
    }
}
