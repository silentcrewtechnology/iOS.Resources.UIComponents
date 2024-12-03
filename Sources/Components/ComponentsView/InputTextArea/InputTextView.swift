import UIKit
import SnapKit

public final class InputTextView: UITextView, ComponentProtocol {
    
    // MARK: - Properties
    
    public struct ViewProperties {
        public var text: NSMutableAttributedString
        public var textContainerInset: UIEdgeInsets
        public var contentInset: UIEdgeInsets
        public var textAttributes: [NSAttributedString.Key: Any]
        public var cursorColor: UIColor
        public var backgroundColor: UIColor
        public var delegateAssigningClosure: (UITextView) -> Void
        public var autocapitalizationType: UITextAutocapitalizationType
        public var keyboardType: UIKeyboardType
        public var isSecureTextEntry: Bool
        public var lineFragmentPadding: CGFloat
        public var accessibilityId: String?
        
        public init(
            text: NSMutableAttributedString = .init(string: ""),
            textAttributes: [NSAttributedString.Key: Any] = [:],
            textContainerInset: UIEdgeInsets = .zero,
            contentInset: UIEdgeInsets = .zero,
            placeholder: NSMutableAttributedString = .init(string: ""),
            cursorColor: UIColor = .black,
            backgroundColor: UIColor = .clear,
            delegateAssigningClosure: @escaping (UITextView) -> Void = { _ in },
            autocapitalizationType: UITextAutocapitalizationType = .none,
            keyboardType: UIKeyboardType = .default,
            isSecureTextEntry: Bool = false,
            lineFragmentPadding: CGFloat = .zero,
            accessibilityId: String? = nil
        ) {
            self.text = text
            self.textAttributes = textAttributes
            self.textContainerInset = textContainerInset
            self.contentInset = contentInset
            self.cursorColor = cursorColor
            self.backgroundColor = backgroundColor
            self.delegateAssigningClosure = delegateAssigningClosure
            self.autocapitalizationType = autocapitalizationType
            self.keyboardType = keyboardType
            self.isSecureTextEntry = isSecureTextEntry
            self.lineFragmentPadding = lineFragmentPadding
            self.accessibilityId = accessibilityId
        }
    }
    
    public override var canBecomeFirstResponder: Bool { true }
    
    // MARK: - Private properties
    
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - Methods
    
    public func update(with viewProperties: ViewProperties) {
        autocapitalizationType = viewProperties.autocapitalizationType
        textContainerInset = viewProperties.textContainerInset
        keyboardType = viewProperties.keyboardType
        tintColor = viewProperties.cursorColor
        isSecureTextEntry = viewProperties.isSecureTextEntry
        backgroundColor = viewProperties.backgroundColor
        textContainer.lineFragmentPadding = viewProperties.lineFragmentPadding
        contentInset = viewProperties.contentInset
        updateText(with: viewProperties)
        setupAccessibilityId(with: viewProperties)
        viewProperties.delegateAssigningClosure(self)
        
        self.viewProperties = viewProperties
    }
    
    // MARK: - Private methods
    
    private func updateText(with viewProperties: ViewProperties) {
        attributedText = viewProperties.text
        typingAttributes = viewProperties.textAttributes
    }
    
    private func setupAccessibilityId(with viewProperties: ViewProperties) {
        isAccessibilityElement = true
        accessibilityIdentifier = viewProperties.accessibilityId
        accessibilityLabel = viewProperties.accessibilityId
    }
}
