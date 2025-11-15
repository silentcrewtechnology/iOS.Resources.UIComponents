import UIKit
import SnapKit
import AccessibilityIds

public final class ButtonIcon: UIButton, ComponentProtocol {
    
    // MARK: - ViewProperties
    
    public struct ViewProperties {
        public var backgroundColor: UIColor?
        public var image: UIImage?
        public var cornerRadius: CGFloat
        public var margins: Margins
        public var loader: UIView?
        public var isEnabled: Bool
        public var accessibilityIds: AccessibilityIds?
        public var onTap: (() -> Void)?
        public var onHighlighted: (Bool) -> Void
        
        public init(
            backgroundColor: UIColor? = nil,
            image: UIImage? = nil,
            cornerRadius: CGFloat = 0,
            margins: Margins = .init(),
            loader: UIView? = nil,
            isEnabled: Bool = true,
            accessibilityIds: AccessibilityIds? = nil,
            onTap:(() -> Void)? = nil,
            onHighlighted: @escaping (Bool) -> Void = { _ in }
        ) {
            self.backgroundColor = backgroundColor
            self.image = image
            self.cornerRadius = cornerRadius
            self.margins = margins
            self.loader = loader
            self.isEnabled = isEnabled
            self.accessibilityIds = accessibilityIds
            self.onTap = onTap
            self.onHighlighted = onHighlighted
        }
        
        public struct AccessibilityIds {
            public var id: String
            public var iconViewId: String
            
            public init(
                id: String,
                iconViewId: String = DesignSystemAccessibilityIDs.ButtonIconView.iconView
            ) {
                self.id = id
                self.iconViewId = iconViewId
            }
        }
        
        public struct Margins {
            public var insets: UIEdgeInsets
            public var size: CGSize
            
            public init(
                insets: UIEdgeInsets = .zero,
                size: CGSize = .zero
            ) {
                self.insets = insets
                self.size = size
            }
        }
    }
    
    public override var isHighlighted: Bool {
        didSet {
            viewProperties.onHighlighted(isHighlighted)
        }
    }
    
    // MARK: - Private properties
    
    private var viewProperties: ViewProperties = .init()
    
    private lazy var iconView: UIImageView = {
        let image = UIImageView()
        image.snp.makeConstraints { $0.size.equalTo(0) }
        
        return image
    }()
    
    // MARK: - Methods

    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
        
        updateButtonAction(with: viewProperties)
        setCornerRadius(with: viewProperties)
        setupView(with: viewProperties)
        setupAccessibilityIds(with: viewProperties)
        
        UIView.animate(withDuration: 0.1) {
            self.backgroundColor = viewProperties.backgroundColor
        }
    }
    
    // MARK: - Private methods
    
    private func updateButtonAction(with viewProperties: ViewProperties) {
        addTarget(self, action: #selector(didTapAction), for: .touchUpInside)
        isEnabled = viewProperties.isEnabled
    }
    
    private func setCornerRadius(with viewProperties: ViewProperties) {
        cornerRadius(
            radius: viewProperties.cornerRadius,
            direction: .allCorners,
            clipsToBounds: true
        )
    }
    
    private func setupView(with viewProperties: ViewProperties) {
        removeConstraintsAndSubviews()
        
        setupIconView(with: viewProperties)
        setupLoaderView(with: viewProperties)
    }
    
    private func setupIconView(with viewProperties: ViewProperties) {
        addSubview(iconView)
        iconView.image = viewProperties.image
        iconView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(viewProperties.margins.insets)
        }
        
        iconView.snp.updateConstraints {
            $0.size.equalTo(viewProperties.margins.size)
        }
    }
    
    private func setupLoaderView(with viewProperties: ViewProperties) {
        guard let loader = viewProperties.loader else { return }
        
        addSubview(loader)
        loader.snp.makeConstraints { $0.center.equalToSuperview() }
        iconView.isHidden = !loader.isHidden
    }
    
    private func removeConstraintsAndSubviews() {
        subviews.forEach { subview in
            subview.removeFromSuperview()
        }
    }
    
    private func setupAccessibilityIds(with viewProperties: ViewProperties) {
        isAccessibilityElement = true
        accessibilityIdentifier = viewProperties.accessibilityIds?.id
        iconView.isAccessibilityElement = true
        iconView.accessibilityIdentifier = viewProperties.accessibilityIds?.id
    }
    
    @objc private func didTapAction() {
        self.viewProperties.onTap?()
    }
}
