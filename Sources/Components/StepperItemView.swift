import UIKit

public final class StepperItemView: UIView {
    
    public struct ViewProperties {
        public var backgroundColor: UIColor
        
        public init(
            backgroundColor: UIColor = .clear
        ) {
            self.backgroundColor = backgroundColor
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    public func update(with viewProperties: ViewProperties) {
        backgroundColor = viewProperties.backgroundColor
        self.viewProperties = viewProperties
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
}
