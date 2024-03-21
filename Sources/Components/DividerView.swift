import UIKit
import SnapKit

public final class DividerView: UIView {
    
    public struct ViewProperties {
        public var size: Size
        public var backgroundColor: UIColor
        
        public enum Size: Equatable {
            case width(CGFloat)
            case height(CGFloat)
        }
        
        public init(
            size: Size = .height(.zero),
            backgroundColor: UIColor = .clear
        ) {
            self.size = size
            self.backgroundColor = backgroundColor
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private var horizontalConstraint: Constraint?
    private var verticalConstraint: Constraint?
    
    private func setupView() {
        snp.makeConstraints {
            self.horizontalConstraint = $0.width.equalTo(0).constraint
            self.verticalConstraint = $0.height.equalTo(0).constraint
        }
        horizontalConstraint?.deactivate()
        verticalConstraint?.deactivate()
    }
    
    private var viewProperties: ViewProperties = .init()
    
    public func update(with viewProperties: ViewProperties) {
        updateSize(size: viewProperties.size)
        backgroundColor = viewProperties.backgroundColor
        self.viewProperties = viewProperties
    }
    
    private func updateSize(size: ViewProperties.Size) {
        guard self.viewProperties.size != size else { return }
        horizontalConstraint?.deactivate()
        verticalConstraint?.deactivate()
        switch size {
        case .width(let width):
            horizontalConstraint?.update(offset: width)
            horizontalConstraint?.activate()
        case .height(let height):
            verticalConstraint?.update(offset: height)
            verticalConstraint?.activate()
        }
    }
}
