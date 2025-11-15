import UIKit
import SnapKit
import AccessibilityIds

public final class InputPinView: UIView, ComponentProtocol {
    
    // MARK: - Properties
    
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
    
    // MARK: - Private properties
    
    private var viewProperties: ViewProperties = .init()
    
    private lazy var hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        
        return stack
    }()
    
    // MARK: - Life cycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Methods
    
    public func update(with viewProperties: ViewProperties) {
        hStack.spacing = viewProperties.spacing
        updateSubviews(with: viewProperties)
        setupAccessibilityId(with: viewProperties)
        
        self.viewProperties = viewProperties
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        addSubview(hStack)
        hStack.snp.makeConstraints {
            $0.verticalEdges.centerX.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
        }
    }
    
    private func updateSubviews(with viewProperties: ViewProperties) {
        guard self.viewProperties.items.count != viewProperties.items.count
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
