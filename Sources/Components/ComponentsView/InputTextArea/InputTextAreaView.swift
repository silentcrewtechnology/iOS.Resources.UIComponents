import UIKit
import SnapKit
import AccessibilityIds

public final class InputTextAreaView: UIView, ComponentProtocol {
    
    // MARK: - Properties
    
    public struct ViewProperties {
        public var headerView: UIView?
        public var hintView: UIView
        public var minTextViewHeight: CGFloat
        public var cornerRadius: CGFloat
        public var stackViewSpacing: CGFloat
        public var maxNumberOfLines: Int
        public var stackViewInsets: UIEdgeInsets
        public var textViewInsets: UIEdgeInsets
        public var placeholderInsets: UIEdgeInsets
        public var placeholder: NSMutableAttributedString
        public var backgroundColor: UIColor
        public var isUserInteractionEnabled: Bool
        public var isPlaceholderHidden: Bool
        public var textViewProperties: InputTextView.ViewProperties
        public var border: Border
        public var onTextChanged: ((String?) -> Void)?
        
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
            headerView: UIView? = nil,
            hintView: UIView = .init(),
            minTextViewHeight: CGFloat = .zero,
            cornerRadius: CGFloat = .zero,
            stackViewSpacing: CGFloat = .zero,
            maxNumberOfLines: Int = 9,
            stackViewInsets: UIEdgeInsets = .zero,
            textViewInsets: UIEdgeInsets = .zero,
            placeholderInsets: UIEdgeInsets = .zero,
            placeholder: NSMutableAttributedString = .init(string: ""),
            backgroundColor: UIColor = .clear,
            isUserInteractionEnabled: Bool = true,
            isPlaceholderHidden: Bool = false,
            textViewProperties: InputTextView.ViewProperties = .init(),
            border: Border = .init(),
            onTextChanged: ((String?) -> Void)? = nil
        ) {
            self.headerView = headerView
            self.hintView = hintView
            self.minTextViewHeight = minTextViewHeight
            self.cornerRadius = cornerRadius
            self.stackViewSpacing = stackViewSpacing
            self.maxNumberOfLines = maxNumberOfLines
            self.stackViewInsets = stackViewInsets
            self.textViewInsets = textViewInsets
            self.placeholderInsets = placeholderInsets
            self.placeholder = placeholder
            self.backgroundColor = backgroundColor
            self.isUserInteractionEnabled = isUserInteractionEnabled
            self.isPlaceholderHidden = isPlaceholderHidden
            self.textViewProperties = textViewProperties
            self.border = border
            self.onTextChanged = onTextChanged
        }
    }
    
    // MARK: - Private properties
    
    private lazy var verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.isUserInteractionEnabled = true
        
        return stack
    }()
    
    private lazy var textViewContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(textViewTapped))
        )
        
        return view
    }()
    
    private lazy var textView = InputTextView()
    private lazy var placeholderLabel = UILabel()
    
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - Life cycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Public methods
    
    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
        
        stripNonTextFieldSubviews()
        setupHeaderViewIfNeeded(with: viewProperties)
        setupTextView(with: viewProperties)
        setupHintView(with: viewProperties)
        setupPlaceholderLabel(with: viewProperties)
        setupConstraints(with: viewProperties)
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        textViewContainer.addSubview(textView)
        textView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        textViewContainer.addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        verticalStack.addArrangedSubview(textViewContainer)
        addSubview(verticalStack)
        verticalStack.snp.makeConstraints { $0.edges.equalToSuperview() }
        textViewContainer.snp.makeConstraints { $0.height.equalTo(0) } // Будет обновляться
    }
    
    private func setupConstraints(with viewProperties: ViewProperties) {
        verticalStack.spacing = viewProperties.stackViewSpacing
        verticalStack.snp.updateConstraints {
            $0.edges.equalToSuperview().inset(viewProperties.stackViewInsets)
        }
        
        let additionalHeight = calculateAdditionalHeight(with: viewProperties)
        textViewContainer.snp.updateConstraints {
            $0.height.equalTo(viewProperties.minTextViewHeight + additionalHeight)
        }
        
        textView.snp.updateConstraints {
            $0.edges.equalToSuperview().inset(viewProperties.textViewInsets)
        }
        
        placeholderLabel.snp.updateConstraints {
            $0.edges.equalToSuperview().inset(viewProperties.placeholderInsets)
        }
    }
    
    private func setupTextView(with viewProperties: ViewProperties) {
        textViewContainer.layer.borderWidth = viewProperties.border.width
        textViewContainer.layer.cornerRadius = viewProperties.cornerRadius
        textViewContainer.isUserInteractionEnabled = viewProperties.isUserInteractionEnabled
        textView.update(with: viewProperties.textViewProperties)
        
        UIView.animate(withDuration: 0.1) {
            self.textViewContainer.backgroundColor = viewProperties.backgroundColor
            self.textViewContainer.layer.borderColor = viewProperties.border.color.cgColor
        }
    }
    
    private func stripNonTextFieldSubviews() {
        // textView должен оставаться в иерархии
        verticalStack.arrangedSubviews.forEach {
            if $0 !== textViewContainer {
                $0.removeFromSuperview()
            }
        }
    }
    
    private func setupHeaderViewIfNeeded(with viewProperties: ViewProperties) {
        guard let headerView = viewProperties.headerView else { return }
        verticalStack.insertArrangedSubview(headerView, at: 0)
    }
    
    private func setupHintView(with viewProperties: ViewProperties) {
        verticalStack.addArrangedSubview(viewProperties.hintView)
    }
    
    private func setupPlaceholderLabel(with viewProperties: ViewProperties) {
        placeholderLabel.attributedText = viewProperties.placeholder
        placeholderLabel.isHidden = viewProperties.isPlaceholderHidden
    }
    
    /// Не получилось перенести эту логику в сервис. Там некорректно считается
    /// boundingRect у viewProperties.textViewProperties.text
    private func calculateAdditionalHeight(with viewProperties: ViewProperties) -> CGFloat {
        var additionalHeight: CGFloat = .zero
        let maxNumberOfLines = CGFloat(viewProperties.maxNumberOfLines)
        if !viewProperties.textViewProperties.text.string.isEmpty {
            let boundingRect = viewProperties.textViewProperties.text.boundingRect(
                with: .init(
                    width: textView.bounds.width,
                    height: CGFloat.greatestFiniteMagnitude
                ),
                context: nil
            )
            let lineHeight = boundingRect.height
            let numberOfLines = textView.contentSize.height / lineHeight
            if numberOfLines <= maxNumberOfLines, numberOfLines > 1 {
                additionalHeight = lineHeight * (numberOfLines - 1)
            } else if numberOfLines > maxNumberOfLines {
                additionalHeight = lineHeight * (maxNumberOfLines - 1)
            }
        }
        
        return additionalHeight
    }
    
    @objc private func textViewTapped() {
        guard textViewContainer.isUserInteractionEnabled else { return }
        
        textView.becomeFirstResponder()
    }
}
