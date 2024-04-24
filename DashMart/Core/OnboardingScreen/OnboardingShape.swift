//
//  OnboardingShape.swift
//  DashMart
//
//  Created by Ваня Науменко on 24.04.24.
//

import Foundation
import SwiftUI

struct OnboardingShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.01136*width, y: 0.90749*height))
        path.addLine(to: CGPoint(x: 0.01136*width, y: 0.06828*height))
        path.addCurve(to: CGPoint(x: 0.07244*width, y: 0.0022*height), control1: CGPoint(x: 0.01136*width, y: 0.02335*height), control2: CGPoint(x: 0.02699*width, y: 0.00227*height))
        path.addCurve(to: CGPoint(x: 0.90909*width, y: 0.0022*height), control1: CGPoint(x: 0.32718*width, y: 0.00184*height), control2: CGPoint(x: 0.85114*width, y: 0.00132*height))
        path.addCurve(to: CGPoint(x: 0.98722*width, y: 0.06828*height), control1: CGPoint(x: 0.96705*width, y: 0.00308*height), control2: CGPoint(x: 0.98532*width, y: 0.04662*height))
        path.addCurve(to: CGPoint(x: 0.98722*width, y: 0.8359*height), control1: CGPoint(x: 0.98627*width, y: 0.29405*height), control2: CGPoint(x: 0.98494*width, y: 0.76366*height))
        path.addCurve(to: CGPoint(x: 0.89347*width, y: 0.93062*height), control1: CGPoint(x: 0.98949*width, y: 0.90815*height), control2: CGPoint(x: 0.92566*width, y: 0.92915*height))
        path.addCurve(to: CGPoint(x: 0.08665*width, y: 0.98128*height), control1: CGPoint(x: 0.65483*width, y: 0.94787*height), control2: CGPoint(x: 0.15938*width, y: 0.98216*height))
        path.addCurve(to: CGPoint(x: 0.01136*width, y: 0.90749*height), control1: CGPoint(x: 0.01392*width, y: 0.9804*height), control2: CGPoint(x: 0.01136*width, y: 0.93392*height))
        path.closeSubpath()
        return path
    }
}
