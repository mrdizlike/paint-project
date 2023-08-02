import Foundation
import UIKit

public class History {
    var undoStack = [LineSet]()
    var redoStack = [LineSet]()
    
    func addUndoPath(_ path: LineSet) {
       undoStack.append(path)
    }
       
   func addRedoPath(_ path: LineSet) {
       redoStack.append(path)
   }
}
