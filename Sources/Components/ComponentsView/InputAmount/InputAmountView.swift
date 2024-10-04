import UIKit
import SnapKit

public final class InputAmountView: UIView {
    
    // MARK: - Properties
    
    public struct ViewProperties {
        public var margins: Margins
        public var headerViewProperties: LabelView.ViewProperties?
        public var textFieldProperties: InputAmountTextField.ViewProperties
        public var amountSymbol: NSMutableAttributedString
        public var hintViewProperties: HintView.ViewProperties?
        public var isUserInteractionEnabled: Bool
        
        public struct Margins {
            public var top: CGFloat
            public var trailing: CGFloat
            public var leading: CGFloat
            public var bottom: CGFloat
            public var spacing: CGFloat
            
            public init(top: CGFloat = 0,
                        trailing: CGFloat = 0,
                        leading: CGFloat = 0,
                        bottom: CGFloat = 0,
                        spacing: CGFloat = 0) {
                self.top = top
                self.trailing = trailing
                self.leading = leading
                self.bottom = bottom
                self.spacing = spacing
            }
        }
        
        public init(
            margins: Margins = .init(),
            headerViewProperties: LabelView.ViewProperties? = nil,
            textFieldProperties: InputAmountTextField.ViewProperties = .init(),
            amountSymbol: NSMutableAttributedString = .init(string: ""),
            hintViewProperties: HintView.ViewProperties? = nil,
            isUserInteractionEnabled: Bool = true
        ) {
            self.margins = margins
            self.headerViewProperties = headerViewProperties
            self.textFieldProperties = textFieldProperties
            self.amountSymbol = amountSymbol
            self.hintViewProperties = hintViewProperties
            self.isUserInteractionEnabled = isUserInteractionEnabled
        }
    }
    
    // MARK: - Private properties
    
    private var viewProperties: ViewProperties = .init()
    
    private var containerView = UIView()
    
    private lazy var headerView = LabelView()
    
    private lazy var hintView = HintView()
    
    private lazy var amountTextField: InputAmountTextField = {
        let textField = InputAmountTextField()
        // Для кликабельности всей вьюхи
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    private var currencyLabel = UILabel()
    
    private var amountCurrencyContainer = UIView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Public methods
    
    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
        self.amountTextField.update(with: viewProperties.textFieldProperties)
        self.updateViewSettings(with: viewProperties)
        
        self.updateConstraint(with: viewProperties)
        if let hint = viewProperties.hintViewProperties {
            self.hintView.update(with: hint)
        }
        if let header = viewProperties.headerViewProperties {
            self.headerView.update(with: header)
        }
    }
    
    // MARK: - Private methods
    
    private func updateConstraint(with viewProperties: ViewProperties) {
        removeConstraintsAndSubviews()
        addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        setupHeaderViewIfNeeded(with: viewProperties)
        setupAmountCurrency(with: viewProperties)
        setupHintViewIfNeeded(with: viewProperties)
    }
    
    private func setupHeaderViewIfNeeded(with viewProperties: ViewProperties) {
        if viewProperties.headerViewProperties != nil {
            containerView.addSubview(headerView)
            headerView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(viewProperties.margins.top)
                $0.leading.equalToSuperview().offset(viewProperties.margins.leading)
                $0.trailing.equalToSuperview().offset(-viewProperties.margins.trailing)
            }
        }
    }
    
    private func setupAmountCurrency(with viewProperties: ViewProperties) {
        containerView.addSubview(amountCurrencyContainer)
        if viewProperties.headerViewProperties != nil {
            amountCurrencyContainer.snp.makeConstraints {
                $0.top.equalTo(headerView.snp.bottom)
                $0.leading.equalToSuperview().offset(viewProperties.margins.leading)
                $0.trailing.equalToSuperview().offset(-viewProperties.margins.trailing)
            }
        } else {
            amountCurrencyContainer.snp.makeConstraints {
                $0.top.equalToSuperview().offset(viewProperties.margins.top)
                $0.leading.equalToSuperview().offset(viewProperties.margins.leading)
                $0.trailing.equalToSuperview().offset(-viewProperties.margins.trailing)
            }
        }
        
        amountCurrencyContainer.addSubview(amountTextField)
        amountTextField.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
        }
        
        amountCurrencyContainer.addSubview(currencyLabel)
        currencyLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview().offset(-viewProperties.margins.trailing)
            $0.leading.equalTo(amountTextField.snp.trailing).offset(viewProperties.margins.spacing)
        }
    }
    
    private func setupHintViewIfNeeded(with viewProperties: ViewProperties) {
        if viewProperties.hintViewProperties != nil {
            containerView.addSubview(hintView)
            hintView.snp.makeConstraints {
                $0.top.equalTo(amountCurrencyContainer.snp.bottom)
                $0.leading.equalToSuperview().offset(viewProperties.margins.leading)
                $0.trailing.equalToSuperview().offset(-viewProperties.margins.trailing)
                $0.bottom.equalToSuperview().offset(-viewProperties.margins.bottom)
            }
        } else {
            amountCurrencyContainer.snp.makeConstraints {
                $0.bottom.equalToSuperview().offset(-viewProperties.margins.bottom)
            }
        }
    }
    
    private func removeConstraintsAndSubviews() {
        containerView.subviews.forEach { subview in
            subview.snp.removeConstraints()
            subview.removeFromSuperview()
        }
    }
    
    private func updateViewSettings(with viewProperties: ViewProperties) {
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
