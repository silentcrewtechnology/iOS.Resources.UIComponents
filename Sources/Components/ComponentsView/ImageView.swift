import UIKit
import SnapKit
import AccessibilityIds

public final class ImageView: UIView, ComponentProtocol {
    
    // MARK: - ViewProperties
    
    public struct ViewProperties {
        public var size: CGSize
        public var backgroundColor: UIColor
        public var cornerRadius: CGFloat
        public var text: NSMutableAttributedString?
        public var image: UIImage?
        public var margins: Margins
        public var accessibilityIds: AccessibilityIds?
        
        public init(
            size: CGSize = .zero,
            backgroundColor: UIColor = .clear,
            cornerRadius: CGFloat = 0,
            text: NSMutableAttributedString? = nil,
            image: UIImage? = nil,
            margins: Margins = .init(),
            accessibilityIds: AccessibilityIds? = nil
        ) {
            self.size = size
            self.backgroundColor = backgroundColor
            self.cornerRadius = cornerRadius
            self.text = text
            self.image = image
            self.margins = margins
            self.accessibilityIds = accessibilityIds
        }
        
        public struct Margins {
            public var imageTop: CGFloat
            public var imageBottom: CGFloat
            public var imageLeading: CGFloat
            public var imageTrailing: CGFloat
            public var size: CGSize
            
            public init(
                imageTop: CGFloat = 0,
                imageBottom: CGFloat = 0,
                imageLeading: CGFloat = 0,
                imageTrailing: CGFloat = 0,
                size: CGSize = .zero
            ) {
                self.imageTop = imageTop
                self.imageBottom = imageBottom
                self.imageLeading = imageLeading
                self.imageTrailing = imageTrailing
                self.size = size
            }
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
    
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - UI
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byClipping
        return label
    }()
    
    // MARK: - init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    public func update(with viewProperties: ViewProperties) {
        DispatchQueue.main.async {
            self.viewProperties = viewProperties
            self.updateBackground(with: viewProperties)
            self.setCornerRadius(with: viewProperties)
            self.updateText(with: viewProperties)
            self.updateImage(with: viewProperties)
            self.updateConstraints(with: viewProperties)
        }
        self.setupAccessibilityIds(with: viewProperties)
    }
    
    // MARK: - private methods
    
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
        imageView.snp.makeConstraints() {
            $0.top.equalToSuperview().offset(viewProperties.margins.imageTop)
            $0.leading.equalToSuperview().offset(viewProperties.margins.imageLeading)
            $0.trailing.equalToSuperview().offset(-viewProperties.margins.imageTrailing)
            $0.bottom.equalToSuperview().offset(-viewProperties.margins.imageBottom)
            $0.size.equalTo(viewProperties.margins.size)
        }
    }
    
    private func removeConstraintsAndSubviews() {
        self.subviews.forEach { subview in
            subview.snp.removeConstraints()
            subview.removeFromSuperview()
        }
    }
}
