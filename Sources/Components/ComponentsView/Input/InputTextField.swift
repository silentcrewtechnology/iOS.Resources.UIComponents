import UIKit
import SnapKit

public final class InputTextField: UITextField, ComponentProtocol {
    
    // MARK: - Properties
    
    public struct ViewProperties {
        public var text: NSMutableAttributedString
        public var placeholder: NSMutableAttributedString
        public var cursorColor: UIColor
        public var delegateAssigningClosure: (UITextField) -> Void
        public var autocapitalizationType: UITextAutocapitalizationType
        public var keyboardType: UIKeyboardType
        public var isSecureTextEntry: Bool
        public var accessibilityId: String?
        
        public init(
            text: NSMutableAttributedString = .init(string: ""),
            placeholder: NSMutableAttributedString = .init(string: ""),
            cursorColor: UIColor = .black,
            delegateAssigningClosure: @escaping (UITextField) -> Void = { _ in },
            autocapitalizationType: UITextAutocapitalizationType = .none,
            keyboardType: UIKeyboardType = .default,
            isSecureTextEntry: Bool = false,
            accessibilityId: String? = nil
        ) {
            self.text = text
            self.placeholder = placeholder
            self.delegateAssigningClosure = delegateAssigningClosure
            self.autocapitalizationType = autocapitalizationType
            self.keyboardType = keyboardType
            self.cursorColor = cursorColor
            self.isSecureTextEntry = isSecureTextEntry
            self.accessibilityId = accessibilityId
        }
    }
    
    public override var canBecomeFirstResponder: Bool { true }
    
    // MARK: - Private properties
    
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - Methods
    
    public func update(with viewProperties: ViewProperties) {
        autocapitalizationType = viewProperties.autocapitalizationType
        keyboardType = viewProperties.keyboardType
        updateText(attributedText: viewProperties.text)
        attributedPlaceholder = viewProperties.placeholder
        tintColor = viewProperties.cursorColor
        viewProperties.delegateAssigningClosure(self)
        isSecureTextEntry = viewProperties.isSecureTextEntry
        setupAccessibilityId(with: viewProperties)
        self.viewProperties = viewProperties
    }
    
    // MARK: - Private methods
    
    private func updateText(attributedText: NSMutableAttributedString) {
        // корректное позиционирование attributedText с lineHeight
        var effectiveRange = attributedText.fullRange()
        guard effectiveRange.length > 0 else { return }
        let attributes = attributedText.attributes(
            at: 0,
            effectiveRange: &effectiveRange)
        font = attributes[.font] as? UIFont
        textColor = attributes[.foregroundColor] as? UIColor
        text = attributedText.string
    }
    
    private func setupAccessibilityId(with viewProperties: ViewProperties) {
        isAccessibilityElement = true
        accessibilityIdentifier = viewProperties.accessibilityId
        accessibilityLabel = viewProperties.accessibilityId
    }
}
