import Foundation
import UIKit

public class Pencil: DrawProtocol {
    public var id = BrushEnum.Pencil
    public var bezierPath: Line = Line(color: .red, path: UIBezierPath())
    var lastPoint: CGPoint?
    
    public let iconName = "pencil.circle"
    public let name = "Pencil"
    public var size: CGFloat = 34
    public var minSize: CGFloat = 1.0
    public var maxSize: CGFloat = 68
    public var opacity: Double = 1
    public var color = UIColor.red
    public var colorButtonIsHide = false
    
    var isFirst = true
    
    public init(_ size: CGFloat, _ opacity: Double, _ color: UIColor = UIColor.red) {
        self.size = size
        self.opacity = opacity
        self.color = color
    }
    
    public func initBezierPath() {
        bezierPath = Line(color: color, path: UIBezierPath())
        bezierPath.path.lineWidth = size
        bezierPath.path.lineCapStyle = CGLineCap.round
        bezierPath.path.lineJoinStyle = CGLineJoin.round
    }
    
    public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?, _ view: DrawingView) {
        let newPoint = touches.first!.location(in: view)
        initBezierPath()
        bezierPath.path.move(to: newPoint)
        lastPoint = newPoint
    }
    
    public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?, _ view: DrawingView) {
        let newPoint = touches.first!.location(in: view)
        
        let midPoint = CGPoint(x: (newPoint.x + lastPoint!.x) / 2, y: (newPoint.y + lastPoint!.y) / 2)
        bezierPath.path.addQuadCurve(to: midPoint, controlPoint: lastPoint!)
        
        lastPoint = newPoint
        
        view.setNeedsDisplay()
    }
    
    public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?, _ view: DrawingView) {
        let newPoint = touches.first!.location(in: view)
        bezierPath.path.addLine(to: newPoint)
        view.setNeedsDisplay()
    }
}
