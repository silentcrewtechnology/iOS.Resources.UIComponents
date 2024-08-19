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
        guard touches.first?.nilIfHandledBySubview(of: self) != nil else {
            super.touchesBegan(touches, with: event)
            return
        }
        handlePress(state: .pressed)
    }
    
    public override func touchesEnded(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        guard let touch = touches.first?.nilIfHandledBySubview(of: self) else {
            super.touchesBegan(touches, with: event)
            return
        }
        if bounds.contains(touch.location(in: self)) {
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
        guard touches.first?.nilIfHandledBySubview(of: self) != nil else {
            super.touchesBegan(touches, with: event)
            return
        }
        handlePress(state: .cancelled)
    }
}

private extension UITouch {
    
    /// Returns `nil` if the `touch` will be handled by a subview
    func nilIfHandledBySubview(of view: UIView) -> UITouch? {
        for subview in view.subviews {
            if subview.isUserInteractionEnabled
            && subview.gestureRecognizers?.isEmpty == false
            && subview.bounds.contains(location(in: subview))
            || nilIfHandledBySubview(of: subview) == nil
            {
                return nil
            }
        }
        return self
    }
}
