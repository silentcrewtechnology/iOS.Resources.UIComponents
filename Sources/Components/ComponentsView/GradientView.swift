import UIKit

public final class GradientView: UIView, ComponentProtocol {
    
    // MARK: - Properties
    
    public struct ViewProperties {
        public var startPoint: CGPoint
        public var endPoint: CGPoint
        public var colors: [Any]?
        public var insets: UIEdgeInsets
        
        public init(
            startPoint: CGPoint = .zero,
            endPoint: CGPoint = .zero,
            colors: [Any]? = nil,
            insets: UIEdgeInsets = .zero
        ) {
            self.startPoint = startPoint
            self.endPoint = endPoint
            self.colors = colors
            self.insets = insets
        }
    }
    
    // MARK: - Private properties
    
    private lazy var gradientLayer: CAGradientLayer = {
        let result = CAGradientLayer()
        self.layer.addSublayer(result)
         
        return result
    }()
    
    // MARK: - Life cycle

    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.gradientLayer.frame = self.bounds
    }
    
    // MARK: - Methods
    
    public func update(with viewProperties: ViewProperties) {
        gradientLayer.startPoint = viewProperties.startPoint
        gradientLayer.endPoint = viewProperties.endPoint
        gradientLayer.colors = viewProperties.colors
    }
}
