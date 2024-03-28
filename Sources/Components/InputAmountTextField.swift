import UIKit

public final class InputAmountTextField: UITextField {
    
    public struct ViewProperties {
        public var text: NSMutableAttributedString
        public var textAttributes: [NSAttributedString.Key: Any]
        public var placeholder: NSMutableAttributedString
        public var cursorColor: UIColor
        public var delegateAssigningClosure: (UITextField) -> Void
        
        public init(
            text: NSMutableAttributedString = .init(string: ""),
            textAttributes: [NSAttributedString.Key: Any] = [:],
            placeholder: NSMutableAttributedString = .init(string: ""),
            cursorColor: UIColor = .black,
            delegateAssigningClosure: @escaping (UITextField) -> Void = { _ in }
        ) {
            self.text = text
            self.textAttributes = textAttributes
            self.placeholder = placeholder
            self.cursorColor = cursorColor
            self.delegateAssigningClosure = delegateAssigningClosure
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    public func update(with viewProperties: ViewProperties) {
        updateView(viewProperties: viewProperties)
        self.viewProperties = viewProperties
    }
    
    private var wasSetup = false
    
    private func setupView() {
        guard !wasSetup else { return }
        wasSetup = true
        keyboardType = .decimalPad
        autocapitalizationType = .none
        autocorrectionType = .no
        spellCheckingType = .no
    }
    
    private func updateView(viewProperties: ViewProperties) {
        viewProperties.delegateAssigningClosure(self)
        attributedText = viewProperties.text
        defaultTextAttributes = viewProperties.textAttributes
        typingAttributes = viewProperties.textAttributes
        attributedPlaceholder = viewProperties.placeholder
        tintColor = viewProperties.cursorColor
    }
    
    public override var canBecomeFirstResponder: Bool { true }
}
