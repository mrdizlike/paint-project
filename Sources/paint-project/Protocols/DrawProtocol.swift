import Foundation
import UIKit

public protocol DrawProtocol {
    var id: BrushEnum { get set }
    var bezierPath: Line { get }
    
    var iconName: String { get }
    var name: String { get }
    var size: CGFloat { get set }
    var minSize: CGFloat { get set }
    var maxSize: CGFloat { get set }
    var color: UIColor { get set }
    var opacity: Double { get set}
    var colorButtonIsHide: Bool { get set }
    
    func initBezierPath()
    func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?, _ view: DrawingView)
    func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?, _ view: DrawingView)
    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?, _ view: DrawingView)
}
