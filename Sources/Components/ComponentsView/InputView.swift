import UIKit
import SnapKit

public class InputView: UIView, ComponentProtocol {
    
    // MARK: - Properties
    
    public struct ViewProperties {
        public var labelViewProperties: LabelView.ViewProperties?
        public var hintViewProperties: HintView.ViewProperties
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
       
        public init(
            labelViewProperties: LabelView.ViewProperties? = nil,
            hintViewProperties: HintView.ViewProperties = .init(),
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
            stackViewSpacing: CGFloat = .zero
        ) {
            self.labelViewProperties = labelViewProperties
            self.hintViewProperties = hintViewProperties
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
        }
    }
    
    // MARK: - Private properties
    
    private lazy var verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical

        return stack
    }()
    
    private lazy var textFieldContainer = UIView()
    private lazy var labelView = LabelView()
    private lazy var textField = InputTextField()
    private lazy var hintView = HintView()
    
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - Public methods
    
    public func update(with viewProperties: ViewProperties) {
        DispatchQueue.main.async {
            self.viewProperties = viewProperties
            
            self.setupView(viewProperties: viewProperties)
            self.updateLabelView(with: viewProperties.labelViewProperties)
            self.updateTextField(with: viewProperties)
            self.hintView.update(with: viewProperties.hintViewProperties)
        }
    }
    
    // MARK: - Private methods
    
    private func setupView(viewProperties: ViewProperties) {
        removeConstraintsAndSubviews()
        
        addSubview(verticalStack)
        verticalStack.spacing = viewProperties.stackViewSpacing
        verticalStack.isUserInteractionEnabled = true
        verticalStack.addArrangedSubview(labelView)
        verticalStack.addArrangedSubview(textFieldContainer)
        verticalStack.addArrangedSubview(hintView)
        verticalStack.distribution = .fill
        verticalStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(viewProperties.stackViewInsets)
            make.height.greaterThanOrEqualTo(viewProperties.minHeight)
        }
        
        textFieldContainer.clipsToBounds = true
        textFieldContainer.snp.makeConstraints { make in
            make.height.equalTo(viewProperties.textFieldHeight)
        }
        
        textFieldContainer.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(viewProperties.textFieldInsets)
        }
    }
    
    private func updateLabelView(with labelViewProperties: LabelView.ViewProperties?) {
        if let labelViewProperties {
            labelView.update(with: labelViewProperties)
            labelView.isHidden = false
        } else {
            labelView.isHidden = true
        }
    }
    
    private func updateTextField(with viewProperties: ViewProperties) {
        textFieldContainer.backgroundColor = viewProperties.textFieldBackgroundColor
        textFieldContainer.layer.borderColor = viewProperties.textFieldBorderColor.cgColor
        textFieldContainer.layer.borderWidth = viewProperties.textFieldBorderWidth
        textFieldContainer.layer.cornerRadius = viewProperties.textFieldCornerRadius
        textFieldContainer.isUserInteractionEnabled = viewProperties.isEnabled
        textFieldContainer.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(textFieldTapped))
        )
        
        textField.rightViewMode = .always
        textField.rightView = viewProperties.rightView
        textField.update(with: viewProperties.textFieldViewProperties)
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
}
