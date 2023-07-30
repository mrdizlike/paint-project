//
//  File.swift
//  
//
//  Created by Виктор on 28.07.2023.
//

import Foundation
import UIKit

class ColorPickerView: UIViewController {
    var selectedColor = UIColor.red
    var mainView: PaintCentralSystem!
    var colorButtons: [UIButton]!
    
    var rSlider: UISlider!
    var gSlider: UISlider!
    var bSlider: UISlider!
    var chooseCustomColorButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interfaceInit()
        
    }
    
    func createColorButton(color: UIColor, position: CGPoint) -> UIButton {
        let buttonSize = CGSize(width: 50, height: 50)
        
        let button = UIButton(type: .system)
        button.frame = CGRect(origin: position, size: buttonSize)
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.backgroundColor = color
        button.layer.cornerRadius = buttonSize.width / 2
        button.addTarget(self, action: #selector(colorButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
        
        return button
    }
    
    @objc func colorButtonTapped(_ sender: UIButton) {
        var selectedOption: ColorsEnum
        
        switch sender {
        case colorButtons[0]:
            selectedOption = .red
        case colorButtons[1]:
            selectedOption = .blue
        case colorButtons[2]:
            selectedOption = .yellow
        case colorButtons[3]:
            selectedOption = .green
        default:
            selectedOption = .custom
        }
        
        switch selectedOption {
        case .custom:
            selectedColor = chooseCustomColorButton.backgroundColor!
        case .red:
            selectedColor = .systemRed
        case .blue:
            selectedColor = .systemBlue
        case .yellow:
            selectedColor = .systemYellow
        case .green:
            selectedColor = .systemGreen
        }
        
        updateButtonState()
    }
    
    @objc func sliderValueChanged() {
        let red = CGFloat(rSlider.value)
        let green = CGFloat(gSlider.value)
        let blue = CGFloat(bSlider.value)
        
        chooseCustomColorButton.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    //Выбираем собственный цвет
    @objc func chooseCustomColor() {
        selectedColor = chooseCustomColorButton.backgroundColor!
        updateButtonState()
    }

    //Обновляем вид интерфейса под соответсвующий контекст
    func updateButtonState() {
        mainView.selectedBrush.color = selectedColor.withAlphaComponent(mainView.selectedBrush.opacity)
        mainView.paintPanel.colorButton.backgroundColor = selectedColor
        dismiss(animated: true)
    }
    
    func interfaceInit() {
        view.backgroundColor = .systemBackground
        // Favorite Colors
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 100, width: view.bounds.width - 40, height: 30))
        titleLabel.text = "Favorite colors"
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        // Параметры кнопок
        let buttonSize = CGSize(width: 50, height: 50)
        let buttonSpacing: CGFloat = 20
        let initialButtonX = (view.bounds.width - CGFloat(4) * (buttonSize.width + buttonSpacing)) / 2
        
        // Кнопки с выбором цвета
        colorButtons = []
        colorButtons.append(createColorButton(color: .red, position: CGPoint(x: initialButtonX, y: titleLabel.frame.maxY + 20)))
        colorButtons.append(createColorButton(color: .blue, position: CGPoint(x: initialButtonX + buttonSize.width + buttonSpacing, y: titleLabel.frame.maxY + 20)))
        colorButtons.append(createColorButton(color: .yellow, position: CGPoint(x: initialButtonX + 2 * (buttonSize.width + buttonSpacing), y: titleLabel.frame.maxY + 20)))
        colorButtons.append(createColorButton(color: .green, position: CGPoint(x: initialButtonX + 3 * (buttonSize.width + buttonSpacing), y: titleLabel.frame.maxY + 20)))
        
        // Your Color
        let customColorLabel = UILabel(frame: CGRect(x: 20, y: 230, width: view.bounds.width - 40, height: 30))
        customColorLabel.text = "Your Color"
        customColorLabel.textAlignment = .center
        view.addSubview(customColorLabel)
        
        // Параметры слайдеров
        let sliderWidth = view.bounds.width - 100
        let sliderHeight: CGFloat = 31
        let sliderX: CGFloat = 50
        let sliderY = customColorLabel.frame.maxY + 50
        
        // Слайдер красного цвета
        rSlider = UISlider(frame: CGRect(x: sliderX, y: sliderY, width: sliderWidth, height: sliderHeight))
        rSlider.addTarget(self, action: #selector(sliderValueChanged), for: .allTouchEvents)
        rSlider.minimumValue = 0
        rSlider.maximumValue = 1
        rSlider.value = 0.2
        view.addSubview(rSlider)
        
        // Слайдер зеленого цвета
        gSlider = UISlider(frame: CGRect(x: sliderX, y: rSlider.frame.maxY + 20, width: sliderWidth, height: sliderHeight))
        gSlider.addTarget(self, action: #selector(sliderValueChanged), for: .allTouchEvents)
        gSlider.minimumValue = 0
        gSlider.maximumValue = 1
        gSlider.value = 0.2
        view.addSubview(gSlider)
        
        // Слайдер синего цвета
        bSlider = UISlider(frame: CGRect(x: sliderX, y: gSlider.frame.maxY + 20, width: sliderWidth, height: sliderHeight))
        bSlider.addTarget(self, action: #selector(sliderValueChanged), for: .allTouchEvents)
        bSlider.minimumValue = 0
        bSlider.maximumValue = 1
        bSlider.value = 0.2
        view.addSubview(bSlider)
        
        // RGB буквы
        let labelWidth: CGFloat = 20
        let labelHeight: CGFloat = 20
        let labelY = sliderY + (sliderHeight - labelHeight) / 2
        
        let rLabel = UILabel(frame: CGRect(x: sliderX - labelWidth - 5, y: labelY, width: labelWidth, height: labelHeight))
        rLabel.text = "R"
        rLabel.textColor = .systemRed
        view.addSubview(rLabel)
        
        let gLabel = UILabel(frame: CGRect(x: sliderX - labelWidth - 5, y: rSlider.frame.maxY + 20 + (sliderHeight - labelHeight) / 2, width: labelWidth, height: labelHeight))
        gLabel.text = "G"
        gLabel.textColor = .systemGreen
        view.addSubview(gLabel)
        
        let bLabel = UILabel(frame: CGRect(x: sliderX - labelWidth - 5, y: gSlider.frame.maxY + 20 + (sliderHeight - labelHeight) / 2, width: labelWidth, height: labelHeight))
        bLabel.text = "B"
        bLabel.textColor = .systemBlue
        view.addSubview(bLabel)
        
        // Кнопка выбора своего цвета
        chooseCustomColorButton = UIButton(type: .system)
        chooseCustomColorButton.frame = CGRect(x: 180, y: 500, width: buttonSize.width, height: buttonSize.height)
        chooseCustomColorButton.layer.borderWidth = 2.0
        chooseCustomColorButton.layer.borderColor = UIColor.lightGray.cgColor
        chooseCustomColorButton.backgroundColor = .red
        chooseCustomColorButton.layer.cornerRadius = buttonSize.width / 2
        chooseCustomColorButton.addTarget(self, action: #selector(chooseCustomColor), for: .touchUpInside)
        view.addSubview(chooseCustomColorButton)
    }
}

