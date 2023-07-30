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
    var brushType: BrushEnum = .Brush
    var colorButtonIsHide = false
    
    var isFirst = true
    
    //Переменные для физики кисти
    let lerpFactor: CGFloat = 0.98
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
        maxSize = size
        minSize = maxSize / 2
        
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
        
        let minSpeed: CGFloat = 10
        let maxSpeed: CGFloat = 1000.0
        
        let normalizedSpeed = max(min(speed, maxSpeed), minSpeed) / maxSpeed
        let brushSizeRange = maxSize - minSize
        
        if touch?.type == .stylus {
            let pressure = (touch?.force)!
            dynamicBrushSize = CGFloat(pressure)
        } else {
            dynamicBrushSize = maxSize - (brushSizeRange * normalizedSpeed)
        }
        
        // Степень сглаживания между линиями
        dynamicBrushSize = lerp(start: previousSize, end: dynamicBrushSize, t: lerpFactor)

        // Квадратичная линия безье
        let midPoint = CGPoint(x: (newPoint.x + lastPoint!.x) / 2, y: (newPoint.y + lastPoint!.y) / 2)
        
        if Int(previousSize) != Int(dynamicBrushSize) {
            bezierPath.path.addQuadCurve(to: midPoint, controlPoint: lastPoint!)
            initBezierPath()
            bezierPath.path.move(to: lastPoint!)
            bezierPath.path.lineWidth = dynamicBrushSize
            previousSize = dynamicBrushSize
            
            let lastIndex = view.linePaths.indices.last!
            view.linePaths[lastIndex].lines.append(bezierPath)
        }
        
        bezierPath.path.lineWidth = dynamicBrushSize
        bezierPath.path.addQuadCurve(to: midPoint, controlPoint: lastPoint!)
        
        lastPoint = newPoint
        previousTimestamp = currentTimestamp

        view.setNeedsDisplay()
    }
    
    
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?, _ view: DrawingView) {
        let newPoint = touches.first!.location(in: view)
        bezierPath.path.addLine(to: newPoint)
        view.setNeedsDisplay()
    }
}
