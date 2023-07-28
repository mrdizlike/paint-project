import UIKit
import CoreGraphics

public class PaintCentralSystem {
    let history = History()
    let numberFormatter = NumberFormatter()
    
    var mainView: UIViewController!
    var selectedBrush: DrawProtocol!
    var brushesEnum: BrushEnum!
    var mainTools: Dictionary<BrushEnum, DrawProtocol> = [:]
    var colorPickerView: ColorPickerView!
    var brushPickerView: BrushesView!
    var drawingFrameView: DrawingView!
    var paintPanel: PaintPanel!
    
    var brushSize: Float = 34.0
    
    public init() {
    }
    
    // Слайдер размера кисти
    @objc func sizeSliderValueChanged() {
        brushSize = paintPanel.slider.value
        selectedBrush.size = CGFloat(paintPanel.slider.value)
        paintPanel.brushWidthSizeLabel.text = (numberFormatter.string(from: NSNumber(value: paintPanel.slider.value)) ?? "0") + " px"
        
    }
    
    @objc func colorButtonTap() { //Открываем или закрываем вьюшку с выбором цвета. Делаю кастомный ColorPicker, потому что эппловский появился только в iOS 14
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
    
    //Создаем заготовленные инструменты
    func initBrushesView() {
        mainTools[BrushEnum.Pencil] = Pencil(CGFloat(brushSize), 1, colorPickerView.selectedColor)
        
        mainTools[BrushEnum.Brush] = Brush( CGFloat(brushSize),  1, colorPickerView.selectedColor)
        
        mainTools[BrushEnum.Eraser] = Eraser(CGFloat(brushSize), 1, drawingFrameView.backgroundColor!)
        
        mainTools[BrushEnum.Marker] = Marker( CGFloat(brushSize), 0.2, colorPickerView.selectedColor.withAlphaComponent(0.2))
    }
    
    //Иницилизируем систему
    func initPaintSystem(canvas: DrawingView, mainView: UIViewController, paintPanel: PaintPanel) {
        drawingFrameView = canvas
        self.mainView = mainView
        selectedBrush = Pencil(34, 1)
        colorPickerView = ColorPickerView()
        brushPickerView = BrushesView()
        self.paintPanel = paintPanel
        colorPickerView.mainView = self
        brushPickerView.mainView = self
        drawingFrameView.mainView = self
        drawingFrameView.image = UIImageView(frame: drawingFrameView.frame)
        drawingFrameView.addSubview(drawingFrameView.image)
        self.paintPanel.chooseBrushButton.setImage(UIImage(systemName: selectedBrush.iconName), for: .normal)
        initBrushesView()
    }
}
