import UIKit
import SnapKit
import AccessibilityIds

public final class TitleView: UIView, ComponentProtocol {
    
    // MARK: - ViewProperties
    
    public struct ViewProperties {
        public var title: NSMutableAttributedString
        public var description: NSMutableAttributedString
        public var buttonIcon: UIView
        public var backgroundColor: UIColor
        public var insets: UIEdgeInsets
        public var accessibilityIds: AccessibilityIds?
        
        public struct AccessibilityIds {
            public var id: String
            public var labelId: String
            
            public init(
                id: String,
                labelId: String = DesignSystemAccessibilityIDs.TitleView.label
            ) {
                self.id = id
                self.labelId = labelId
            }
        }
        
        public init(
            title: NSMutableAttributedString = .init(string: ""),
            description: NSMutableAttributedString = .init(string: ""),
            buttonIcon: UIView = .init(),
            backgroundColor: UIColor = .clear,
            insets: UIEdgeInsets = .zero,
            accessibilityIds: AccessibilityIds? = nil
        ) {
            self.title = title
            self.description = description
            self.buttonIcon = buttonIcon
            self.backgroundColor = backgroundColor
            self.insets = insets
            self.accessibilityIds = accessibilityIds
        }
    }
    
    // MARK: - Private properties
    
    private var viewProperties: ViewProperties = .init()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        return label
    }()
    
    private let hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .top
        stack.spacing = 16
        return stack
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            hStack,
            descriptionLabel,
        ])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    // MARK: - Life cycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Public method
    
    public func update(with viewProperties: ViewProperties) {
        backgroundColor = viewProperties.backgroundColor
        updateHStack(with: viewProperties)
        updateDescription(text: viewProperties.description)
        updateInsets(insets: viewProperties.insets)
        setupAccessibilityIds(with: viewProperties)
        self.viewProperties = viewProperties
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        addSubview(vStack)
        vStack.snp.makeConstraints {
            $0.edges.equalToSuperview() // добавятся отступы
        }
    }
    
    private func updateHStack(with viewProperties: ViewProperties) {
        hStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        updateTitle(title: viewProperties.title)
        hStack.addArrangedSubview(viewProperties.buttonIcon)
    }
    
    private func updateTitle(title: NSMutableAttributedString) {
        guard !title.string.isEmpty else {
            // чтобы кнопка прижалась к правому краю
            return hStack.addArrangedSubview(growingHSpacer)
        }
        titleLabel.attributedText = title
        hStack.addArrangedSubview(titleLabel)
    }
    
    private func updateButton(buttonIcon: UIView) {
        guard !buttonIcon.isHidden else { return }
        hStack.addArrangedSubview(buttonIcon)
    }
    
    private lazy var growingHSpacer: UIView = {
        let view = UIView()
        view.snp.makeConstraints { $0.width.equalTo(CGFloat.greatestFiniteMagnitude).priority(.low) }
        return view
    }()
    
    private func updateDescription(text: NSAttributedString) {
        descriptionLabel.attributedText = text
        descriptionLabel.isHidden = text.string.isEmpty
    }
    
    private func updateInsets(insets: UIEdgeInsets) {
        vStack.snp.updateConstraints {
            $0.edges.equalToSuperview().inset(insets)
        }
    }
    
    private func setupAccessibilityIds(with viewProperties: ViewProperties) {
        isAccessibilityElement = true
        accessibilityIdentifier = viewProperties.accessibilityIds?.id
        titleLabel.isAccessibilityElement = true
        titleLabel.accessibilityIdentifier = viewProperties.accessibilityIds?.labelId
        // TODO: descriptionLabel.accessibilityIdentifier PCABO3-11971
    }
}
