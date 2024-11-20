import UIKit
import SnapKit

public final class InputAmountView: UIView {
    
    // MARK: - Properties
    
    public struct ViewProperties {
        public var margins: Margins
        public var headerView: UIView?
        public var hintView: UIView?
        public var textFieldProperties: InputAmountTextField.ViewProperties
        public var amountSymbol: NSMutableAttributedString
        public var isUserInteractionEnabled: Bool
        
        public struct Margins {
            public var top: CGFloat
            public var trailing: CGFloat
            public var leading: CGFloat
            public var bottom: CGFloat
            public var spacing: CGFloat
            
            public init(
                top: CGFloat = 0,
                trailing: CGFloat = 0,
                leading: CGFloat = 0,
                bottom: CGFloat = 0,
                spacing: CGFloat = 0
            ) {
                self.top = top
                self.trailing = trailing
                self.leading = leading
                self.bottom = bottom
                self.spacing = spacing
            }
        }
        
        public init(
            margins: Margins = .init(),
            headerView: UIView? = nil,
            hintView: UIView? = nil,
            textFieldProperties: InputAmountTextField.ViewProperties = .init(),
            amountSymbol: NSMutableAttributedString = .init(string: ""),
            isUserInteractionEnabled: Bool = true
        ) {
            self.margins = margins
            self.headerView = headerView
            self.hintView = hintView
            self.textFieldProperties = textFieldProperties
            self.amountSymbol = amountSymbol
            self.isUserInteractionEnabled = isUserInteractionEnabled
        }
    }
    
    // MARK: - Private properties
    
    private var viewProperties: ViewProperties = .init()
    
    private lazy var containerView = UIView()
    private lazy var amountCurrencyContainer = UIView()
    private lazy var currencyLabel = UILabel()
    
    private lazy var amountTextField: InputAmountTextField = {
        let textField = InputAmountTextField()
        // Для кликабельности всей вьюхи
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Public methods
    
    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
        
        amountTextField.update(with: viewProperties.textFieldProperties)
        updateViewSettings(with: viewProperties)
        updateConstraint(with: viewProperties)
        setupHeaderViewIfNeeded(with: viewProperties)
        setupAmountCurrency(with: viewProperties)
        setupHintViewIfNeeded(with: viewProperties)
    }
    
    // MARK: - Private methods
    
    private func updateConstraint(with viewProperties: ViewProperties) {
        removeConstraintsAndSubviews()
        addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupHeaderViewIfNeeded(with viewProperties: ViewProperties) {
        if let headerView = viewProperties.headerView {
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
        if let headerView = viewProperties.headerView {
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
        if let hintView = viewProperties.hintView {
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
