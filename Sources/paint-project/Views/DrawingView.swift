import Foundation
import UIKit

public class DrawingView: UIView {
    var history: History! = nil
    var mainView: PaintCentralSystem!
    var paintSystem: PaintSystem!
    var paintPanel: PaintPanel!
    
    public var uiDelegate: DrawingViewDelegate? //Делегат вьюшки
    public var showToolPanel = false //Нужна ли нам панель инструментов
    public var tool: DrawProtocol = Pencil(34, 1, .red) //Инструмент который будет по дефолту
    
    var linePaths: [LineSet] = []
    var image: UIImageView!
    private var lastPoint: CGPoint!
    
    //Отрисовка
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        history = mainView.history
        
        render()
        undoRedo()
    }
    
    //Как только нажимаем на экран, создаем новую линию
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mainView.selectedBrush.touchesBegan(touches, with: event, self)
        let newLineSet = LineSet(lines: [mainView.selectedBrush.bezierPath])
        linePaths.append(newLineSet)
        
        history.redoStack.removeAll()
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        mainView.selectedBrush.touchesMoved(touches, with: event, self)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        history.addUndoPath(linePaths.last!)
        
        mainView.selectedBrush.touchesEnded(touches, with: event, self)
        print(linePaths.count)
    }
    
    //Инициализация системы
    public func initPaintSystem() {
        frame = uiDelegate!.presentViewController().view.bounds
        paintSystem = PaintSystem()
        if showToolPanel {
            paintPanel = PaintPanel(frame: uiDelegate!.rectForToolPanel())
            paintSystem.PPinit(canvas: self, mainView: uiDelegate!.presentViewController(), paintPanel: paintPanel)
            paintSystem.PPcreatePanel(view: self, paintCentralSystem: paintSystem.paintCentralSystem, paintPanel: paintPanel)
        } else {
            paintPanel = PaintPanel(frame: CGRect(x: 50, y: 50, width: 300, height: 30))
            paintSystem.PPinit(canvas: self, mainView: uiDelegate!.presentViewController(), paintPanel: paintPanel)
            paintSystem.PPhidedPanel(view: self, paintCentralSystem: paintSystem.paintCentralSystem, paintPanel: paintPanel)
        }
        mainView.selectedBrush = tool
        mainView.paintPanel.chooseBrushButton.setImage(UIImage(systemName: mainView.selectedBrush.iconName), for: .normal)
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
            mainView.paintPanel.undoButton.isEnabled = true
        } else {
            mainView.paintPanel.undoButton.isEnabled = false
        }
        
        if history.redoStack.count > 0 {
            mainView.paintPanel.redoButton.isEnabled = true
        } else {
            mainView.paintPanel.redoButton.isEnabled = false
        }
    }
}
