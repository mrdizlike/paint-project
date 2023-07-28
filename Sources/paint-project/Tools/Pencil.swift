//
//  File.swift
//  
//
//  Created by Виктор on 28.07.2023.
//

import Foundation
import UIKit

class Pencil: DrawProtocol {
    var id = BrushEnum.Pencil
    var bezierPath: Line = Line(color: .red, path: UIBezierPath())
    var lastPoint: CGPoint?
    
    let iconName = "pencil.circle"
    let name = "Pencil"
    var size: CGFloat = 34
    var minSize: CGFloat = 1.0
    var maxSize: CGFloat = 68
    var opacity: Double = 1
    var color = UIColor.red
    
    var isFirst = true
    
    init(_ size: CGFloat, _ opacity: Double, _ color: UIColor = UIColor.red) {
        self.size = size
        self.opacity = opacity
        self.color = color
    }
    
    func initBezierPath() {
        bezierPath = Line(color: color, path: UIBezierPath())
        bezierPath.path.lineWidth = size
        bezierPath.path.lineCapStyle = CGLineCap.round
        bezierPath.path.lineJoinStyle = CGLineJoin.round
    }
    
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?, _ view: DrawingView) {
        let newPoint = touches.first!.location(in: view)
        initBezierPath()
        bezierPath.path.move(to: newPoint)
        lastPoint = newPoint
    }
    
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?, _ view: DrawingView) {
        let newPoint = touches.first!.location(in: view)
        
        if let prevPoint = lastPoint {
            let midPoint = CGPoint(x: (newPoint.x + prevPoint.x) / 2, y: (newPoint.y + prevPoint.y) / 2)
            bezierPath.path.addQuadCurve(to: midPoint, controlPoint: prevPoint)
        }
        lastPoint = newPoint
        
        view.setNeedsDisplay()
    }
    
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?, _ view: DrawingView) {
        let newPoint = touches.first!.location(in: view)
        bezierPath.path.addLine(to: newPoint)
        view.setNeedsDisplay()
    }
}
