import UIKit
import SnapKit

public final class InputOTPView: UIView {
    
    public struct ViewProperties {
        public var items: [InputOTPItemView.ViewProperties]
        public var hint: HintView.ViewProperties
        
        public init(
            items: [InputOTPItemView.ViewProperties] = [],
            hint: HintView.ViewProperties = .init()
        ) {
            self.items = items
            self.hint = hint
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    private let itemsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()
    
    private let hintView: HintView = HintView()
    
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
        createItems(count: viewProperties.items.count)
        updateItems(items: viewProperties.items)
        hintView.update(with: viewProperties.hint)
        self.viewProperties = viewProperties
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
}
