import UIKit
import SnapKit

public final class ButtonAuth: UIButton, ComponentProtocol {
    
    // MARK: - Properties
    
    public struct ViewProperties {
        public var height: CGFloat
        public var minWidth: CGFloat
        public var cornerRadius: CGFloat
        public var horizontalStackSpacing: CGFloat
        public var backgroundColor: UIColor
        public var text: NSMutableAttributedString
        public var image: UIImage
        public var stackViewInsets: UIEdgeInsets
        public var onTap: () -> Void
        public var onHighlighted: (Bool) -> Void
        
        public init(
            height: CGFloat = .zero,
            minWidth: CGFloat = .zero,
            backgroundColor: UIColor = .clear,
            cornerRadius: CGFloat = .zero,
            horizontalStackSpacing: CGFloat = .zero,
            text: NSMutableAttributedString = .init(string: ""),
            image: UIImage = .init(),
            stackViewInsets: UIEdgeInsets = .zero,
            onTap: @escaping () -> Void = { },
            onHighlighted: @escaping (Bool) -> Void = { _ in }
        ) {
            self.height = height
            self.minWidth = minWidth
            self.cornerRadius = cornerRadius
            self.horizontalStackSpacing = horizontalStackSpacing
            self.backgroundColor = backgroundColor
            self.text = text
            self.image = image
            self.stackViewInsets = stackViewInsets
            self.onTap = onTap
            self.onHighlighted = onHighlighted
        }
    }
    
    public override var isHighlighted: Bool {
        didSet {
            viewProperties.onHighlighted(isHighlighted)
        }
    }
    
    // MARK: - Private properties
    
    private lazy var hStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            logoImageView,
            textLabel
        ])
        stack.alignment = .center
        
        return stack
    }()
    
    private lazy var textLabel = UILabel()
    private lazy var logoImageView = UIImageView()
    
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - Methods
    
    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
        
        layer.cornerRadius = viewProperties.cornerRadius
        logoImageView.image = viewProperties.image
        setupView(viewProperties: viewProperties)
        setupTextLabel(viewProperties: viewProperties)
        
        UIView.animate(withDuration: 0.1) {
            self.backgroundColor = viewProperties.backgroundColor
        }
    }
    
    // MARK: - Private methods

    private func setupView(viewProperties: ViewProperties) {
        removeConstraintsAndSubviews()
        
        addSubview(hStack)
        hStack.spacing = viewProperties.horizontalStackSpacing
        hStack.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview().inset(viewProperties.stackViewInsets)
            $0.trailing.lessThanOrEqualToSuperview().inset(viewProperties.stackViewInsets)
        }
        
        snp.makeConstraints {
            $0.height.equalTo(viewProperties.height)
            $0.width.greaterThanOrEqualTo(viewProperties.minWidth)
        }
        
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    private func setupTextLabel(viewProperties: ViewProperties) {
        textLabel.attributedText = viewProperties.text
        textLabel.isHidden = viewProperties.text.string.isEmpty
    }
    
    private func removeConstraintsAndSubviews() {
        subviews.forEach { subview in
            subview.snp.removeConstraints()
            subview.removeFromSuperview()
        }
    }
    
    @objc private func buttonTapped() {
        viewProperties.onTap()
    }
}
