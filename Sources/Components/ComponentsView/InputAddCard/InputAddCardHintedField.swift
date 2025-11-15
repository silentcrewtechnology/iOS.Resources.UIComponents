import UIKit
import SnapKit

public final class InputAddCardHintedField: UIView, ComponentProtocol {
    
    public struct ViewProperties {
        public var textFieldViewProperties: InputTextField.ViewProperties
        public var hint: NSMutableAttributedString
        public var insets: UIEdgeInsets
        public var spacing: CGFloat
        
        public init(
            textFieldViewProperties: InputTextField.ViewProperties = .init(),
            hint: NSMutableAttributedString = .init(string: ""),
            insets: UIEdgeInsets = .zero,
            spacing: CGFloat = 0
        ) {
            self.textFieldViewProperties = textFieldViewProperties
            self.hint = hint
            self.insets = insets
            self.spacing = spacing
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            textField,
            hintLabel,
        ])
        stack.axis = .vertical
        return stack
    }()
    
    private let textField: InputTextField = .init()
    private let hintLabel: UILabel = .init()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    public func update(with viewProperties: ViewProperties) {
        vStack.spacing = viewProperties.spacing
        textField.update(with: viewProperties.textFieldViewProperties)
        hintLabel.attributedText = viewProperties.hint
        hintLabel.isHidden = viewProperties.hint.string.isEmpty
        vStack.layoutMargins = viewProperties.insets
        vStack.isLayoutMarginsRelativeArrangement = true
        self.viewProperties = viewProperties
    }
    
    private func setupView() {
        addSubview(vStack)
        vStack.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}
