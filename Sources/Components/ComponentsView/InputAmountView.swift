import UIKit
import SnapKit

public final class InputAmountView: UIView, ComponentProtocol {
    
    public struct ViewProperties {
        public var header: LabelView.ViewProperties?
        public var textFieldProperties: InputAmountTextField.ViewProperties
        public var amountSymbol: NSMutableAttributedString
        public var hint: HintView.ViewProperties
        public var isUserInteractionEnabled: Bool
        
        public init(
            header: LabelView.ViewProperties? = nil,
            textFieldProperties: InputAmountTextField.ViewProperties = .init(),
            amountSymbol: NSMutableAttributedString = .init(string: ""),
            hint: HintView.ViewProperties = .init(),
            isUserInteractionEnabled: Bool = true
        ) {
            self.header = header
            self.textFieldProperties = textFieldProperties
            self.amountSymbol = amountSymbol
            self.hint = hint
            self.isUserInteractionEnabled = isUserInteractionEnabled
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    private lazy var headerView: LabelView = {
        let view = LabelView()
        return view
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
        let stack = UIStackView(arrangedSubviews: [
            headerView,
            amountCurrencyStack,
            hintView
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
        updateHeader(with: viewProperties.header)
        amountTextField.update(with: viewProperties.textFieldProperties)
        hintView.update(with: viewProperties.hint)
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
    
    private func updateHeader(with header: LabelView.ViewProperties?) {
        if let header {
            headerView.update(with: header)
            headerView.isHidden = false
        } else {
            headerView.isHidden = true
        }
    }
    
    private func updateView(viewProperties: ViewProperties) {
        isUserInteractionEnabled = viewProperties.isUserInteractionEnabled
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
