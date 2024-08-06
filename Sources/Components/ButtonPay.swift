import UIKit
import SnapKit

public class ButtonPay: UIButton {
    
    // MARK: - Properties
    
    public struct ViewProperties {
        public var height: CGFloat
        public var maxWidth: CGFloat
        public var cornerRadius: CGFloat
        public var horizontalStackSpacing: CGFloat
        public var backgroundColor: UIColor
        public var text: NSMutableAttributedString
        public var image: UIImage
        public var stackViewInsets: UIEdgeInsets
        public var onTap: () -> Void
        
        public init(
            height: CGFloat = .zero,
            maxWidth: CGFloat = .zero,
            backgroundColor: UIColor = .clear,
            cornerRadius: CGFloat = .zero,
            horizontalStackSpacing: CGFloat = .zero,
            text: NSMutableAttributedString = .init(string: ""),
            image: UIImage = .init(),
            stackViewInsets: UIEdgeInsets = .zero,
            onTap: @escaping () -> Void = { }
        ) {
            self.height = height
            self.maxWidth = maxWidth
            self.cornerRadius = cornerRadius
            self.horizontalStackSpacing = horizontalStackSpacing
            self.backgroundColor = backgroundColor
            self.text = text
            self.image = image
            self.stackViewInsets = stackViewInsets
            self.onTap = onTap
        }
    }
    
    // MARK: - Private properties
    
    private lazy var hStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            textLabel,
            logoImageView
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
        
        setupView(viewProperties: viewProperties)
        backgroundColor = viewProperties.backgroundColor
        layer.cornerRadius = viewProperties.cornerRadius
        textLabel.attributedText = viewProperties.text
        logoImageView.image = viewProperties.image
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
            $0.width.lessThanOrEqualTo(viewProperties.maxWidth)
        }
        
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
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
