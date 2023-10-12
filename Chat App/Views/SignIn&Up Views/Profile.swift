//
//  Profile.swift
//  Chat App
//
//  Created by Lalit Vinde on 13/08/23.
//

import SwiftUI

struct Profile: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var vm:ViewModel = ViewModel()
    let isEditView:Bool
    
    init(isEditView:Bool = false) {
        self.isEditView = isEditView
    }
    var body: some View {
        VStack(spacing: 0){
            if(isEditView){
                HStack{
                    BackButton()
                        .onTapGesture {
                            dismiss()
                        }
                    Spacer()
                    
                }
                .padding(.top,20)
                .padding(.leading,20)
            }
            
            Spacer()
            
            //MARK: profile pic
            profileView
                .sheet(isPresented: $vm.isSheetPresented) {
                    ImagePicker(img: $vm.profilePic, isSelected: Binding<Bool>(get: {
                        vm.isProfilePicSelected
                    }, set: { val in
                        vm.isProfilePicSelected = val
                    })
                    )
                }
                .padding(.horizontal, 40.w)
            Spacer()
            VStack(spacing:16.w){
                //MARK: name field
                TextField(placeHolder: "Enter name", text: Binding<String>(
                    get: {
                        vm.name
                        
                    },
                    set: { newValue,_ in
                        vm.name = String(newValue.drop(while: { char in
                            char.isWhitespace
                        }))
                    }),
                          isValid: $vm.isNameValid
                )
                .frame(width: 319.w, height: 54.w)
                
                //MARK: status field
                TextField(placeHolder: "Status", text:Binding<String>(
                    get: {
                        vm.status
                        
                    },
                    set: { newValue,_ in
                        vm.status = String(newValue.drop(while: { char in
                            char.isWhitespace
                        }))
                    }), isValid: $vm.isStatusValid)
                .frame(width: 319.w, height: 54.w)
            }
            
            Spacer()
            
            Button{
                if (vm.onComplete()){
                    dismiss()
                }
            }
        label:{
            RoundedRectangle(cornerRadius: 8.w)
                .overlay{
                    Text(isEditView ? "**Save**" : "**Complete**")
                        .textStyle(size: 16.w, color: .white)
                }
                .frame(width: 319.w, height: 54.w)
            
        }
        .padding(.vertical, 20.w)
            
        }
        
        .backgroundColor()
        .alert(alertMsg: vm.alertMsg, isAlertPresented: $vm.isAlertPresented)
        .progressView(isVisible: $vm.isProgressViewVisible)
        
        .navigationBarBackButtonHidden(true)
        
    }
    
    //MARK: profile pic
    @ViewBuilder
    var profileView: some View {
        ZStack(alignment: .bottomTrailing){
            if (vm.profilePic != nil){
                Image(uiImage: vm.profilePic!)
                
                
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.secondaryC.opacity(0.4))
                    .clipShape(Circle())
            }
            else{
                ProfilePic(photoURL: vm.photoURL)
            }
            Circle()
                .fill(Color.secondaryC)
                .frame(width: 50.w, height: 50.w)
                .overlay{
                    Image(.IconsSet.edit)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 25.w, height: 25.w)
                }
                .onTapGesture {
                    vm.isSheetPresented.toggle()
                }
        }
        .frame(width: 190.w, height: 190.w)
        
        
    }
}


struct ImagePicker : UIViewControllerRepresentable{
    let img: Binding<UIImage?>
    let isSelected: Binding<Bool>
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let viewController = UIImagePickerController()
        viewController.allowsEditing=true
        viewController.delegate=context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(img: img, isSelected: isSelected)
    }
    
    class Coordinator : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
        let img: Binding<UIImage?>
        let isSelected: Binding<Bool>
        
        init(img: Binding<UIImage?>, isSelected:Binding<Bool>) {
            self.img = img
            self.isSelected = isSelected
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let editedImage = info[.editedImage] as? UIImage else{
                return picker.dismiss(animated: true)
            }
            img.wrappedValue=editedImage
            isSelected.wrappedValue=true
            picker.dismiss(animated: true)
            
        }
    }
    
}

struct Profile_Previews: PreviewProvider {
    
    struct Container: View{
        @StateObject var userViewModel = UserViewModel()
        
        var body: some View{
            NavigationView{
                Profile(isEditView: false)
            }
            .environmentObject(userViewModel)
        }
    }
    static var previews: some View {
        Container()
    }
}
