//
//  View.swift
//  Clock
//
//  Created by Lalit Vinde on 27/07/23.
//
import SwiftUI

extension Shape{
    func innerShadow(color:Color, radius:Double, x:Double, y:Double)->some View{
        Canvas{ context, size in
            let path = self.path(in: CGRect(origin: .zero, size: size))
            context.fill(path, with: .color(color))
            context.blendMode = .destinationOut
            context.addFilter(
                .blur(
                    radius: radius
                )
            )
            context.fill(
                path.offsetBy(
                    dx: x,
                    dy: y
                ),
                with: .color(.black)
            )
        }
    }
}

