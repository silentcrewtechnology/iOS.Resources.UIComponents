import UIKit
import SnapKit

public final class InputOTPItemView: UIView, ComponentProtocol {
    
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
    
    private var viewProperties: ViewProperties = .init()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupView() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { $0.center.equalToSuperview() }
        snp.makeConstraints { $0.size.equalTo(0) } // будет обновлено
    }
    
    public func update(with viewProperties: ViewProperties) {
        updateBackground(with: viewProperties)
        titleLabel.attributedText = viewProperties.text
        updateBorder(with: viewProperties)
        updateSize(size: viewProperties.size)
        self.viewProperties = viewProperties
        setupAccessibilityIds(with: viewProperties)
    }
    
    public func updateBackground(with viewProperties: ViewProperties) {
        backgroundColor = viewProperties.backgroundColor
        layer.cornerRadius = viewProperties.cornerRadius
    }
    
    public func updateBorder(with viewProperties: ViewProperties) {
        layer.borderColor = viewProperties.borderColor.cgColor
        layer.borderWidth = viewProperties.borderWidth
    }
    
    private func updateSize(size: CGSize) {
        guard self.viewProperties.size != size else { return }
        snp.updateConstraints { $0.size.equalTo(size) }
    }
    
    private func setupAccessibilityIds(with viewProperties: ViewProperties) {
        isAccessibilityElement = true
        accessibilityIdentifier = viewProperties.accessibilityIds?.id
        titleLabel.isAccessibilityElement = true
        titleLabel.accessibilityIdentifier = viewProperties.accessibilityIds?.labelId
    }
}
