//
//  ChatBox.swift
//  Chat App
//
//  Created by Lalit Vinde on 04/09/23.
//

import SwiftUI
import FirebaseAuth
import Firebase
struct ChatBox: View {
    @StateObject var vm = ViewModel()
    @State var safeAreaInsets = UIEdgeInsets.zero
    @Environment(\.dismiss) var dismiss
    @State var height:CGFloat = 0.0
    @State var selectedMsgId:String = ""
    let user:User
    var body: some View {
        
        VStack(alignment:.leading){
            topBar
            MessagesList(forId: user.id, selectedMsgId: $selectedMsgId)
                        .zIndex(1)

            HStack(spacing:10.w){
                textView
                Button {
                    
                    vm.send(message: vm.text, toId: user.id)
                } label: {
                    send
                }
                
            }
            .padding(.horizontal, 30.w)
        }
        .padding(.bottom, safeAreaInsets.bottom == 0 ? 15.w : 0)

        
        .overlayPreferenceValue(MessagePreferenceKey.self) { value in
            
            if let value{
                ZStack{
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .onTapGesture {
                            self.selectedMsgId = ""
                        }

                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

                        
                    if let anchor = value.anchor{
                        GeometryReader{ proxy in
                            let proxy = proxy[anchor]
                            ChatBubble(message: value.message, showReactionPopUp: Binding(get: {
                                true
                            }, set: { val, _ in
                                if val==false{
                                    DispatchQueue.main.async {
                                        self.selectedMsgId = ""
                                    }
                                }
                            }))

                            .offset(x:proxy.origin.x, y:proxy.origin.y)
                            
                               
                                
                        }
                       
                        
                       
                    }
                    
                }
                .rotationEffect(Angle(degrees: 180))
                .rotation3DEffect(Angle(degrees: 180), axis: (x: 0, y: 1, z: 0))
                .transition(AnyTransition.opacity.animation(.spring()))
                .ignoresSafeArea()



            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if let windowScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }) {
                safeAreaInsets = windowScene.windows.first?.safeAreaInsets ?? UIEdgeInsets.zero
            }
        }
        
        
    }
    var textView:some View{
        ResizableTextField(text: $vm.text, height: $height)
            .overlay(alignment:.leading){
                Text("Message")
                    .textStyle(size: 14.w, color: .gray.opacity(0.5))
                    .padding(.leading,5.w)
                    .allowsHitTesting(false)
                    .opacity(vm.text.count>0 ? 0 : 1)
            }
            .frame(height: height < 100.w ? height : 100.w)
            .padding(.vertical, 9.w)
            .padding(.leading, 15.w)
        
            .background{
                RoundedRectangle(cornerRadius: 15.w)
                    .fill(Color.gray.opacity(0.1))
                
            }
    }
    var send:some View{
        Image(.IconsSet.send)
            .resizable()
            .scaledToFit()
            .foregroundColor(.gray)
            .frame(width: 30.w, height: 30.w)
    }
    var topBar:some View {
        HStack(alignment:.center){
            Image(systemName: "chevron.left")
                .resizable()
                .scaledToFit()
                .foregroundColor(.secondaryC)
                .padding(.vertical, 15.w)
                .padding(.trailing, 15.w)
                .onTapGesture {
                    dismiss()
                }
                
            
            ProfilePic(photoURL: user.photoURL)
            Text(user.name ?? "")
                .fontWeight(.bold)
                .textStyle(size: 14.w)
            
                .padding(.leading, 8.w)
            
            Spacer()
            
        }
        .frame(height: 50.w)
        .padding(.leading,20)
        .padding(.vertical,5.w)
    }
    
}


struct ResizableTextField: UIViewRepresentable{
    
    @Binding var text:String
    @Binding var height: CGFloat
    
    
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = true
        textView.isSelectable = true
        textView.font = .init(name: .FontSet.cascadia, size: 15.w)
        textView.backgroundColor = .clear
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text=text
        DispatchQueue.main.async {
            self.height = uiView.contentSize.height
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate{
        var parent : ResizableTextField
        init(parent: ResizableTextField) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            DispatchQueue.main.async {
                self.parent.height = textView.contentSize.height
                self.parent.text = textView.text
            }
        }
    }
    
}


struct ChatBox_Previews: PreviewProvider {
    struct Container: View{
        var body: some View{
            NavigationView{
                NavigationLink {
                    ChatBox(user: User())
                } label: {
                    ChatUserTile(user: User())
                    
                }
                
                
            }
        }
    }
    static var previews: some View {
        //        Container()
        ChatBox(user: User())
    }
}

