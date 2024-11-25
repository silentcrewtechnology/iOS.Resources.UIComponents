import UIKit
import SnapKit
import AccessibilityIds

public final class InputView: UIView, ComponentProtocol {
    
    // MARK: - Properties
    
    public struct ViewProperties {
        public var headerView: UIView?
        public var hintView: UIView
        public var textFieldViewProperties: InputTextField.ViewProperties
        public var textFieldBackgroundColor: UIColor
        public var textFieldCornerRadius: CGFloat
        public var textFieldBorderColor: UIColor
        public var textFieldBorderWidth: CGFloat
        public var textFieldHeight: CGFloat
        public var textFieldInsets: UIEdgeInsets
        public var minHeight: CGFloat
        public var rightView: UIView
        public var isEnabled: Bool
        public var stackViewInsets: UIEdgeInsets
        public var stackViewSpacing: CGFloat
        public var onTextChanged: ((String?) -> Void)?
        public var accessibilityIds: AccessibilityIds?
        
        public struct AccessibilityIds {
            public var id: String
            public var hintId: String
            
            public init(
                id: String,
                hintId: String = DesignSystemAccessibilityIDs.InputView.hint
            ) {
                self.id = id
                self.hintId = hintId
            }
        }
       
        public init(
            headerView: UIView? = nil,
            hintView: UIView = .init(),
            textFieldViewProperties: InputTextField.ViewProperties = .init(),
            textFieldBackgroundColor: UIColor = .clear,
            textFieldCornerRadius: CGFloat = .zero,
            textFieldBorderColor: UIColor = .clear,
            textFieldBorderWidth: CGFloat = .zero,
            textFieldHeight: CGFloat = .zero,
            textFieldInsets: UIEdgeInsets = .zero,
            minHeight: CGFloat = .zero,
            rightView: UIView = .init(),
            isEnabled: Bool = true,
            stackViewInsets: UIEdgeInsets = .zero,
            stackViewSpacing: CGFloat = .zero,
            onTextChanged: ((String?) -> Void)? = nil,
            accessibilityIds: AccessibilityIds? = nil
        ) {
            self.headerView = headerView
            self.hintView = hintView
            self.textFieldViewProperties = textFieldViewProperties
            self.textFieldBackgroundColor = textFieldBackgroundColor
            self.textFieldCornerRadius = textFieldCornerRadius
            self.textFieldBorderColor = textFieldBorderColor
            self.textFieldBorderWidth = textFieldBorderWidth
            self.textFieldHeight = textFieldHeight
            self.textFieldInsets = textFieldInsets
            self.minHeight = minHeight
            self.rightView = rightView
            self.isEnabled = isEnabled
            self.stackViewInsets = stackViewInsets
            self.stackViewSpacing = stackViewSpacing
            self.onTextChanged = onTextChanged
            self.accessibilityIds = accessibilityIds
        }
    }
    
    // MARK: - Private properties
    
    private lazy var verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical

        return stack
    }()
    
    private lazy var textFieldContainer = UIView()
    private lazy var textField = InputTextField()
    
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - Public methods
    
    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
        
        setupView(with: viewProperties)
        setupHeaderViewIfNeeded(with: viewProperties)
        setupTextField(with: viewProperties)
        setupHintView(with: viewProperties)
        setupAccessibilityIds(with: viewProperties)
    }
    
    // MARK: - Private methods
    
    private func setupView(with viewProperties: ViewProperties) {
        removeConstraintsAndSubviews()
        
        addSubview(verticalStack)
        verticalStack.spacing = viewProperties.stackViewSpacing
        verticalStack.isUserInteractionEnabled = true
        verticalStack.distribution = .fill
        verticalStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(viewProperties.stackViewInsets)
            make.height.greaterThanOrEqualTo(viewProperties.minHeight)
        }
    }
    
    private func setupHeaderViewIfNeeded(with viewProperties: ViewProperties) {
        if let headerView = viewProperties.headerView {
            verticalStack.addArrangedSubview(headerView)
        }
    }
    
    private func setupTextField(with viewProperties: ViewProperties) {
        verticalStack.addArrangedSubview(textFieldContainer)
        textFieldContainer.clipsToBounds = true
        textFieldContainer.layer.borderWidth = viewProperties.textFieldBorderWidth
        textFieldContainer.layer.cornerRadius = viewProperties.textFieldCornerRadius
        textFieldContainer.isUserInteractionEnabled = viewProperties.isEnabled
        textFieldContainer.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(textFieldTapped))
        )
        textFieldContainer.snp.makeConstraints { make in
            make.height.equalTo(viewProperties.textFieldHeight)
        }
        
        textFieldContainer.addSubview(textField)
        textField.rightViewMode = .always
        textField.rightView = viewProperties.rightView
        textField.update(with: viewProperties.textFieldViewProperties)
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(viewProperties.textFieldInsets)
        }
        
        UIView.animate(withDuration: 0.1) {
            self.textFieldContainer.backgroundColor = viewProperties.textFieldBackgroundColor
            self.textFieldContainer.layer.borderColor = viewProperties.textFieldBorderColor.cgColor
        }
    }
    
    private func setupHintView(with viewProperties: ViewProperties) {
        verticalStack.addArrangedSubview(viewProperties.hintView)
    }
    
    private func removeConstraintsAndSubviews() {
        verticalStack.arrangedSubviews.forEach { subview in
            subview.snp.removeConstraints()
            subview.removeFromSuperview()
        }
        
        subviews.forEach { subview in
            subview.snp.removeConstraints()
            subview.removeFromSuperview()
        }
    }
    
    @objc private func textFieldTapped() {
        guard textFieldContainer.isUserInteractionEnabled else { return }
        
        textField.becomeFirstResponder()
    }
    
    private func setupAccessibilityIds(with viewProperties: ViewProperties) {
        isAccessibilityElement = true
        accessibilityIdentifier = viewProperties.accessibilityIds?.id
        accessibilityLabel = viewProperties.accessibilityIds?.id
        verticalStack.isAccessibilityElement = true
        verticalStack.accessibilityIdentifier = DesignSystemAccessibilityIDs.InputView.verticalStack
        textFieldContainer.isAccessibilityElement = true
        textFieldContainer.accessibilityIdentifier = DesignSystemAccessibilityIDs.InputView.textFieldContainer
        viewProperties.hintView.isAccessibilityElement = true
        viewProperties.hintView.accessibilityIdentifier = viewProperties.accessibilityIds?.hintId
    }
}
