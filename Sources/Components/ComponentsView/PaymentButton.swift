import UIKit
import SnapKit

public class PaymentButton: UIView, ComponentProtocol {
    
    public struct ViewProperties {
        public var height: CGFloat
        public var backgroundColor: UIColor
        public var cornerRadius: CGFloat
        public var text: NSMutableAttributedString
        public var image: UIImage
        public var onTap: () -> Void
        
        public init(
            height: CGFloat = .zero,
            backgroundColor: UIColor = .clear,
            cornerRadius: CGFloat = .zero,
            text: NSMutableAttributedString = .init(string: ""),
            image: UIImage = .init(),
            onTap: @escaping () -> Void = { }
        ) {
            self.height = height
            self.cornerRadius = cornerRadius
            self.backgroundColor = backgroundColor
            self.text = text
            self.image = image
            self.onTap = onTap
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let logoView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private lazy var hStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            textLabel,
            logoView
        ])
        stack.alignment = .center
        stack.spacing = 8
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
            $0.center.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview().inset(16)
            $0.trailing.lessThanOrEqualToSuperview().inset(16)
        }
        snp.makeConstraints {
            $0.height.equalTo(0) // будет обновлено
        }
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonTapped)))
    }
    
    public func update(with viewProperties: ViewProperties) {
        updateSize(with: viewProperties)
        backgroundColor = viewProperties.backgroundColor
        layer.cornerRadius = viewProperties.cornerRadius
        textLabel.attributedText = viewProperties.text
        logoView.image = viewProperties.image
        self.viewProperties = viewProperties
    }
    
    private func updateSize(with viewProperties: ViewProperties) {
        guard self.viewProperties.height != viewProperties.height else { return }
        snp.updateConstraints {
            $0.height.equalTo(viewProperties.height)
        }
    }
    
    @objc private func buttonTapped() {
        viewProperties.onTap()
    }
}
