import UIKit

public final class SegmentSliderView: UIView, ComponentProtocol {
    
    public struct ViewProperties {
        public var backgroundColor: UIColor
        public var cornerRadius: CGFloat
        
        public init(
            backgroundColor: UIColor = .clear,
            cornerRadius: CGFloat = .zero
        ) {
            self.backgroundColor = backgroundColor
            self.cornerRadius = cornerRadius
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    public func update(with viewProperties: ViewProperties) {
        backgroundColor = viewProperties.backgroundColor
        layer.cornerRadius = viewProperties.cornerRadius
        self.viewProperties = viewProperties
    }
}
