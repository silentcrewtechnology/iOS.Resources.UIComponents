import UIKit
import SnapKit
import AccessibilityIds

public final class InputOTPView: UIView, ComponentProtocol {
    
    public struct ViewProperties {
        public var items: [InputOTPItemView.ViewProperties]
        public var hint: OldHintView.ViewProperties
        public let accessibilityId: String?
        
        public init(
            items: [InputOTPItemView.ViewProperties] = [],
            hint: OldHintView.ViewProperties = .init(),
            accessibilityId: String? = nil
        ) {
            self.items = items
            self.hint = hint
            self.accessibilityId = accessibilityId
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    private let itemsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()
    
    private let hintView: OldHintView = OldHintView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupView() {
        addSubview(itemsStack)
        itemsStack.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
        }
        addSubview(hintView)
        hintView.snp.makeConstraints {
            $0.top.equalTo(itemsStack.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview()
        }
    }
    
    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
        createItems(count: viewProperties.items.count)
        updateItems(items: viewProperties.items)
        hintView.update(with: viewProperties.hint)
        setupAccessibilityId(with: viewProperties)
    }
    
    private func createItems(count: Int) {
        guard count != itemsStack.arrangedSubviews.count else { return }
        itemsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for _ in 0..<count {
            itemsStack.addArrangedSubview(InputOTPItemView())
        }
    }
    
    private var itemViews: [InputOTPItemView] {
        itemsStack.arrangedSubviews.compactMap { $0 as? InputOTPItemView }
    }
    
    private func updateItems(items: [InputOTPItemView.ViewProperties]) {
        for (itemView, item) in zip(itemViews, items) {
            itemView.update(with: item)
        }
    }
    
    private func setupAccessibilityId(with viewProperties: ViewProperties) {
        isAccessibilityElement = true
        accessibilityIdentifier = viewProperties.accessibilityId
        itemsStack.isAccessibilityElement = true
        itemsStack.accessibilityIdentifier = DesignSystemAccessibilityIDs.InputOTPView.itemsStack
    }
}
