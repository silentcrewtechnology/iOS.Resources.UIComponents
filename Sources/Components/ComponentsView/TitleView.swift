import UIKit
import SnapKit
import AccessibilityIds

public final class TitleView: UIView, ComponentProtocol {
    
    // MARK: - ViewProperties
    
    public struct ViewProperties {
        public var title: NSMutableAttributedString
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
            backgroundColor: UIColor = .clear,
            insets: UIEdgeInsets = .zero,
            accessibilityIds: AccessibilityIds? = nil
        ) {
            self.title = title
            self.backgroundColor = backgroundColor
            self.insets = insets
            self.accessibilityIds = accessibilityIds
        }
    }
    
    // MARK: - Private properties
    
    private var viewProperties: ViewProperties = .init()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        
        return label
    }()
    
    // MARK: - Life cycle
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Public method
    
    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
        
        backgroundColor = viewProperties.backgroundColor
        updateLabel(text: viewProperties.title)
        updateInsets(viewProperties.insets)
        setupAccessibilityIds(with: viewProperties)
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func updateLabel(text: NSAttributedString?) {
        titleLabel.isHidden = text != nil ? false : true
        titleLabel.attributedText = text
    }
    
    private func updateInsets(_ insets: UIEdgeInsets) {
        titleLabel.snp.updateConstraints {
            $0.edges.equalToSuperview().inset(insets)
        }
    }
    
    private func setupAccessibilityIds(with viewProperties: ViewProperties) {
        isAccessibilityElement = true
        accessibilityIdentifier = viewProperties.accessibilityIds?.id
        titleLabel.isAccessibilityElement = true
        titleLabel.accessibilityIdentifier = viewProperties.accessibilityIds?.labelId
    }
}
