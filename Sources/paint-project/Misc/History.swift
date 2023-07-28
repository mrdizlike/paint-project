//
//  File.swift
//  
//
//  Created by Виктор on 28.07.2023.
//

import Foundation
import UIKit

class History {
    var undoStack = [LineSet]()
    var redoStack = [LineSet]()
    
    func addUndoPath(_ path: LineSet) {
       undoStack.append(path)
    }
       
   func addRedoPath(_ path: LineSet) {
       redoStack.append(path)
   }
}
