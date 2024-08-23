import UIKit
import SnapKit

public final class DividerView: UIView, ComponentProtocol {
    
    public struct ViewProperties {
        public var size: Size
        public var backgroundColor: UIColor
        
        public enum Size: Equatable {
            case width(CGFloat)
            case height(CGFloat)
            case size(CGSize)
        }
        
        public init(
            size: Size = .height(.zero),
            backgroundColor: UIColor = .clear
        ) {
            self.size = size
            self.backgroundColor = backgroundColor
        }
    }
    
    private var container = UIView()
    
    private enum ConstraintType: Int {
        case top
        case leading
        case trailing
        case bottom
        case topGreaterOrEqual
        case leadingGreaterOrEqual
        case trailingLessOrEqual
        case bottomLessOrEqual
        case width
        case height
    }
    
    public var containerConstraints: [Constraint] = []
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupView() {
        addSubview(container)
        container.snp.makeConstraints {
            $0.center.equalToSuperview()
            containerConstraints.append(contentsOf: [
                $0.top.equalToSuperview().constraint,
                $0.leading.equalToSuperview().constraint,
                $0.trailing.equalToSuperview().constraint,
                $0.bottom.equalToSuperview().constraint,
                $0.top.greaterThanOrEqualToSuperview().constraint,
                $0.leading.greaterThanOrEqualToSuperview().constraint,
                $0.trailing.lessThanOrEqualToSuperview().constraint,
                $0.bottom.lessThanOrEqualToSuperview().constraint,
                $0.width.equalTo(0).priority(.required).constraint,
                $0.height.equalTo(0).priority(.required).constraint
            ])
        }
        deactivateAllConstraints()
    }
    
    private func deactivateAllConstraints() {
        containerConstraints.forEach { $0.deactivate() }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
        updateSize(size: viewProperties.size)
        container.backgroundColor = viewProperties.backgroundColor
    }
    
    private func updateSize(size: ViewProperties.Size) {
        deactivateAllConstraints()
        
        switch size {
        case .width(let width):
            activateConstraints(for: [.width, .top, .bottom, .leadingGreaterOrEqual, .trailingLessOrEqual], offset: width)
        case .height(let height):
            activateConstraints(for: [.height, .leading, .trailing, .topGreaterOrEqual, .bottomLessOrEqual], offset: height)
        case .size(let size):
            containerConstraints[ConstraintType.width.rawValue].update(offset: size.width).activate()
            containerConstraints[ConstraintType.height.rawValue].update(offset: size.height).activate()
        }
    }
    
    private func activateConstraints(for types: [ConstraintType], offset: CGFloat) {
        types.forEach { type in
            containerConstraints[type.rawValue].activate()
        }
        if types.contains(.width) {
            containerConstraints[ConstraintType.width.rawValue].update(offset: offset)
        }
        if types.contains(.height) {
            containerConstraints[ConstraintType.height.rawValue].update(offset: offset)
        }
    }
}
