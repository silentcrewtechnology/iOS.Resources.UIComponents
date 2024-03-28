import UIKit

public class PressableView: UIView {
    
    public enum State {
        case pressed
        case unpressed
        case cancelled
    }
    
    public func handlePress(state: State) { }
    
    public override func touchesBegan(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        super.touchesBegan(touches, with: event)
        handlePress(state: .pressed)
    }
    
    public override func touchesEnded(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        super.touchesEnded(touches, with: event)
        guard let location = touches.first?.location(in: self) else { return }
        if bounds.contains(location) {
            handlePress(state: .unpressed)
        } else {
            // перетянули палец за пределы вью
            handlePress(state: .cancelled)
        }
    }
    
    public override func touchesCancelled(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        super.touchesCancelled(touches, with: event)
        handlePress(state: .cancelled)
    }
}
