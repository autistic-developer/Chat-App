//
//  ReactionSelectionPopUpViewModel.swift
//  Chat App
//
//  Created by Lalit Vinde on 09/09/23.
//

import Foundation

extension ReactionSelectionPopUp{
    class ViewModel {
        @Injected(\.firestoreManager) var firestoreManager
        func addReaction(reactionIdx:Int ,toMessage:Message){
            Task{
               await firestoreManager.addReaction(reactionIdx: reactionIdx, toMessage: toMessage)
            }
        }
    }
}
