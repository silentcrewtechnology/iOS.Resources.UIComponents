import UIKit
import SnapKit

public final class StepperView: UIView {
    
    public struct ViewProperties {
        public var items: [StepperItemView.ViewProperties]
        public var height: CGFloat
        
        public init(
            items: [StepperItemView.ViewProperties] = [],
            height: CGFloat = 0
        ) {
            self.items = items
            self.height = height
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    private let itemsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.distribution = .fillEqually
        return stack
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupView() {
        addSubview(itemsStack)
        itemsStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(viewProperties.height)
        }
    }
    
    public func update(with viewProperties: ViewProperties) {
        let itemViews = recreateItemViews(items: viewProperties.items)
        for (itemView, itemViewProperties) in zip(itemViews, viewProperties.items) {
            itemView.update(with: itemViewProperties)
        }
        itemsStack.snp.updateConstraints {
            $0.height.equalTo(viewProperties.height)
        }
        self.viewProperties = viewProperties
    }
    
    private func recreateItemViews(items: [StepperItemView.ViewProperties]) -> [StepperItemView] {
        itemsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let itemViews = (0..<items.count).map { _ in StepperItemView() }
        for itemView in itemViews {
            itemsStack.addArrangedSubview(itemView)
        }
        return itemViews
    }
}
