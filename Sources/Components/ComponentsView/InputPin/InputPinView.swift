import UIKit
import SnapKit

public final class InputPinView: UIView, ComponentProtocol {
    
    public struct ViewProperties {
        public var items: [UIView]
        
        public init(
            items: [UIView] = []
        ) {
            self.items = items
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    private let hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 24
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
        updateSubviews(with: viewProperties)
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
}
