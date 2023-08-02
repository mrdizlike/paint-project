import Foundation
import UIKit

public class DrawingView: UIView {
    var history: History! = nil
    var paintCentralSystem: PaintCentralSystem!
    var paintSystem: PaintSystem!
    var paintPanel: PaintPanel!
    
    public var uiDelegate: DrawingViewDelegate? //Делегат
    public var showToolPanel = false //Нужна ли нам панель инструментов
    public var tool: DrawProtocol = Pencil(34, 1, .red) //Инструмент который будет по дефолту
    
    var linePaths: [LineSet] = []
    var image: UIImageView!
    private var lastPoint: CGPoint!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        paintSystem = PaintSystem()
        paintPanel = PaintPanel()
        paintSystem.PPinit(canvas: self, mainView: UIViewController(), paintPanel: paintPanel)
        paintSystem.PPcreatePanel(view: self, paintCentralSystem: paintCentralSystem, paintPanel: paintPanel)
        paintCentralSystem.selectedBrush = tool
        history = paintCentralSystem.history
        paintCentralSystem.paintPanel.chooseBrushButton.setImage(UIImage(systemName: paintCentralSystem.selectedBrush.iconName), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Отрисовка
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        render()
        undoRedo()
    }
    
    // Вызываем panel() после добавления в иерархию представлений
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        panel()
    }
    
    //Как только нажимаем на экран, создаем новую линию
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        paintCentralSystem.selectedBrush.touchesBegan(touches, with: event, self)
        let newLineSet = LineSet(lines: [paintCentralSystem.selectedBrush.bezierPath])
        linePaths.append(newLineSet)
        
        history.redoStack.removeAll()
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        paintCentralSystem.selectedBrush.touchesMoved(touches, with: event, self)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        history.addUndoPath(linePaths.last!)
        
        paintCentralSystem.selectedBrush.touchesEnded(touches, with: event, self)
        print(linePaths.count)
    }
    
    public func setRect(rect: CGRect) {
        frame = rect
        image.frame = rect
    }
    
    public func undo() {
        paintCentralSystem.undoButtonTap()
    }
    
    public func redo() {
        paintCentralSystem.redoButtonTap()
    }
    
    public func clean() {
        paintCentralSystem.cleanButtonTap()
    }
    
    public func save() {
        paintCentralSystem.saveButtonTap()
    }
    
    //Настраиваем панель инструментов
    func panel() {
        if showToolPanel {
            paintPanel.frame = uiDelegate?.rectForToolPanel() ?? CGRect(x: 50, y: 150, width: 300, height: 100)
            paintCentralSystem.mainView = uiDelegate?.presentViewController() ?? UIViewController()
            paintPanel.isHidden = false
        } else {
            paintPanel.isHidden = true
        }
    }
    
    //Отображаем изображение на UIImage
    func render() {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        
        if UIGraphicsGetCurrentContext() != nil {
            for lineSet in linePaths {
                for line in lineSet.lines{
                    line.color.setStroke()
                    line.path.stroke()
                }
            }
        }
        
        let renderedImage = UIGraphicsGetImageFromCurrentImageContext()
        image.image = renderedImage
        
        
        UIGraphicsEndImageContext()
    }
    
    func undoRedo() {
        if linePaths.count > 0 {
            paintCentralSystem.paintPanel.undoButton.isEnabled = true
        } else {
            paintCentralSystem.paintPanel.undoButton.isEnabled = false
        }
        
        if history.redoStack.count > 0 {
            paintCentralSystem.paintPanel.redoButton.isEnabled = true
        } else {
            paintCentralSystem.paintPanel.redoButton.isEnabled = false
        }
    }
}
