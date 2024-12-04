import UIKit
import SnapKit

public final class StepperView: UIView, ComponentProtocol {
    
    // MARK: - Properties
    
    public struct ViewProperties {
        public var backgroundColor: UIColor
        public var itemViews: [UIView]
        public var stackViewSpacing: CGFloat
        public var stackViewInsets: UIEdgeInsets
        
        public init(
            backgroundColor: UIColor = .clear,
            itemViews: [UIView] = [],
            stackViewSpacing: CGFloat = .zero,
            stackViewInsets: UIEdgeInsets = .zero
        ) {
            self.backgroundColor = backgroundColor
            self.itemViews = itemViews
            self.stackViewSpacing = stackViewSpacing
            self.stackViewInsets = stackViewInsets
        }
    }
    
    // MARK: - Private properties
    
    private var viewProperties: ViewProperties = .init()
    
    private let itemsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        
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
        self.viewProperties = viewProperties
        
        setupStackView(with: viewProperties)
        addNewStepperItemsAndRemoveOld(with: viewProperties)
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        addSubview(itemsStackView)
        itemsStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupStackView(with viewProperties: ViewProperties) {
        addSubview(itemsStackView)
        itemsStackView.spacing = 4
        itemsStackView.snp.remakeConstraints {
            $0.edges.equalToSuperview().inset(viewProperties.stackViewInsets)
        }
    }
    
    private func addNewStepperItemsAndRemoveOld(with viewProperties: ViewProperties) {
        itemsStackView.arrangedSubviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        for itemView in viewProperties.itemViews {
            itemsStackView.addArrangedSubview(itemView)
        }
    }
}
