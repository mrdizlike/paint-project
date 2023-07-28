//
//  File.swift
//  
//
//  Created by Виктор on 28.07.2023.
//

import Foundation
import UIKit

public class DrawingView: UIView {
    var history: History! = nil
    var mainView: PaintCentralSystem!
    
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
