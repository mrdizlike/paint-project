# paint-project

## Overview

**paint-project** component adds a toolbar that allows you to draw notes or simple sketches within your application.

## Usage
```swift
        //Create your canvas
    private lazy var paintView: DrawingView = {
        $0.backgroundColor = .gray
        $0.uiDelegate = self
        $0.showToolPanel = false
        return $0
    }(DrawingView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.addSubview(paintView) //Add paintView to your view
        paintView.initPaintSystem() //Init system
    }
    
    //Delegate for init
    extension ViewController: DrawingViewDelegate {
        func presentViewController() -> UIViewController {
            return self
        }
    
        func rectForToolPanel() -> CGRect {
            return CGRect(x: 50, y: 150, width: 300, height: 100)
        }
```

## Additional features
Access to undo and redo is as follows
```swift
paintView.undo() 
paintView.redo()
```
If you want to clear the screen
```swift
paintView.clean()
```

Save your masterpiece
```swift
paintView.save()
```
## Enjoy!
