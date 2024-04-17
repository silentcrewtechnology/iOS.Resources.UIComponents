//
//  InputPhoneNumberView.swift
//
//
//  Created by Ilnur Mugaev on 12.04.2024.
//

import UIKit
import SnapKit

public class InputPhoneNumberView: UIView {
    
    public enum Prefix {
        case icon(image: UIImage)
        case country(flag: UIImage?, code: NSMutableAttributedString)
    }
    
    public struct ViewProperties {
        public var header: LabelView.ViewProperties?
        public var prefix: Prefix
        public var text: NSMutableAttributedString?
        public var defaultText: NSMutableAttributedString
        public var placeholder: NSMutableAttributedString?
        public var clearButtonIcon: UIImage
        public var hint: HintView.ViewProperties
        public var divider: DividerView.ViewProperties
        public var backgroundColor: UIColor
        public var border: Border
        public var isUserInteractionEnabled: Bool
        public var delegateAssigningClosure: (UITextField) -> Void
        public var flagButtonAction: () -> Void
        public var clearButtonAction: () -> Void
        
        public struct Border {
            public var color: UIColor
            public var width: CGFloat
            public var cornerRadius: CGFloat
            
            public init(
                color: UIColor = .clear,
                width: CGFloat = .zero,
                cornerRadius: CGFloat = .zero
            ) {
                self.color = color
                self.width = width
                self.cornerRadius = cornerRadius
            }
        }
        
        public init(
            header: LabelView.ViewProperties? = nil,
            prefix: Prefix = .icon(image: .init()),
            text: NSMutableAttributedString? = nil,
            defaultText: NSMutableAttributedString = .init(string: " "),
            placeholder: NSMutableAttributedString? = nil,
            clearButtonIcon: UIImage = .init(),
            hint: HintView.ViewProperties = .init(),
            divider: DividerView.ViewProperties = .init(),
            backgroundColor: UIColor = .clear,
            border: Border = .init(),
            isUserInteractionEnabled: Bool = true,
            delegateAssigningClosure: @escaping (UITextField) -> Void = { _ in },
            flagButtonAction: @escaping () -> Void = { },
            clearButtonAction: @escaping () -> Void = { }
        ) {
            self.header = header
            self.prefix = prefix
            self.text = text
            self.defaultText = defaultText
            self.placeholder = placeholder
            self.clearButtonIcon = clearButtonIcon
            self.hint = hint
            self.divider = divider
            self.backgroundColor = backgroundColor
            self.border = border
            self.isUserInteractionEnabled = isUserInteractionEnabled
            self.delegateAssigningClosure = delegateAssigningClosure
            self.flagButtonAction = flagButtonAction
            self.clearButtonAction = clearButtonAction
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - UI
    
    private lazy var headerView: LabelView = {
        let view = LabelView()
        return view
    }()
    
    private lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.snp.makeConstraints { $0.size.equalTo(24) }
        return view
    }()
    
