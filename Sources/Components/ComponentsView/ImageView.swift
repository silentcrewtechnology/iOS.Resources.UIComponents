import UIKit
import SnapKit
import AccessibilityIds

public final class ImageView: UIView, ComponentProtocol {
    
    // MARK: - ViewProperties
    
    public struct ViewProperties {
        public var size: CGSize
        public var imageSize: CGSize
        public var backgroundColor: UIColor
        public var cornerRadius: CGFloat
        public var text: NSMutableAttributedString?
        public var image: UIImage?
        public var accessibilityIds: AccessibilityIds?
        
        public init(
            size: CGSize = .zero,
            imageSize: CGSize = .zero,
            backgroundColor: UIColor = .clear,
            cornerRadius: CGFloat = .zero,
            text: NSMutableAttributedString? = nil,
            image: UIImage? = nil,
            accessibilityIds: AccessibilityIds? = nil
        ) {
            self.size = size
            self.imageSize = imageSize
            self.backgroundColor = backgroundColor
            self.cornerRadius = cornerRadius
            self.text = text
            self.image = image
            self.accessibilityIds = accessibilityIds
        }
        
        public struct AccessibilityIds {
            public var id: String?
            public var imageViewId: String?
            public var titleLabelId: String?
            
            public init(
                id: String? = nil,
                imageViewId: String = DesignSystemAccessibilityIDs.ImageView.imageView,
                titleLabelId: String = DesignSystemAccessibilityIDs.ImageView.titleLabel
            ) {
                self.id = id
                self.imageViewId = imageViewId
                self.titleLabelId = titleLabelId
            }
        }
    }
    
    // MARK: - Private properties
    
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - UI
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byClipping
        
        return label
    }()
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Methods
    
    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
        
        updateBackground(with: viewProperties)
        setCornerRadius(with: viewProperties)
        updateText(with: viewProperties)
        updateImage(with: viewProperties)
        updateConstraints(with: viewProperties)
        setupAccessibilityIds(with: viewProperties)
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        snp.makeConstraints {
            $0.size.equalTo(0)
        }
    }
    
    private func updateBackground(with viewProperties: ViewProperties) {
        backgroundColor = viewProperties.backgroundColor
    }
    
    private func setCornerRadius(with viewProperties: ViewProperties) {
        cornerRadius(
            radius: viewProperties.cornerRadius,
            direction: .allCorners,
            clipsToBounds: true
        )
    }
    
    private func updateText(with viewProperties: ViewProperties) {
        titleLabel.attributedText = viewProperties.text
    }
    
    private func updateImage(with viewProperties: ViewProperties) {
        imageView.image = viewProperties.image
    }
    
    private func updateConstraints(with viewProperties: ViewProperties) {
        removeConstraintsAndSubviews()
        
        snp.updateConstraints {
            $0.size.equalTo(viewProperties.size)
        }
        
        setupTitleLabel()
        setupImageView()
    }
    
    private func setupAccessibilityIds(with viewProperties: ViewProperties) {
        isAccessibilityElement = true
        accessibilityIdentifier = viewProperties.accessibilityIds?.id
        imageView.isAccessibilityElement = true
        imageView.accessibilityIdentifier = viewProperties.accessibilityIds?.imageViewId
        titleLabel.isAccessibilityElement = true
        titleLabel.accessibilityIdentifier = viewProperties.accessibilityIds?.titleLabelId
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func setupImageView() {
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(viewProperties.imageSize)
        }
    }
    
    private func removeConstraintsAndSubviews() {
        subviews.forEach { subview in
            subview.snp.removeConstraints()
            subview.removeFromSuperview()
        }
    }
}
