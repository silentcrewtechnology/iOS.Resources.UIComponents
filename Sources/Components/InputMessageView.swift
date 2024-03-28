import UIKit
import SnapKit

public class InputMessageView: UIView {
    
    public struct ViewProperties {
        public var attributedText: NSMutableAttributedString?
        public var attributedPlaceholder: NSMutableAttributedString?
        public var backgroundColor: UIColor
        public var borderColor: UIColor
        public var cornerRadius: CGFloat
        public var isUserInteractionEnabled: Bool
        public var delegateAssigningClosure: (UITextField) -> Void
        
        public init(
            attributedText: NSMutableAttributedString? = nil,
            attributedPlaceholder: NSMutableAttributedString? = nil,
            backgroundColor: UIColor = .white,
            borderColor: UIColor = .clear,
            cornerRadius: CGFloat = .zero,
            isUserInteractionEnabled: Bool = true,
            delegateAssigningClosure: @escaping (UITextField) -> Void = { _ in }
        ) {
            self.attributedText = attributedText
            self.attributedPlaceholder = attributedPlaceholder
            self.backgroundColor = backgroundColor
            self.borderColor = borderColor
            self.cornerRadius = cornerRadius
            self.isUserInteractionEnabled = isUserInteractionEnabled
            self.delegateAssigningClosure = delegateAssigningClosure
        }
    }
    
    private lazy var textField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.borderStyle = .none
        return textField
    }()
    
    private var viewProperties: ViewProperties = .init()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupView() {
        addSubview(textField)
        textField.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(
                UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20))
        }
    }
    
    public func update(with viewProperties: ViewProperties) {
        backgroundColor = viewProperties.backgroundColor
        layer.cornerRadius = viewProperties.cornerRadius
        updateTextField(with: viewProperties)
        updateBorder(with: viewProperties)
        isUserInteractionEnabled = viewProperties.isUserInteractionEnabled
        self.viewProperties = viewProperties
    }
    
    private func updateTextField(with viewProperties: ViewProperties) {
        textField.attributedText = viewProperties.attributedText
        textField.attributedPlaceholder = viewProperties.attributedPlaceholder
        viewProperties.delegateAssigningClosure(textField)
        isUserInteractionEnabled = viewProperties.isUserInteractionEnabled
    }
    
    private func updateBorder(with viewProperties: ViewProperties) {
        layer.borderWidth = 1
        layer.borderColor = viewProperties.borderColor.cgColor
    }
}