    private lazy var countryFlagButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(flagButtonTapped), for: .touchUpInside)
        button.snp.makeConstraints { $0.size.equalTo(24) }
        return button
    }()
    
    private lazy var countryCodeLabel: UILabel = {
        let label = UILabel()
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var dividerView: DividerView = {
        let divider = DividerView()
        return divider
    }()
    
    private lazy var textField: UITextField = {
        let textField = CorrectShiftedTextField(frame: .zero)
        textField.borderStyle = .none
        return textField
    }()
    
    private lazy var clearButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        button.snp.makeConstraints { $0.size.equalTo(24) }
        return button
    }()
    
    private lazy var hStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            iconView,
            countryFlagButton,
            countryCodeLabel,
            dividerView,
            textField,
            clearButton
        ])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var inputContainerView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.addSubview(hStack)
        hStack.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        view.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        return view
    }()
    
    private lazy var hintView: HintView = {
        let view = HintView()
        return view
    }()
    
    private lazy var vStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            headerView,
            inputContainerView,
            hintView
        ])
        stackView.axis = .vertical
        return stackView
    }()
    
    // MARK: - Init
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupView() {
        addSubview(vStack)
        vStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Public method
    
    public func update(with viewProperties: ViewProperties) {
        updateHeader(with: viewProperties.header)
        updatePrefix(with: viewProperties.prefix)
        updateTextField(with: viewProperties)
        updateClearButton(with: viewProperties)
        updateBorder(with: viewProperties.border)
        updateHintView(with: viewProperties.hint)
        updateDividerView(with: viewProperties.divider)
        inputContainerView.backgroundColor = viewProperties.backgroundColor
        self.viewProperties = viewProperties
    }
    
    // MARK: - Private methods
    
    private func updateHeader(with header: LabelView.ViewProperties?) {
        guard let header else { return }
        headerView.update(with: header)
    }
    
    private func updatePrefix(with prefix: Prefix) {
        switch prefix {
        case .icon(let image):
            updateIcon(image: image)
        case .country(let flag, let code):
            updateCountry(flag: flag, code: code)
        }
    }
    
    private func updateIcon(image: UIImage) {
        iconView.image = image
        iconView.isHidden = false
        countryFlagButton.isHidden = true
        countryCodeLabel.isHidden = true
        dividerView.isHidden = true
    }
    
    private func updateCountry(flag: UIImage?, code: NSAttributedString) {
        setImage(for: countryFlagButton, with: flag)
        countryCodeLabel.attributedText = code
        iconView.isHidden = true
        countryFlagButton.isHidden = flag == nil
        countryCodeLabel.isHidden = false
        dividerView.isHidden = false
    }
    
    private func updateTextField(with viewProperties: ViewProperties) {
        textField.defaultTextAttributes = viewProperties.defaultText.attributes(at: 0, effectiveRange: nil)
        textField.attributedText = viewProperties.text
        textField.attributedPlaceholder = viewProperties.placeholder
        viewProperties.delegateAssigningClosure(textField)
        isUserInteractionEnabled = viewProperties.isUserInteractionEnabled
    }
    
    private func updateClearButton(with viewProperties: ViewProperties) {
        setImage(for: clearButton, with: viewProperties.clearButtonIcon)
        clearButton.isHidden = textField.text?.isEmpty ?? true
    }
    
    private func updateBorder(with border: ViewProperties.Border) {
        inputContainerView.layer.borderColor = border.color.cgColor
        inputContainerView.layer.borderWidth = border.width
        inputContainerView.layer.cornerRadius = border.cornerRadius
    }
    
    private func updateHintView(with hint: HintView.ViewProperties) {
        hintView.update(with: hint)
    }
    
    private func updateDividerView(with divider: DividerView.ViewProperties) {
        dividerView.update(with: divider)
    }
    
    private func setImage(for button: UIButton, with image: UIImage?) {
        button.setImage(image, for: .normal)
        button.setImage(image, for: .highlighted)
        button.setImage(image, for: .disabled)
    }
    
    // MARK: - Actions
    
    @objc private func flagButtonTapped() {
        viewProperties.flagButtonAction()
    }
    
    @objc private func clearButtonTapped() {
        viewProperties.clearButtonAction()
    }
}

// MARK: - CorrectShiftedTextField -

public final class CorrectShiftedTextField: UITextField {
    
    public enum TextFieldShift {
        case robotoTextM
        
        var shifts: (text: CGFloat, placeholder: CGFloat) {
            switch self {
            case .robotoTextM:
                return (-2.67, 0)
            }
        }
    }
    
    public var textFieldShift: TextFieldShift = .robotoTextM {
        didSet {
            setNeedsLayout()
        }
    }
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        var newRect = super.textRect(forBounds: bounds)
        newRect.origin.y += textFieldShift.shifts.text
        return newRect
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var newRect = super.textRect(forBounds: bounds)
        newRect.origin.y += textFieldShift.shifts.text
        return newRect
    }
    
    public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        var newRect = super.textRect(forBounds: bounds)
        newRect.origin.y += textFieldShift.shifts.placeholder
        return newRect
    }
}
