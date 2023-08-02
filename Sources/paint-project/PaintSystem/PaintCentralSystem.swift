import UIKit
import CoreGraphics

class PaintCentralSystem {
    let history = History()
    let numberFormatter = NumberFormatter()
    
    var mainView: UIViewController!
    var selectedBrush: DrawProtocol!
    var colorPickerView: ColorPickerView!
    var brushPickerView: BrushesView!
    var drawingFrameView: DrawingView!
    var paintPanel: PaintPanel!
    
    var brushSize: Float = 34.0
    
    //Инициализация системы
    init(canvas: DrawingView, paintPanel: PaintPanel) {
        drawingFrameView = canvas
        colorPickerView = ColorPickerView()
        brushPickerView = BrushesView()
        self.paintPanel = paintPanel
        colorPickerView.paintCentralSystem = self
        brushPickerView.paintCentralSystem = self
        drawingFrameView.paintCentralSystem = self
        drawingFrameView.image = UIImageView(frame: drawingFrameView.frame)
        drawingFrameView.addSubview(drawingFrameView.image)
    }
    
    // Слайдер размера кисти
    @objc func sizeSliderValueChanged() {
        brushSize = paintPanel.slider.value
        selectedBrush.size = CGFloat(paintPanel.slider.value)
        paintPanel.brushWidthSizeLabel.text = (numberFormatter.string(from: NSNumber(value: paintPanel.slider.value)) ?? "0") + " px"
        
    }
    
    //Открываем или закрываем вьюшку с выбором цвета. Делаю кастомный ColorPicker, потому что эппловский появился только в iOS 14
    @objc func colorButtonTap() {
        mainView.present(colorPickerView, animated: true)
    }
    
    //Возвращемся назад
    @objc func undoButtonTap() {
        if let lastPath = history.undoStack.popLast() {
            history.addRedoPath(lastPath)
            drawingFrameView.linePaths.removeLast()
            
            print(drawingFrameView.linePaths.count)
        }
        
        drawingFrameView.setNeedsDisplay()
    }
    
    //Возвращемся вперед
    @objc func redoButtonTap() {
        if let redoPath = history.redoStack.popLast() {
            history.addUndoPath(redoPath)
            drawingFrameView.linePaths.append(redoPath)
        }
        
        drawingFrameView.setNeedsDisplay()
    }
    
    //Очищаем экран
    @objc func cleanButtonTap() {
        history.redoStack.removeAll()
        drawingFrameView.linePaths.removeAll()
        paintPanel.undoButton.isEnabled = false
        paintPanel.redoButton.isEnabled = false
        
        drawingFrameView.setNeedsDisplay()
    }
    
    
    //Сохраняем свой шедевр
    @objc func saveButtonTap() {
        let items = [drawingFrameView.image.image]
        let ac = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
        mainView.present(ac, animated: true)
        
    }
    
    //Открываем вьюшку с выбором инструмента
    @objc func selectTypeBrush() {
        mainView.present(brushPickerView, animated: true)
    }
}
