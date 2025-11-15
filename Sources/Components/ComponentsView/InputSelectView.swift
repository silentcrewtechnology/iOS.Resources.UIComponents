import UIKit
import SnapKit
import AccessibilityIds

public final class InputSelectView: UIView, ComponentProtocol {
    
    // MARK: - Properties
    
    public struct ViewProperties {
        public var headerView: UIView?
        public var hintView: UIView
        public var clearButtonIcon: UIImage
        public var disclosureButtonIcon: UIImage
        public var textFieldViewProperties: InputTextField.ViewProperties
        public var inputBackgroundColor: UIColor
        public var inputCornerRadius: CGFloat
        public var inputBorderColor: UIColor
        public var inputBorderWidth: CGFloat
        public var inputHeight: CGFloat
        public var inputInsets: UIEdgeInsets
        public var isEnabled: Bool
        public var verticalStackViewInsets: UIEdgeInsets
        public var verticalStackViewSpacing: CGFloat
        public var inputStackViewSpacing: CGFloat
        public var rightViewsSize: CGSize
        public var onTextChanged: ((String?) -> Void)?
        public var onClear: (() -> Void)?
        public var onDisclosure: (() -> Void)?
       
        public init(
            headerView: UIView? = nil,
            hintView: UIView = .init(),
            clearButtonIcon: UIImage = .init(),
            disclosureButtonIcon: UIImage = .init(),
            textFieldViewProperties: InputTextField.ViewProperties = .init(),
            inputBackgroundColor: UIColor = .clear,
            inputCornerRadius: CGFloat = .zero,
            inputBorderColor: UIColor = .clear,
            inputBorderWidth: CGFloat = .zero,
            inputHeight: CGFloat = .zero,
            inputInsets: UIEdgeInsets = .zero,
            isEnabled: Bool = true,
            verticalStackViewInsets: UIEdgeInsets = .zero,
            verticalStackViewSpacing: CGFloat = .zero,
            inputStackViewSpacing: CGFloat = .zero,
            rightViewsSize: CGSize = .zero,
            onTextChanged: ((String?) -> Void)? = nil,
            onClear: (() -> Void)? = nil,
            onDisclosure: (() -> Void)? = nil
        ) {
            self.headerView = headerView
            self.hintView = hintView
            self.clearButtonIcon = clearButtonIcon
            self.disclosureButtonIcon = disclosureButtonIcon
            self.textFieldViewProperties = textFieldViewProperties
            self.inputBackgroundColor = inputBackgroundColor
            self.inputCornerRadius = inputCornerRadius
            self.inputBorderColor = inputBorderColor
            self.inputBorderWidth = inputBorderWidth
            self.inputHeight = inputHeight
            self.inputInsets = inputInsets
            self.isEnabled = isEnabled
            self.verticalStackViewInsets = verticalStackViewInsets
            self.verticalStackViewSpacing = verticalStackViewSpacing
            self.inputStackViewSpacing = inputStackViewSpacing
            self.rightViewsSize = rightViewsSize
            self.onTextChanged = onTextChanged
            self.onClear = onClear
            self.onDisclosure = onDisclosure
        }
    }
    
    // MARK: - Private properties
    
    private lazy var clearButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var disclosureButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(disclosureButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var textField: InputTextField = {
        let field = InputTextField()
        field.rightViewMode = .always
        
        return field
    }()
    
    private lazy var inputStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            textField,
            clearButton,
            disclosureButton
        ])
        stackView.axis = .horizontal
        stackView.alignment = .center
        
        return stackView
    }()
    
    private lazy var inputContainerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(inputTapped))
        )
        
        return view
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.isUserInteractionEnabled = true
        
        return stack
    }()
    
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - Life cycle
    
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
        setupInputContainerView(with: viewProperties)
        setupHintView(with: viewProperties)
        setupRightButtons(with: viewProperties)
        
        self.viewProperties = viewProperties
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        inputContainerView.addSubview(inputStackView)
        inputContainerView.snp.makeConstraints { $0.height.equalTo(0) } // Будет обновляться
        inputStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        verticalStackView.addArrangedSubview(inputContainerView)
        addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        clearButton.snp.makeConstraints { $0.size.equalTo(0) } // Будет обновляться
        disclosureButton.snp.makeConstraints { $0.size.equalTo(0) } // Будет обновляться
    }
    
    private func setupConstraints(with viewProperties: ViewProperties) {
        verticalStackView.spacing = viewProperties.verticalStackViewSpacing
        verticalStackView.snp.updateConstraints {
            $0.edges.equalToSuperview().inset(viewProperties.verticalStackViewInsets)
        }
        
        inputContainerView.snp.updateConstraints {
            $0.height.equalTo(viewProperties.inputHeight)
        }
        inputStackView.snp.updateConstraints {
            $0.edges.equalToSuperview().inset(viewProperties.inputInsets)
        }
        
        clearButton.snp.updateConstraints {
            $0.size.equalTo(viewProperties.rightViewsSize)
        }
        disclosureButton.snp.updateConstraints {
            $0.size.equalTo(viewProperties.rightViewsSize)
        }
    }
    
    private func stripNonTextFieldSubviews() {
        // textField должен оставаться в иерархии
        verticalStackView.arrangedSubviews.forEach {
            if $0 !== inputContainerView {
                $0.removeFromSuperview()
            }
        }
    }
    
    private func setupHeaderViewIfNeeded(with viewProperties: ViewProperties) {
        guard let headerView = viewProperties.headerView else { return }
        verticalStackView.insertArrangedSubview(headerView, at: .zero)
    }
    
    private func setupInputContainerView(with viewProperties: ViewProperties) {
        inputContainerView.layer.borderWidth = viewProperties.inputBorderWidth
        inputContainerView.layer.cornerRadius = viewProperties.inputCornerRadius
        inputContainerView.isUserInteractionEnabled = viewProperties.isEnabled
        inputStackView.spacing = viewProperties.inputStackViewSpacing
        textField.update(with: viewProperties.textFieldViewProperties)
        
        UIView.animate(withDuration: 0.1) {
            self.inputContainerView.backgroundColor = viewProperties.inputBackgroundColor
            self.inputContainerView.layer.borderColor = viewProperties.inputBorderColor.cgColor
        }
    }
    
    private func setupHintView(with viewProperties: ViewProperties) {
        verticalStackView.addArrangedSubview(viewProperties.hintView)
    }
    
    private func setupRightButtons(with viewProperties: ViewProperties) {
        clearButton.setImage(viewProperties.clearButtonIcon, for: .normal)
        clearButton.isHidden = textField.text?.isEmpty ?? true
        disclosureButton.setImage(viewProperties.disclosureButtonIcon, for: .normal)
    }
    
    @objc private func inputTapped() {
        guard inputContainerView.isUserInteractionEnabled else { return }
        
        textField.becomeFirstResponder()
    }
    
    @objc private func clearButtonTapped() {
        viewProperties.onClear?()
    }
    
    @objc private func disclosureButtonTapped() {
        viewProperties.onDisclosure?()
    }
}
