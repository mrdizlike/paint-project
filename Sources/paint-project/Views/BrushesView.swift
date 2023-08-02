import UIKit

class BrushesView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var paintCentralSystem: PaintCentralSystem!
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
        tools = [Pencil(CGFloat(paintCentralSystem.brushSize), 1, paintCentralSystem.colorPickerView.selectedColor),
                 Brush(CGFloat(paintCentralSystem.brushSize), 1, paintCentralSystem.colorPickerView.selectedColor),
                 Eraser(CGFloat(paintCentralSystem.brushSize), 1, paintCentralSystem.drawingFrameView.backgroundColor!),
                 Marker(CGFloat(paintCentralSystem.brushSize), 0.2, paintCentralSystem.colorPickerView.selectedColor)
        ]
    }
    
    //Выбираем нужный инструмент
    func buttonTapped(_ brush: DrawProtocol) {
        paintCentralSystem.selectedBrush = tools[brush.id.rawValue]
        if brush.color != paintCentralSystem.drawingFrameView.backgroundColor! {
            paintCentralSystem.selectedBrush.color = paintCentralSystem.colorPickerView.selectedColor.withAlphaComponent(brush.opacity)
        } else {
            paintCentralSystem.selectedBrush.color = brush.color
        }
        paintCentralSystem.selectedBrush.size = CGFloat(paintCentralSystem.paintPanel.slider.value)
        paintCentralSystem.paintPanel.colorButton.isHidden = brush.colorButtonIsHide
        
        dismiss(animated: true)
        paintCentralSystem.paintPanel.chooseBrushButton.setImage(UIImage(systemName: paintCentralSystem.selectedBrush.iconName), for: .normal)
    }
}
