import UIKit

public class PaintSystem {
    public var paintCentralSystem: PaintCentralSystem!
    
    var brushView = UIViewController()
    var colorView = UIViewController()
    
    public init() {}
    
    public func PPcreatePanel(view: UIView,paintCentralSystem: PaintCentralSystem, paintPanel: PaintPanel) {
        paintPanel.undoButton.addTarget(paintCentralSystem, action: #selector(paintCentralSystem.undoButtonTap), for: .touchUpInside)
        paintPanel.redoButton.addTarget(paintCentralSystem, action: #selector(paintCentralSystem.redoButtonTap), for: .touchUpInside)
        paintPanel.saveButton.addTarget(paintCentralSystem, action: #selector(paintCentralSystem.saveButtonTap), for: .touchUpInside)
        paintPanel.chooseBrushButton.addTarget(paintCentralSystem, action: #selector(paintCentralSystem.selectTypeBrush), for: .touchUpInside)
        paintPanel.colorButton.addTarget(paintCentralSystem, action: #selector(paintCentralSystem.colorButtonTap), for: .touchUpInside)
        paintPanel.cleanButton.addTarget(paintCentralSystem, action: #selector(paintCentralSystem.cleanButtonTap), for: .touchUpInside)
        paintPanel.slider.addTarget(paintCentralSystem, action: #selector(paintCentralSystem.sizeSliderValueChanged), for: .allTouchEvents)
        view.addSubview(paintPanel)
    }
    
    public func PPhidedPanel(view: UIView,paintCentralSystem: PaintCentralSystem, paintPanel: PaintPanel) {
        paintPanel.slider.isHidden = true
        paintPanel.chooseBrushButton.isHidden = true
        paintPanel.colorButton.isHidden = true
        paintPanel.brushWidthSizeLabel.isHidden = true
        paintPanel.brushWidthLabel.isHidden = true
        paintPanel.layer.cornerRadius = 10
        paintPanel.undoButton.addTarget(paintCentralSystem, action: #selector(paintCentralSystem.undoButtonTap), for: .touchUpInside)
        paintPanel.redoButton.addTarget(paintCentralSystem, action: #selector(paintCentralSystem.redoButtonTap), for: .touchUpInside)
        paintPanel.saveButton.addTarget(paintCentralSystem, action: #selector(paintCentralSystem.saveButtonTap), for: .touchUpInside)
        paintPanel.cleanButton.addTarget(paintCentralSystem, action: #selector(paintCentralSystem.cleanButtonTap), for: .touchUpInside)
        view.addSubview(paintPanel)
    }
    
    public func PPinit(canvas: DrawingView, mainView: UIViewController, paintPanel: PaintPanel) {
        paintCentralSystem = PaintCentralSystem.init(canvas: canvas, mainView: mainView, paintPanel: paintPanel)
    }
}
