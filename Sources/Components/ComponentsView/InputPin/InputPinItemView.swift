import UIKit
import SnapKit

public final class InputPinItemView: UIView, ComponentProtocol {
    
    public struct ViewProperties {
        public var size: CGSize
        public var backgroundColor: UIColor
        public var cornerRadius: CGFloat
        
        public init(
            size: CGSize = .zero,
            backgroundColor: UIColor = .clear,
            cornerRadius: CGFloat = 0
        ) {
            self.size = size
            self.backgroundColor = backgroundColor
            self.cornerRadius = cornerRadius
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupView() {
        snp.makeConstraints { $0.size.equalTo(0) }
    }
    
    public func update(with viewProperties: ViewProperties) {
        layer.cornerRadius = viewProperties.cornerRadius
        updateSize(with: viewProperties)
        UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve) { [self] in
            backgroundColor = viewProperties.backgroundColor
        }
        self.viewProperties = viewProperties
    }
    
    private func updateSize(with viewProperties: ViewProperties) {
        guard self.viewProperties.size != viewProperties.size else { return }
        snp.updateConstraints { $0.size.equalTo(viewProperties.size) }
    }
}
