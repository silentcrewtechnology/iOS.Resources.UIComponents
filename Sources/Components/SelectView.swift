//
//  SelectView.swift
//
//
//  Created by Ilnur Mugaev on 20.12.2023.
//

import UIKit
import SnapKit

public final class SelectView: UIView {
    
    public struct ViewProperties {
        public var header: NSMutableAttributedString?
        public var text: NSMutableAttributedString = .init(string: "")
        public var placeholder: NSMutableAttributedString = .init(string: "")
        public var hint: NSMutableAttributedString = .init(string: "")
        public var isHintHidden = true
        public var isUserInteractionEnabled = true
        public var borderColor: UIColor = .clear
        public var backgroundColor: UIColor = .clear
        public var clearButtonIsHidden: Bool = true
        public var clearButtonIcon: UIImage?
        public var disclosureIcon: UIImage?
        public var clearButtonAction: () -> Void = { }
        public var inputTapAction: () -> Void = { }
    }
    
    // MARK: - UI
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.addSubview(headerLabel)
        headerLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Constants.labelInset)
        }
        return view
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.borderStyle = .none
        textField.isUserInteractionEnabled = false
        textField.contentVerticalAlignment = .top
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
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
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
    
    private lazy var hintLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var hintView: UIView = {
        let view = UIView()
        view.addSubview(hintLabel)
        hintLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Constants.labelInset)
        }
        view.snp.makeConstraints {
            $0.height.equalTo(24)
        }
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
    
    // MARK: - Public Methods
    
    public func update(with viewProperties: ViewProperties) {
        updateView(with: viewProperties)
        self.viewProperties = viewProperties
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func updateView(with viewProperties: ViewProperties) {
        
        headerLabel.attributedText = viewProperties.header
        headerView.isHidden = viewProperties.header?.string.isEmpty != false
        
        textField.attributedText = viewProperties.text
        textField.attributedPlaceholder = viewProperties.placeholder
        
        clearButton.setImage(viewProperties.clearButtonIcon, for: .normal)
        clearButton.setImage(viewProperties.clearButtonIcon, for: .highlighted)
        clearButton.setImage(viewProperties.clearButtonIcon, for: .disabled)
        clearButton.isHidden = viewProperties.clearButtonIsHidden
        
        disclosureImageView.image = viewProperties.disclosureIcon
        
        hintLabel.attributedText = viewProperties.hint
        hintLabel.isHidden = viewProperties.isHintHidden
        
        inputContainerView.isUserInteractionEnabled = viewProperties.isUserInteractionEnabled
        inputContainerView.layer.borderColor = viewProperties.borderColor.cgColor
        inputContainerView.backgroundColor = viewProperties.backgroundColor
    }
    
    @objc private func clearButtonTapped() {
        viewProperties.clearButtonAction()
    }
    
    @objc private func inputContainerViewTapped() {
        viewProperties.inputTapAction()
    }
}

private enum Constants {
    static let labelInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
}
