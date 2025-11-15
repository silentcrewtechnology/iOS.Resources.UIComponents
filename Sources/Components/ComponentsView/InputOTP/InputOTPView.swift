import UIKit
import SnapKit
import AccessibilityIds

public final class InputOTPView: UIView, ComponentProtocol {
    
    // MARK: - Properties
    
    public struct ViewProperties {
        public var itemViews: [UIView]
        public var hintView: UIView
        public var stackSpacing: CGFloat
        public var hintViewInsets: UIEdgeInsets
        public var textFieldViewProperties: InputTextField.ViewProperties
        public var isUserInteractionEnabled: Bool
        public var onTextChanged: ((String?) -> Void)?
        public var accessibilityId: String?
        
        public init(
            itemViews: [UIView] = [],
            hintView: UIView = .init(),
            stackSpacing: CGFloat = .zero,
            hintViewInsets: UIEdgeInsets = .zero,
            textFieldViewProperties: InputTextField.ViewProperties = .init(),
            isUserInteractionEnabled: Bool = true,
            onTextChanged: ((String?) -> Void)? = nil,
            accessibilityId: String? = nil
        ) {
            self.itemViews = itemViews
            self.hintView = hintView
            self.stackSpacing = stackSpacing
            self.hintViewInsets = hintViewInsets
            self.textFieldViewProperties = textFieldViewProperties
            self.isUserInteractionEnabled = isUserInteractionEnabled
            self.onTextChanged = onTextChanged
            self.accessibilityId = accessibilityId
        }
    }
    
    // MARK: - Private propertiesa
    
    private var viewProperties: ViewProperties = .init()
    
    private lazy var itemsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        
        return stack
    }()
    
    private lazy var textFieldContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(textFieldTapped))
        )
        
        return view
    }()
    
    private lazy var textField: InputTextField = {
        let field = InputTextField()
        field.rightViewMode = .always
        
        return field
    }()
    
    // MARK: - Life cycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Methods
    
    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
        
        setupTextField(with: viewProperties)
        setupStackView(with: viewProperties)
        setupHintView(with: viewProperties)
        setupAccessibilityId(with: viewProperties)
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        addSubview(itemsStackView)
        itemsStackView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
        }
        
        addSubview(textFieldContainer)
        textFieldContainer.snp.makeConstraints {
            $0.edges.equalTo(itemsStackView.snp.edges)
        }
        textFieldContainer.addSubview(textField)
        textField.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func setupTextField(with viewProperties: ViewProperties) {
        textField.update(with: viewProperties.textFieldViewProperties)
    }
    
    private func setupStackView(with viewProperties: ViewProperties) {
        itemsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        itemsStackView.spacing = viewProperties.stackSpacing
        
        for item in viewProperties.itemViews {
            itemsStackView.addArrangedSubview(item)
        }
    }
    
    private func setupHintView(with viewProperties: ViewProperties) {
        addSubview(viewProperties.hintView)
        viewProperties.hintView.snp.makeConstraints {
            $0.top.equalTo(itemsStackView.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(viewProperties.hintViewInsets)
            $0.bottom.equalToSuperview()
        }
    }

    @objc private func textFieldTapped() {
        guard textFieldContainer.isUserInteractionEnabled else { return }
        
        textField.becomeFirstResponder()
    }
    
    private func setupAccessibilityId(with viewProperties: ViewProperties) {
        isAccessibilityElement = true
        accessibilityIdentifier = viewProperties.accessibilityId
        itemsStackView.isAccessibilityElement = true
        itemsStackView.accessibilityIdentifier = DesignSystemAccessibilityIDs.InputOTPView.itemsStack
    }
}
