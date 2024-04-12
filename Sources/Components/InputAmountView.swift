import UIKit
import SnapKit

public final class InputAmountView: UIView {
    
    public struct ViewProperties {
        public var title: NSMutableAttributedString
        public var hintViewProperties: HintView.ViewProperties
        public var hintViewHidden: Bool
        public var textFieldProperties: InputAmountTextField.ViewProperties
        public var amountSymbol: NSMutableAttributedString
        public var isUserInteractionEnabled: Bool
        
        public init(
            title: NSMutableAttributedString = .init(string: ""),
            hintViewProperties: HintView.ViewProperties = .init(),
            hintViewHidden: Bool = false,
            textFieldProperties: InputAmountTextField.ViewProperties = .init(),
            amountSymbol: NSMutableAttributedString = .init(string: ""),
            isUserInteractionEnabled: Bool = true
        ) {
            self.title = title
            self.hintViewProperties = hintViewProperties
            self.hintViewHidden = hintViewHidden
            self.textFieldProperties = textFieldProperties
            self.amountSymbol = amountSymbol
            self.isUserInteractionEnabled = isUserInteractionEnabled
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    private var amountTextField: InputAmountTextField = {
        let textField = InputAmountTextField()
        // Для кликабельности всей вьюхи
        textField.isUserInteractionEnabled = false
        return textField
    }()
    private var currencyLabel = UILabel()
    
    private lazy var hintView: HintView = {
        let view = HintView()
        return view
    }()
    
    private lazy var vStack: UIStackView = {
        
        func spacer(size: CGFloat) -> UIView {
            let spacer = SpacerView()
            spacer.update(with: .init(size: .init(width: size, height: size)))
            return spacer
        }
        
        let stack = UIStackView(arrangedSubviews: [
            spacer(size: 4),
            titleLabel,
            spacer(size: 4),
            amountCurrencyStack,
            spacer(size: 4),
            hintView,
            spacer(size: 4)
        ])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = .zero
        return stack
    }()
    
    private lazy var amountCurrencyStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            amountTextField,
            currencyLabel
        ])
        stack.axis = .horizontal
        stack.alignment = .top
        stack.spacing = 8
        return stack
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    public func update(with viewProperties: ViewProperties) {
        amountTextField.update(with: viewProperties.textFieldProperties)
        updateHintView(viewProperties: viewProperties)
        updateView(viewProperties: viewProperties)
        self.viewProperties = viewProperties
    }
    
    private var wasSetup = false
    
    private func setupView() {
        guard !wasSetup else { return }
        wasSetup = true
        addSubview(vStack)
        vStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func updateHintView(viewProperties: ViewProperties) {
        hintView.update(with: viewProperties.hintViewProperties)
        hintView.isHidden = viewProperties.hintViewHidden
    }
    
    private func updateView(viewProperties: ViewProperties) {
        isUserInteractionEnabled = viewProperties.isUserInteractionEnabled
        titleLabel.attributedText = viewProperties.title
        currencyLabel.attributedText = viewProperties.amountSymbol
        addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(didTap)))
    }
    
    @objc
    private func didTap() {
        guard isUserInteractionEnabled else { return }
        amountTextField.becomeFirstResponder()
    }
}
