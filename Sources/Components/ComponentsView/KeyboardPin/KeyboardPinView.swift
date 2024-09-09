import UIKit
import SnapKit

public final class KeyboardPinView: UIView, ComponentProtocol {
    
    public struct ViewProperties {
        public var keys: [UIView]
        public var bottomLeftView: UIView
        public var bottomRightView: UIView
        
        public init(
            keys: [UIView] = [],
            bottomLeftView: UIView = .init(),
            bottomRightView: UIView = .init()
        ) {
            self.keys = keys
            self.bottomLeftView = bottomLeftView
            self.bottomRightView = bottomRightView
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    private lazy var firstRowStack = hRowStack()
    private lazy var secondRowStack = hRowStack()
    private lazy var thirdRowStack = hRowStack()
    private lazy var fourthRowStack = hRowStack()
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            firstRowStack,
            secondRowStack,
            thirdRowStack,
            fourthRowStack
        ])
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupView() {
        addSubview(vStack)
        vStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(
                UIEdgeInsets(top: 0, left: 32, bottom: 24, right: 32)
            )
        }
    }
    
    public func update(with viewProperties: ViewProperties) {
        setupSubviews(with: viewProperties)
        self.viewProperties = viewProperties
    }
    
    private func setupSubviews(with viewProperties: ViewProperties) {
        guard
            viewProperties.keys.count == 10,
            self.viewProperties.keys.count != viewProperties.keys.count
        else { return }
        setupFirstRow(with: viewProperties)
        setupSecondRow(with: viewProperties)
        setupThirdRow(with: viewProperties)
        setupFourthRow(with: viewProperties)
    }
    
    private func setupFirstRow(with viewProperties: ViewProperties) {
        for pinKeyView in viewProperties.keys[0..<3] {
            firstRowStack.addArrangedSubview(wrapper(view: pinKeyView))
        }
    }
    
    private func setupSecondRow(with viewProperties: ViewProperties) {
        for pinKeyView in viewProperties.keys[3..<6] {
            secondRowStack.addArrangedSubview(wrapper(view: pinKeyView))
        }
    }
    
    private func setupThirdRow(with viewProperties: ViewProperties) {
        for pinKeyView in viewProperties.keys[6..<9] {
            thirdRowStack.addArrangedSubview(wrapper(view: pinKeyView))
        }
    }
    
    private func setupFourthRow(with viewProperties: ViewProperties) {
        let fourthRowViews = [
            viewProperties.bottomLeftView,
            viewProperties.keys[9],
            viewProperties.bottomRightView,
        ]
        for pinKeyView in fourthRowViews {
            fourthRowStack.addArrangedSubview(wrapper(view: pinKeyView))
        }
    }
    
    // MARK: - Wrappers
    
    private func hRowStack() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 0
        return stack
    }
    
    /// Для равномерного расползания по ширине
    private func wrapper(view: UIView) -> UIView {
        let wrapper = UIView()
        wrapper.addSubview(view)
        view.snp.makeConstraints {
            $0.leading.greaterThanOrEqualToSuperview()
            $0.top.centerX.bottom.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
        }
        return wrapper
    }
}
