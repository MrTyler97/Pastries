//
//  CornerBrackets.swift
//  Pastry Identifier
//

import SwiftUI

// Four rounded viewfinder corners
struct CornerBrackets: Shape {
    var cornerRadius: CGFloat = 30
    // Length of each bracket arm
    var length: CGFloat = 56

    func path(in rect: CGRect) -> Path {
        var path = Path()
        // Each corner: arm in, rounded turn, arm out
        let corners: [(CGPoint, CGPoint, CGPoint)] = [
            (CGPoint(x: rect.minX, y: rect.minY + length), CGPoint(x: rect.minX, y: rect.minY), CGPoint(x: rect.minX + length, y: rect.minY)),
            (CGPoint(x: rect.maxX - length, y: rect.minY), CGPoint(x: rect.maxX, y: rect.minY), CGPoint(x: rect.maxX, y: rect.minY + length)),
            (CGPoint(x: rect.maxX, y: rect.maxY - length), CGPoint(x: rect.maxX, y: rect.maxY), CGPoint(x: rect.maxX - length, y: rect.maxY)),
            (CGPoint(x: rect.minX + length, y: rect.maxY), CGPoint(x: rect.minX, y: rect.maxY), CGPoint(x: rect.minX, y: rect.maxY - length)),
        ]
        for (start, corner, end) in corners {
            path.move(to: start)
            path.addArc(tangent1End: corner, tangent2End: end, radius: cornerRadius)
            path.addLine(to: end)
        }
        return path
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        CornerBrackets()
            .stroke(.white, style: StrokeStyle(lineWidth: 4, lineCap: .round))
            .frame(width: 320, height: 320)
    }
}
