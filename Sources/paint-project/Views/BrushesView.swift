//
//  File.swift
//  
//
//  Created by Виктор on 28.07.2023.
//

import UIKit

class BrushesView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var mainView: PaintCentralSystem!
    var tools: Array = [BrushEnum.Pencil, BrushEnum.Brush, BrushEnum.Eraser,BrushEnum.Marker]
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tools.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let tool = mainView.mainTools[BrushEnum(rawValue: indexPath.row)!]
        
        cell.textLabel?.text = tool?.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tool = tools[indexPath.row]
        buttonTapped(id: tool.rawValue)
    }
    
    //Выбираем нужный инструмент
    func buttonTapped(id: Int) {
        switch id {
        case BrushEnum.Pencil.rawValue:
            mainView.selectedBrush = mainView.mainTools[BrushEnum.Pencil]
            mainView.selectedBrush.color = mainView.colorPickerView.selectedColor
            mainView.selectedBrush.size = CGFloat(mainView.paintPanel.slider.value)
            mainView.paintPanel.colorButton.isHidden = false
            break
        case BrushEnum.Brush.rawValue:
            mainView.selectedBrush = mainView.mainTools[BrushEnum.Brush]
            mainView.selectedBrush.color = mainView.colorPickerView.selectedColor
            mainView.selectedBrush.size = CGFloat(mainView.paintPanel.slider.value)
            mainView.paintPanel.colorButton.isHidden = false
            break
        case BrushEnum.Eraser.rawValue:
            mainView.selectedBrush = mainView.mainTools[BrushEnum.Eraser]
            mainView.selectedBrush.size = CGFloat(mainView.paintPanel.slider.value)
            mainView.paintPanel.colorButton.isHidden = true
            break
        case BrushEnum.Marker.rawValue:
            mainView.selectedBrush = mainView.mainTools[BrushEnum.Marker]
            mainView.selectedBrush.color = mainView.colorPickerView.selectedColor.withAlphaComponent(mainView.selectedBrush.opacity)
            mainView.selectedBrush.size = CGFloat(mainView.paintPanel.slider.value)
            mainView.paintPanel.colorButton.isHidden = false
            break
        default: break
        }
        dismiss(animated: true)
        mainView.paintPanel.chooseBrushButton.setImage(UIImage(systemName: mainView.selectedBrush.iconName), for: .normal)
    }
}
