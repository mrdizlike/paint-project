//
//  File.swift
//  
//
//  Created by Виктор on 28.07.2023.
//

import Foundation
import UIKit

class Brush: DrawProtocol {
    var id = BrushEnum.Brush
    var bezierPath: Line = Line(color: .red, path: UIBezierPath())
    var lastPoint: CGPoint?
    
    let iconName = "paintbrush"
    let name = "Brush"
    var size: CGFloat = 34
    var minSize: CGFloat = 1.0
    var maxSize: CGFloat = 68
    var opacity: Double = 1
    var color = UIColor.red
    
    var isFirst = true
    
    //Переменные для физики кисти
    var dynamicBrushSize: CGFloat = 0
    var previousTimestamp: TimeInterval?
    var previousSize: CGFloat = 0
    
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
        previousSize = size
    }
    
    //Интерполяция для сглаживания перехода между размерами кисти
    func lerp(start: CGFloat, end: CGFloat, t: CGFloat) -> CGFloat {
        return start + t * (end - start)
    }
    
    
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?, _ view: DrawingView) {
        let touch: AnyObject? = touches.first
        let newPoint = touch!.location(in: view)
        
        let currentTimestamp = event?.timestamp ?? 0.0
        
        let deltaTime = currentTimestamp - (previousTimestamp ?? currentTimestamp)
        let distance = sqrt(pow(newPoint.x - (lastPoint!.x), 2) + pow(newPoint.y - (lastPoint!.y), 2))
        let speed = distance / CGFloat(deltaTime)
        
        let minSpeed: CGFloat = 100
        let maxSpeed: CGFloat = 1000.0
        maxSize = size
        
        let normalizedSpeed = max(min(speed, maxSpeed), minSpeed) / maxSpeed
        let brushSizeRange = maxSize - minSize
        
        if touch?.type == .stylus {
            let pressure = (touch?.force)!
            dynamicBrushSize = CGFloat(pressure)
        } else {
            previousSize = maxSize - (brushSizeRange * normalizedSpeed)
        }
        
        // Степень сглаживания между линиями
        let lerpFactor: CGFloat = 0.9
        dynamicBrushSize = lerp(start: previousSize, end: dynamicBrushSize, t: lerpFactor)
        
        if let prevPoint = lastPoint {
            // Кубическая линия безье
            let midPoint1 = CGPoint(x: (prevPoint.x + newPoint.x) / 2, y: (prevPoint.y + newPoint.y) / 2)
            let midPoint2 = CGPoint(x: (midPoint1.x + newPoint.x) / 2, y: (midPoint1.y + newPoint.y) / 2)
            
            initBezierPath()
            
            bezierPath.path.move(to: prevPoint)
            bezierPath.path.lineWidth = dynamicBrushSize
            bezierPath.path.addCurve(to: midPoint2, controlPoint1: midPoint1, controlPoint2: midPoint1)
            bezierPath.path.addCurve(to: newPoint, controlPoint1: midPoint2, controlPoint2: midPoint2)
            
            previousSize = dynamicBrushSize
        }
        
        lastPoint = newPoint
        previousTimestamp = currentTimestamp
        
        let lastIndex = view.linePaths.indices.last!
        
        view.linePaths[lastIndex].lines.append(bezierPath)
        view.setNeedsDisplay()
    }
    
    
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?, _ view: DrawingView) {
        let newPoint = touches.first!.location(in: view)
        bezierPath.path.addLine(to: newPoint)
        view.setNeedsDisplay()
    }
}
