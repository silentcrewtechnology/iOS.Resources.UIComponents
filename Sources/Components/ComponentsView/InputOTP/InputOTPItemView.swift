import UIKit
import SnapKit

public final class InputOTPItemView: UIView, ComponentProtocol {
    
    // MARK: - Properties
    
    public struct ViewProperties {
        public var backgroundColor: UIColor
        public var size: CGSize
        public var cornerRadius: CGFloat
        public var text: NSMutableAttributedString
        public var borderColor: UIColor
        public var borderWidth: CGFloat
        public var accessibilityIds: AccessibilityIds?
        
        public struct AccessibilityIds {
            public var id: String
            public var labelId: String
            
            public init(
                id: String,
                labelId: String
            ) {
                self.id = id
                self.labelId = labelId
            }
        }
        
        public init(
            backgroundColor: UIColor = .clear,
            size: CGSize = .zero,
            cornerRadius: CGFloat = 0,
            text: NSMutableAttributedString = .init(string: ""),
            borderColor: UIColor = .clear,
            borderWidth: CGFloat = 0,
            accessibilityIds: AccessibilityIds? = nil
        ) {
            self.backgroundColor = backgroundColor
            self.size = size
            self.cornerRadius = cornerRadius
            self.text = text
            self.borderColor = borderColor
            self.borderWidth = borderWidth
            self.accessibilityIds = accessibilityIds
        }
    }
    
    // MARK: - Private properties
    
    private var viewProperties: ViewProperties = .init()
    
    private lazy var titleLabel = UILabel()
    
    // MARK: - Life cycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Methods
    
    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
        
        titleLabel.attributedText = viewProperties.text
        updateBackground(with: viewProperties)
        updateBorder(with: viewProperties)
        updateSize(with: viewProperties)
        setupAccessibilityIds(with: viewProperties)
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { $0.center.equalToSuperview() }
        snp.makeConstraints { $0.size.equalTo(0) } // будет обновлено
    }
    
    private func updateBackground(with viewProperties: ViewProperties) {
        layer.cornerRadius = viewProperties.cornerRadius
        
        UIView.animate(withDuration: 0.1) {
            self.backgroundColor = viewProperties.backgroundColor
        }
    }
    
    private func updateBorder(with viewProperties: ViewProperties) {
        layer.borderWidth = viewProperties.borderWidth
        
        UIView.animate(withDuration: 0.1) {
            self.layer.borderColor = viewProperties.borderColor.cgColor
        }
    }
    
    private func updateSize(with viewProperties: ViewProperties) {
        snp.updateConstraints { $0.size.equalTo(viewProperties.size) }
    }
    
    private func setupAccessibilityIds(with viewProperties: ViewProperties) {
        isAccessibilityElement = true
        accessibilityIdentifier = viewProperties.accessibilityIds?.id
        titleLabel.isAccessibilityElement = true
        titleLabel.accessibilityIdentifier = viewProperties.accessibilityIds?.labelId
    }
}
