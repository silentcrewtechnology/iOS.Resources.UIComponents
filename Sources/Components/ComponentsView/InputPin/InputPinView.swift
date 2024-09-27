import UIKit
import SnapKit
import AccessibilityIds

public final class InputPinView: UIView, ComponentProtocol {
    
    public struct ViewProperties {
        public var items: [UIView]
        public var spacing: CGFloat
        public let accessibilityId: String?
        
        public init(
            items: [UIView] = [],
            spacing: CGFloat = 0,
            accessibilityId: String? = nil
        ) {
            self.items = items
            self.spacing = spacing
            self.accessibilityId = accessibilityId
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    private let hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        return stack
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupView() {
        addSubview(hStack)
        hStack.snp.makeConstraints {
            $0.verticalEdges.centerX.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
        }
    }
    
    public func update(with viewProperties: ViewProperties) {
        hStack.spacing = viewProperties.spacing
        updateSubviews(with: viewProperties)
        setupAccessibilityId(with: viewProperties)
        self.viewProperties = viewProperties
    }
    
    private func updateSubviews(with viewProperties: ViewProperties) {
        guard
            self.viewProperties.items.count != viewProperties.items.count
        else { return }
        hStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for item in viewProperties.items {
            hStack.addArrangedSubview(item)
        }
    }
    
    private func setupAccessibilityId(with viewProperties: ViewProperties) {
        isAccessibilityElement = true
        accessibilityIdentifier = viewProperties.accessibilityId
        hStack.isAccessibilityElement = true
        hStack.accessibilityIdentifier = DesignSystemAccessibilityIDs.InputPinView.itemsStack
    }
}
