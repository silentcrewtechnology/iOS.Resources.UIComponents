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
        stack.distribution = .fill
        stack.spacing = 0
        stack.isUserInteractionEnabled = true
        return stack
    }()
    
    private lazy var textFieldContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(textFieldTapped))
        )
        view.snp.makeConstraints { $0.height.equalTo(0) }
        return view
    }()
    
    private lazy var textField: InputTextField = {
        let field = InputTextField()
        field.rightViewMode = .always
        return field
    }()
    
    private var viewProperties: ViewProperties = .init()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Public methods
    
    public func update(with viewProperties: ViewProperties) {
        stripNonTextFieldSubviews()
        setupConstraints(with: viewProperties)
        setupHeaderViewIfNeeded(with: viewProperties)
        setupTextField(with: viewProperties)
        setupHintView(with: viewProperties)
        setupAccessibilityIds(with: viewProperties)
        self.viewProperties = viewProperties
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        textFieldContainer.addSubview(textField)
        textField.snp.makeConstraints { $0.edges.equalToSuperview() }
        verticalStack.addArrangedSubview(textFieldContainer)
        addSubview(verticalStack)
        verticalStack.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func setupConstraints(with viewProperties: ViewProperties) {
        verticalStack.snp.updateConstraints {
            $0.edges.equalToSuperview().inset(viewProperties.stackViewInsets)
        }
        textFieldContainer.snp.updateConstraints {
            $0.height.equalTo(viewProperties.textFieldHeight)
        }
        textField.snp.updateConstraints {
            $0.edges.equalToSuperview().inset(viewProperties.textFieldInsets)
        }
    }
    
    private func stripNonTextFieldSubviews() {
        // textField должен оставаться в иерархии
        verticalStack.arrangedSubviews.forEach {
            if $0 !== textFieldContainer {
                $0.removeFromSuperview()
            }
        }
    }
    
    private func setupHeaderViewIfNeeded(with viewProperties: ViewProperties) {
        guard let headerView = viewProperties.headerView else { return }
        verticalStack.insertArrangedSubview(headerView, at: 0)
    }
    
    private func setupTextField(with viewProperties: ViewProperties) {
        textFieldContainer.layer.borderWidth = viewProperties.textFieldBorderWidth
        textFieldContainer.layer.cornerRadius = viewProperties.textFieldCornerRadius
        textFieldContainer.isUserInteractionEnabled = viewProperties.isEnabled
        textField.rightView = viewProperties.rightView
        textField.update(with: viewProperties.textFieldViewProperties)
        
        UIView.animate(withDuration: 0.1) {
            self.textFieldContainer.backgroundColor = viewProperties.textFieldBackgroundColor
            self.textFieldContainer.layer.borderColor = viewProperties.textFieldBorderColor.cgColor
        }
    }
    
    private func setupHintView(with viewProperties: ViewProperties) {
        verticalStack.addArrangedSubview(viewProperties.hintView)
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
