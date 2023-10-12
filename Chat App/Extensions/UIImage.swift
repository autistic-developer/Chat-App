//
//  UIImage.swift
//  Chat App
//
//  Created by Lalit Vinde on 17/08/23.
//

import Foundation
import UIKit
extension UIImage{

    convenience init?(url: String?) async throws{
        guard let url, let imgURL = URL(string: url) else{
            return nil
        }
        
        let (imgData, _) = try await URLSession.shared.data(from: imgURL)
        self.init(data: imgData)
        
    }
}
