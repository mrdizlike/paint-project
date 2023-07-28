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
    
    //Выбираем красный цвет
    @objc func chooseRedColor() {
        selectedColor = .systemRed
        updateButtonState()
    }
    
    //Выбираем синий цвет
    @objc func chooseBlueColor() {
        selectedColor = .systemBlue
        updateButtonState()
    }
    
    //Выбираем желтый цвет
    @objc func chooseYellowColor() {
        selectedColor = .systemYellow
        updateButtonState()
    }
    
    //Выбираем зеленый цвет
    @objc func chooseGreenColor() {
        selectedColor = .systemGreen
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
        
        // Красный цвет
        let redButton = UIButton(type: .system)
        redButton.frame = CGRect(origin: CGPoint(x: initialButtonX, y: titleLabel.frame.maxY + 20), size: buttonSize)
        redButton.layer.borderWidth = 2.0
        redButton.layer.borderColor = UIColor.lightGray.cgColor
        redButton.backgroundColor = .red
        redButton.layer.cornerRadius = buttonSize.width / 2
        redButton.addTarget(self, action: #selector(chooseRedColor), for: .touchUpInside)
        view.addSubview(redButton)
        
        // Синий цвет
        let blueButton = UIButton(type: .system)
        blueButton.frame = CGRect(origin: CGPoint(x: initialButtonX + buttonSize.width + buttonSpacing, y: titleLabel.frame.maxY + 20), size: buttonSize)
        blueButton.layer.borderWidth = 2.0
        blueButton.layer.borderColor = UIColor.lightGray.cgColor
        blueButton.backgroundColor = .blue
        blueButton.layer.cornerRadius = buttonSize.width / 2
        blueButton.addTarget(self, action: #selector(chooseBlueColor), for: .touchUpInside)
        view.addSubview(blueButton)
        
        // Желтый цвет
        let yellowButton = UIButton(type: .system)
        yellowButton.frame = CGRect(origin: CGPoint(x: initialButtonX + 2 * (buttonSize.width + buttonSpacing), y: titleLabel.frame.maxY + 20), size: buttonSize)
        yellowButton.layer.borderWidth = 2.0
        yellowButton.layer.borderColor = UIColor.lightGray.cgColor
        yellowButton.backgroundColor = .yellow
        yellowButton.layer.cornerRadius = buttonSize.width / 2
        yellowButton.addTarget(self, action: #selector(chooseYellowColor), for: .touchUpInside)
        view.addSubview(yellowButton)
        
        // Зеленый цвет
        let greenButton = UIButton(type: .system)
        greenButton.frame = CGRect(origin: CGPoint(x: initialButtonX + 3 * (buttonSize.width + buttonSpacing), y: titleLabel.frame.maxY + 20), size: buttonSize)
        greenButton.layer.borderWidth = 2.0
        greenButton.layer.borderColor = UIColor.lightGray.cgColor
        greenButton.backgroundColor = .green
        greenButton.layer.cornerRadius = buttonSize.width / 2
        greenButton.addTarget(self, action: #selector(chooseGreenColor), for: .touchUpInside)
        view.addSubview(greenButton)
        
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

