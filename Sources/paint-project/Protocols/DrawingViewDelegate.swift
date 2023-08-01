import Foundation
import UIKit

public protocol DrawingViewDelegate {
    func presentViewController() -> UIViewController
    func rectForToolPanel() -> CGRect
}
