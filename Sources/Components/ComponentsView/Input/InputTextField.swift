import UIKit
import SnapKit

public final class InputTextField: UITextField, ComponentProtocol {
    
    // MARK: - Properties
    
    public struct ViewProperties {
        public var text: NSMutableAttributedString
        public var textAttributes: [NSAttributedString.Key: Any]
        public var placeholder: NSMutableAttributedString
        public var cursorColor: UIColor
        public var delegateAssigningClosure: (UITextField) -> Void
        public var autocapitalizationType: UITextAutocapitalizationType
        public var textContentType: UITextContentType?
        public var keyboardType: UIKeyboardType
        public var isSecureTextEntry: Bool
        public var isHidden: Bool
        public var accessibilityId: String?
        
        public init(
            text: NSMutableAttributedString = .init(string: ""),
            textAttributes: [NSAttributedString.Key: Any] = [:],
            placeholder: NSMutableAttributedString = .init(string: ""),
            cursorColor: UIColor = .black,
            delegateAssigningClosure: @escaping (UITextField) -> Void = { _ in },
            autocapitalizationType: UITextAutocapitalizationType = .none,
            textContentType: UITextContentType? = nil,
            keyboardType: UIKeyboardType = .default,
            isSecureTextEntry: Bool = false,
            isHidden: Bool = false,
            accessibilityId: String? = nil
        ) {
            self.text = text
            self.textAttributes = textAttributes
            self.placeholder = placeholder
            self.cursorColor = cursorColor
            self.delegateAssigningClosure = delegateAssigningClosure
            self.autocapitalizationType = autocapitalizationType
            self.textContentType = textContentType
            self.keyboardType = keyboardType
            self.isSecureTextEntry = isSecureTextEntry
            self.isHidden = isHidden
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
        attributedPlaceholder = viewProperties.placeholder
        tintColor = viewProperties.cursorColor
        isSecureTextEntry = viewProperties.isSecureTextEntry
        isHidden = viewProperties.isHidden
        
        if let contentType = viewProperties.textContentType {
            textContentType = contentType
        }
        
        viewProperties.delegateAssigningClosure(self)
        updateText(with: viewProperties)
        setupAccessibilityId(with: viewProperties)
        self.viewProperties = viewProperties
    }
    
    // MARK: - Private methods
    
    private func updateText(with viewProperties: ViewProperties) {
        if let font = viewProperties.textAttributes[.font] as? UIFont {
            self.font = font
        }
        if let textColor = viewProperties.textAttributes[.foregroundColor] as? UIColor {
            self.textColor = textColor
        }
        text = viewProperties.text.string
    }
    
    private func setupAccessibilityId(with viewProperties: ViewProperties) {
        isAccessibilityElement = true
        accessibilityIdentifier = viewProperties.accessibilityId
        accessibilityLabel = viewProperties.accessibilityId
    }
}
