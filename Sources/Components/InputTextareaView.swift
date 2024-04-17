//
//  InputTextareaView.swift
//
//
//  Created by Ilnur Mugaev on 04.04.2024.
//

import UIKit
import SnapKit

public final class InputTextareaView: UIView {
    
    // MARK: - ViewProperties
    
    public enum TextViewHeight {
        case minimal
        case custom(lines: Int, autoResizeHeight: Bool)
    }
    
    public struct ViewProperties {
        public var header: LabelView.ViewProperties?
        public var text: NSMutableAttributedString?
        public var typingText: NSMutableAttributedString
        public var placeholder: NSMutableAttributedString
        public var hint: HintView.ViewProperties
        public var textViewHeight: TextViewHeight
        public var backgroundColor: UIColor
        public var border: Border
        public var cornerRadius: CGFloat
        public var isUserInteractionEnabled: Bool
        public var delegateAssigningClosure: (UITextView) -> Void
        
        public struct Border {
            public var color: UIColor
            public var width: CGFloat
            
            public init(
                color: UIColor = .clear,
                width: CGFloat = .zero
            ) {
                self.color = color
                self.width = width
            }
        }
        
        public init(
            header: LabelView.ViewProperties? = nil,
            text: NSMutableAttributedString = .init(string: ""),
            typingText: NSMutableAttributedString = .init(string: " "),
            placeholder: NSMutableAttributedString = .init(string: ""),
            hint: HintView.ViewProperties = .init(),
            textViewHeight: TextViewHeight = .custom(lines: 4, autoResizeHeight: false),
            backgroundColor: UIColor = .clear,
            border: Border = .init(),
            cornerRadius: CGFloat = .zero,
            isUserInteractionEnabled: Bool = true,
            delegateAssigningClosure: @escaping (UITextView) -> Void = { _ in }
        ) {
            self.header = header
            self.text = text
            self.typingText = typingText
            self.placeholder = placeholder
            self.hint = hint
            self.textViewHeight = textViewHeight
            self.backgroundColor = backgroundColor
            self.border = border
            self.cornerRadius = cornerRadius
            self.isUserInteractionEnabled = isUserInteractionEnabled
            self.delegateAssigningClosure = delegateAssigningClosure
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - UI
    
    private lazy var headerView: LabelView = {
        let view = LabelView()
        return view
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editTextView)))
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.layer.masksToBounds = true
        textView.textContainerInset = Constants.textViewContainerInset
        return textView
    }()
    
    private lazy var hintView: HintView = {
        let view = HintView()
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            headerView,
            textView,
            hintView
        ])
        stackView.axis = .vertical
        return stackView
    }()
    
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
        
        setupPlaceholderLabel(for: textView)
        setupGestureRecognizer()
    }
    
    // MARK: - Public method
    
    public func update(with viewProperties: ViewProperties) {
        updateHeader(with: viewProperties.header)
        updatePlaceholder(with: viewProperties.placeholder, text: viewProperties.text)
        updateTextView(with: viewProperties)
        updateHintView(with: viewProperties.hint)
        updateTextViewHeight(with: viewProperties)
        self.viewProperties = viewProperties
    }
    
    // MARK: - Private methods
    
    private func updateHeader(with header: LabelView.ViewProperties?) {
        guard let header else { return }
        headerView.update(with: header)
    }
    
    private func updatePlaceholder(
        with placeholder: NSAttributedString?,
        text: NSAttributedString?
    ) {
        placeholderLabel.attributedText = placeholder
        placeholderLabel.isHidden = text?.string.isEmpty == false
    }
    
    private func updateTextView(with viewProperties: ViewProperties) {
        textView.typingAttributes = viewProperties.typingText.attributes(at: 0, effectiveRange: nil)
        textView.attributedText = viewProperties.text
        textView.layer.borderColor = viewProperties.border.color.cgColor
        textView.layer.borderWidth = viewProperties.border.width
        textView.layer.cornerRadius = viewProperties.cornerRadius
        textView.backgroundColor = viewProperties.backgroundColor
        textView.isUserInteractionEnabled = viewProperties.isUserInteractionEnabled
        viewProperties.delegateAssigningClosure(textView)
    }
    
    private func updateHintView(with hint: HintView.ViewProperties) {
        hintView.update(with: hint)
    }
    
    private func updateTextViewHeight(with viewProperties: ViewProperties) {
        let boundingRect = viewProperties.typingText.boundingRect(
            with: .init(
                width: textView.bounds.width,
                height: CGFloat.greatestFiniteMagnitude),
            context: nil)
        let lineHeight = boundingRect.height
        
        switch viewProperties.textViewHeight {
        case .minimal:
            textView.isScrollEnabled = false
            textView.snp.makeConstraints {
                $0.height.greaterThanOrEqualTo(lineHeight + Constants.textViewVerticalPadding)
            }
        case let .custom(lines, autoResizeHeight):
            textView.isScrollEnabled = !autoResizeHeight
            let height = lineHeight * CGFloat(lines) + Constants.textViewVerticalPadding
            textView.snp.makeConstraints {
                if autoResizeHeight {
                    $0.height.greaterThanOrEqualTo(height)
                } else {
                    $0.height.equalTo(height)
                }
            }
        }
    }
    
    private func setupPlaceholderLabel(for textView: UITextView) {
        let textViewInset = textView.textContainerInset
        let placeholderLabelInset = UIEdgeInsets(
            top: textViewInset.top,
            left: textViewInset.left + Constants.placeholderHorizontalOffset,
            bottom: textViewInset.bottom,
            right: textViewInset.right + Constants.placeholderHorizontalOffset
        )
        
        textView.addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints {
            $0.edges.equalTo(textView).inset(placeholderLabelInset)
        }
        
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    private func setupGestureRecognizer() {
        let gr = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(gr)
    }
    
    // MARK: - Actions
    
    @objc private func editTextView() {
        textView.becomeFirstResponder()
    }
    
    @objc private func dismissKeyboard() {
        textView.resignFirstResponder()
    }
}

private enum Constants {
    static let textViewContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    static let textViewVerticalPadding: CGFloat = 16
    static let placeholderHorizontalOffset: CGFloat = 5
}
