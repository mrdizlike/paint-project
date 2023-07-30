//
//  File.swift
//  
//
//  Created by Виктор on 28.07.2023.
//

import UIKit

class BrushesView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var mainView: PaintCentralSystem!
    var tools: [DrawProtocol]!
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initBrushesView()
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
        let tool = tools[indexPath.row]
        
        cell.textLabel?.text = tool.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tool = tools[indexPath.row]
        buttonTapped(tool)
    }
    
    //Создаем заготовленные инструменты
    func initBrushesView() {
        tools = [Pencil(CGFloat(mainView.brushSize), 1, mainView.colorPickerView.selectedColor),
                 Brush(CGFloat(mainView.brushSize), 1, mainView.colorPickerView.selectedColor),
                 Eraser(CGFloat(mainView.brushSize), 1, mainView.drawingFrameView.backgroundColor!),
                 Marker(CGFloat(mainView.brushSize), 0.2, mainView.colorPickerView.selectedColor)
        ]
    }
    
    //Выбираем нужный инструмент
    func buttonTapped(_ brush: DrawProtocol) {
        mainView.selectedBrush = tools[brush.brushType.rawValue]
        if brush.color != mainView.drawingFrameView.backgroundColor! {
            mainView.selectedBrush.color = mainView.colorPickerView.selectedColor.withAlphaComponent(brush.opacity)
        } else {
            mainView.selectedBrush.color = brush.color
        }
        mainView.selectedBrush.size = CGFloat(mainView.paintPanel.slider.value)
        mainView.paintPanel.colorButton.isHidden = brush.colorButtonIsHide
        
        dismiss(animated: true)
        mainView.paintPanel.chooseBrushButton.setImage(UIImage(systemName: mainView.selectedBrush.iconName), for: .normal)
    }
}
