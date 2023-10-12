//
//  Double.swift
//  Clock
//
//  Created by Lalit Vinde on 25/07/23.
//
import SwiftUI

extension Double{
    private static let factor = UnitPoint(x: UIScreen.main.bounds.size.width / 375, y: UIScreen.main.bounds.size.height / 812)

    var w:Double{
        return self * Self.factor.x
    }
    var h:Double{
        return self * Self.factor.y
    }
}
