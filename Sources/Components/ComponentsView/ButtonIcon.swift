import UIKit
import SnapKit
import AccessibilityIds

public final class ButtonIcon: UIButton, ComponentProtocol {
    
    // MARK: - ViewProperties
    
    public struct ViewProperties {
        public var backgroundColor: UIColor?
        public var pressedBackgroundColor: UIColor?
        public var imageColor: UIColor?
        public var pressedImageColor: UIColor?
        public var image: UIImage?
        public var cornerRadius: CGFloat
        public var margins: Margins
        // TODO: Убрать Optional у loader после удаления activityIndicator PCABO3-11972
        @available(*, deprecated, message: "Use LoaderView instead")
        public var activityIndicator: ActivityIndicatorView.ViewProperties
        public var loader: UIView?
        public var isEnabled: Bool
        public var accessibilityIds: AccessibilityIds?
        public var onTap: () -> Void
        
        public init(
            backgroundColor: UIColor? = nil,
            pressedBackgroundColor: UIColor? = nil,
            imageColor: UIColor? = nil,
            pressedImageColor: UIColor? = nil,
            image: UIImage? = nil,
            cornerRadius: CGFloat = 0,
            margins: Margins = .init(),
            activityIndicator: ActivityIndicatorView.ViewProperties = .init(),
            loader: UIView? = nil,
            isEnabled: Bool = true,
            accessibilityIds: AccessibilityIds? = nil,
            onTap: @escaping () -> Void = { }
        ) {
            self.backgroundColor = backgroundColor
            self.pressedBackgroundColor = pressedBackgroundColor
            self.imageColor = imageColor
            self.pressedImageColor = pressedImageColor
            self.image = image
            self.cornerRadius = cornerRadius
            self.margins = margins
            self.activityIndicator = activityIndicator
            self.loader = loader
            self.isEnabled = isEnabled
            self.accessibilityIds = accessibilityIds
            self.onTap = onTap
        }
        
        public struct AccessibilityIds {
            public var id: String
            public var iconViewId: String
            
            public init(id: String,
                        iconViewId: String = DesignSystemAccessibilityIDs.ButtonIconView.iconView
            ) {
                self.id = id
                self.iconViewId = iconViewId
            }
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
    }
    
    private var viewProperties: ViewProperties = .init()
    
    public override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? viewProperties.pressedBackgroundColor : viewProperties.backgroundColor
            
            if let imageColor = viewProperties.pressedImageColor {
                iconView.image = viewProperties.image?.withTintColor(imageColor)
            } else {
                iconView.image = viewProperties.image
            }
        }
    }
    
    // MARK: - UI
    
    private let iconView: UIImageView = {
        let image = UIImageView()
        image.snp.makeConstraints { $0.size.equalTo(0) }
        return image
    }()
    
    private let activityIndicator = ActivityIndicatorView()
    
    // MARK: - init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
        
        updateButtonAction(with: viewProperties)
        setBackgroundColor(with: viewProperties)
        setImage(with: viewProperties)
        setCornerRadius(with: viewProperties)
        updateConstraints(with: viewProperties)
        updateActivityIndicator(with: viewProperties)
        setupAccessibilityIds(with: viewProperties)
    }
    
    // MARK: - private methods
    
    private func updateButtonAction(with viewProperties: ViewProperties) {
        addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        isEnabled = viewProperties.isEnabled
    }
    
    @objc private func buttonTap() {
        viewProperties.onTap()
    }
    
    private func setBackgroundColor(with viewProperties: ViewProperties) {
        backgroundColor = viewProperties.backgroundColor
    }
    
    private func setImage(with viewProperties: ViewProperties) {
        if let imageColor = viewProperties.imageColor {
            iconView.image = viewProperties.image?.withTintColor(imageColor)
        } else {
            iconView.image = viewProperties.image
        }
    }
    
    private func setCornerRadius(with viewProperties: ViewProperties) {
        cornerRadius(
            radius: viewProperties.cornerRadius,
            direction: .allCorners,
            clipsToBounds: true
        )
    }
    
    private func updateConstraints(with viewProperties: ViewProperties) {
        subviews.forEach { $0.removeFromSuperview() }
        setupIconView(with: viewProperties)
        setupLoadingView(with: viewProperties)
    }
    
    private func setupIconView(with viewProperties: ViewProperties) {
        addSubview(iconView)
        iconView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(viewProperties.margins.imageTop)
            $0.leading.equalToSuperview().offset(viewProperties.margins.imageLeading)
            $0.trailing.equalToSuperview().offset(-viewProperties.margins.imageTrailing)
            $0.bottom.equalToSuperview().offset(-viewProperties.margins.imageBottom)
        }
        iconView.snp.updateConstraints {
            $0.size.equalTo(viewProperties.margins.size)
        }
    }
    
    private func setupLoadingView(with viewProperties: ViewProperties) {
        guard let loader = viewProperties.loader else {
            addSubview(activityIndicator)
            activityIndicator.snp.makeConstraints { $0.center.equalToSuperview() }
            return
        }
        addSubview(loader)
        loader.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
    private func updateActivityIndicator(with viewProperties: ViewProperties) {
        guard let loader = viewProperties.loader else {
            activityIndicator.update(with: viewProperties.activityIndicator)
            iconView.isHidden = viewProperties.activityIndicator.isAnimating
            return
        }
        iconView.isHidden = !loader.isHidden
    }
    
    private func setupAccessibilityIds(with viewProperties: ViewProperties) {
        isAccessibilityElement = true
        accessibilityIdentifier = viewProperties.accessibilityIds?.id
        iconView.isAccessibilityElement = true
        iconView.accessibilityIdentifier = viewProperties.accessibilityIds?.id
    }
}
