//
//  InputSelectView.swift
//
//
//  Created by Ilnur Mugaev on 16.04.2024.
//

import UIKit
import SnapKit

public final class InputSelectView: UIView {
    
    public struct ViewProperties {
        public var header: LabelView.ViewProperties?
        public var text: NSMutableAttributedString
        public var placeholder: NSMutableAttributedString
        public var clearButtonIcon: UIImage
        public var disclosureIcon: UIImage
        public var hint: HintView.ViewProperties
        public var border: Border
        public var backgroundColor: UIColor
        public var isUserInteractionEnabled: Bool
        public var clearButtonAction: () -> Void
        public var inputTapAction: () -> Void
        
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
            text: NSMutableAttributedString = .init(string: ""),
            placeholder: NSMutableAttributedString = .init(string: ""),
            clearButtonIcon: UIImage = .init(),
            disclosureIcon: UIImage = .init(),
            hint: HintView.ViewProperties = .init(),
            border: Border = .init(),
            backgroundColor: UIColor = .clear,
            isUserInteractionEnabled: Bool = true,
            clearButtonAction: @escaping () -> Void = { },
            inputTapAction: @escaping () -> Void = { }
        ) {
            self.header = header
            self.text = text
            self.placeholder = placeholder
            self.clearButtonIcon = clearButtonIcon
            self.disclosureIcon = disclosureIcon
            self.hint = hint
            self.isUserInteractionEnabled = isUserInteractionEnabled
            self.border = border
            self.backgroundColor = backgroundColor
            self.clearButtonAction = clearButtonAction
            self.inputTapAction = inputTapAction
        }
    }
    
    // MARK: - UI
    
    private lazy var headerView: LabelView = {
        let view = LabelView()
        return view
    }()
    
    private lazy var textField: UITextField = {
        let textField = CorrectShiftedTextField(frame: .zero)
        textField.borderStyle = .none
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    private lazy var clearButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        button.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        return button
    }()
    
    private lazy var disclosureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        return imageView
    }()
    
    private lazy var inputStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            textField,
            clearButton,
            disclosureImageView
        ])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var inputContainerView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.addSubview(inputStackView)
        inputStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        view.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(inputContainerViewTapped))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private lazy var hintView: HintView = {
        let view = HintView()
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            headerView,
            inputContainerView,
            hintView
        ])
        stackView.axis = .vertical
        return stackView
    }()
    
    // MARK: - Private Properties
    
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupView() {
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Public Methods
    
    public func update(with viewProperties: ViewProperties) {
        updateHeader(with: viewProperties.header)
        updateTextField(with: viewProperties)
        updateClearButton(with: viewProperties)
        updateBorder(with: viewProperties.border)
        updateHintView(with: viewProperties.hint)
        disclosureImageView.image = viewProperties.disclosureIcon
        inputContainerView.backgroundColor = viewProperties.backgroundColor
        isUserInteractionEnabled = viewProperties.isUserInteractionEnabled
        self.viewProperties = viewProperties
    }
    
    // MARK: - Private Methods
    
    private func updateHeader(with header: LabelView.ViewProperties?) {
        guard let header else { return }
        headerView.update(with: header)
    }
    
    private func updateTextField(with viewProperties: ViewProperties) {
        textField.attributedText = viewProperties.text
        textField.attributedPlaceholder = viewProperties.placeholder
    }
    
    private func updateClearButton(with viewProperties: ViewProperties) {
        clearButton.setImage(viewProperties.clearButtonIcon, for: .normal)
        clearButton.setImage(viewProperties.clearButtonIcon, for: .highlighted)
        clearButton.setImage(viewProperties.clearButtonIcon, for: .disabled)
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
    
    // MARK: - Actions
    
    @objc private func clearButtonTapped() {
        viewProperties.clearButtonAction()
    }
    
    @objc private func inputContainerViewTapped() {
        viewProperties.inputTapAction()
    }
}
