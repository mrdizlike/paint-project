# paint-project

## Overview

**paint-project** component adds a toolbar that allows you to draw notes or simple sketches within your application.

## Usage
```swift
    @IBOutlet weak var canvas: DrawingView! // Your UIView with DrawingView class
    
    let PS = PaintSystem() //Create object of PaintSystem class
    let paintPanel = PaintPanel(frame: CGRect(x: 50, y: 150, width: 300, height: 100)) //Create panel with tools and options.
    PS.PPinit(canvas: canvas, mainView: self, paintPanel: paintPanel) //init your canvas
    PS.PPcreatePanel(view: self.view, paintCentralSystem: PS.paintCentralSystem, paintPanel: paintPanel) //init your paintPanel
```
