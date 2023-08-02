import UIKit

public class PaintPanel: UIView {
    let undoButton = UIButton(type: .system)
    let redoButton = UIButton(type: .system)
    let saveButton = UIButton(type: .system)
    let chooseBrushButton = UIButton(type: .system)
    let colorButton = UIButton(type: .system)
    let cleanButton = UIButton(type: .system)
    let brushWidthSizeLabel = UILabel()
    let brushWidthLabel = UILabel()
    let slider = UISlider()
    
    override public init(frame: CGRect) {
        let customFrame = CGRect(x: frame.origin.x, y: frame.origin.y, width: 300, height: 100)
        let widthRatio = customFrame.width / 300
        let heightRatio = customFrame.height / 100

        super.init(frame: customFrame)
        
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 30
        self.clipsToBounds = true
        
        
        // Параметры кнопок
        let buttonSize = CGSize(width: 20, height: 20)
        let buttonY = 15
        
        // Кнопка undo
        undoButton.frame = CGRect(origin: CGPoint(x: 20 * widthRatio, y: CGFloat(buttonY) * heightRatio), size: buttonSize)
        undoButton.setImage(UIImage(systemName: "arrow.uturn.left"), for: .normal)
        self.addSubview(undoButton)
        
        // Кнопка redo
        redoButton.frame = CGRect(origin: CGPoint(x: 60 * widthRatio, y: CGFloat(buttonY) * heightRatio), size: buttonSize)
        redoButton.setImage(UIImage(systemName: "arrow.uturn.right"), for: .normal)
        self.addSubview(redoButton)
        
        // Кнопка save
        saveButton.frame = CGRect(origin: CGPoint(x: 90 * widthRatio, y: CGFloat(buttonY) * heightRatio), size: CGSize(width: 50 * widthRatio, height: buttonSize.height))
        saveButton.setTitle("Save", for: .normal)
        self.addSubview(saveButton)
        
        // Кнопка выбора кисти
        chooseBrushButton.frame = CGRect(origin: CGPoint(x: 170 * widthRatio, y: CGFloat(buttonY) * heightRatio), size: buttonSize)
        self.addSubview(chooseBrushButton)
        
        // Кнопка выбора цвета
        colorButton.frame = CGRect(origin: CGPoint(x: 200 * widthRatio, y: CGFloat(buttonY) * heightRatio), size: buttonSize)
        colorButton.layer.borderWidth = 2.0
        colorButton.layer.borderColor = UIColor.lightGray.cgColor
        colorButton.layer.cornerRadius = colorButton.frame.size.width / 2
        colorButton.backgroundColor = .red
        self.addSubview(colorButton)
        
        // Кнопка очистки полотна
        cleanButton.frame = CGRect(origin: CGPoint(x: 220 * widthRatio, y: CGFloat(buttonY) * heightRatio), size: CGSize(width: 70 * widthRatio, height: buttonSize.height))
        cleanButton.setTitle("Clear All", for: .normal)
        self.addSubview(cleanButton)
        
        brushWidthLabel.frame = CGRect(x: 10, y: 58, width: 100, height: 20)
        brushWidthLabel.text = "Weigth"
        self.addSubview(brushWidthLabel)
        
        brushWidthSizeLabel.frame = CGRect(x: 240 * widthRatio, y: 58 * heightRatio, width: 100 * widthRatio, height: 20 * heightRatio)
        brushWidthSizeLabel.text = "34 px"
        self.addSubview(brushWidthSizeLabel)
        
        // Слайдер размера кисти
        slider.frame = CGRect(x: 70 * widthRatio, y: 60 * heightRatio, width: 160 * widthRatio, height: 20 * heightRatio)
        slider.minimumValue = 1.0
        slider.maximumValue = 80.0
        slider.value = 34.0
        self.addSubview(slider)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
