//
//  File.swift
//  Clock
//
//  Created by Lalit Vinde on 25/07/23.
//

import SwiftUI

enum Command: Equatable{
    case M(x: Double, y: Double)  // MoveTo (absolute)
    case L(x: Double, y: Double)  // LineTo (absolute)
    case C(x1: Double, y1: Double, x2: Double, y2: Double, x: Double, y: Double)  // CubicBezierCurveTo (absolute)
    case Z  // ClosePath (absolute)
}
struct FigmaShape:Shape{
    let commands:[Command]
    let angle:Angle?
    let anchor:UnitPoint?
    
    init(commands: [Command], angle: Angle?=nil, anchor: UnitPoint?=nil) {
        self.commands = commands
        self.angle = angle
        self.anchor = anchor
    }
    
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        var path:Path=Path()
        for command in commands {
            switch command {
            case .M(let x, let y):
                path.move(to: CGPoint(x: x*w, y: y*w))
            case .L(let x, let y):
                path.addLine(to: CGPoint(x: x*w, y: y*w))
            case .C(let x1, let y1, let x2, let y2, let x, let y):
                path.addCurve(to: CGPoint(x: x*w, y: y*w), control1: CGPoint(x: x1*w, y: y1*w), control2: CGPoint(x: x2*w, y: y2*w))
            case .Z:
                path.closeSubpath()
            }
        }
        if let angle, let anchor{
            path=path.rotation(angle, anchor: anchor).path(in: path.boundingRect)
        }
        return path
    }
}

