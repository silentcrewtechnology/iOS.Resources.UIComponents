import UIKit
import SnapKit

public final class ButtonView: UIButton, ComponentProtocol {
    
    // MARK: - ViewProperties
    
    public struct ViewProperties {
        public var isEnabled: Bool
        public var attributedText: NSMutableAttributedString?
        public var leftIcon: UIImage?
        public var backgroundColor: UIColor
        public var onHighlighted: (Bool) -> Void
        public var loader: UIView?
        public var onTap: () -> Void
        public var cornerRadius: CGFloat
        public var margins: Margins
        public var accessibilityIds: AccessibilityIds?
        
        public init(
            isEnabled: Bool = true,
            attributedText: NSMutableAttributedString = .init(string: ""),
            leftIcon: UIImage? = nil,
            backgroundColor: UIColor = .clear,
            loader: UIView? = nil,
            onHighlighted: @escaping (Bool) -> Void = { _ in },
            onTap: @escaping () -> Void = { },
            cornerRadius: CGFloat = 0,
            margins: Margins = .init(),
            accessibilityIds: AccessibilityIds? = nil
        ) {
            self.isEnabled = isEnabled
            self.attributedText = attributedText
            self.leftIcon = leftIcon
            self.backgroundColor = backgroundColor
            self.loader = loader
            self.onHighlighted = onHighlighted
            self.onTap = onTap
            self.cornerRadius = cornerRadius
            self.margins = margins
            self.accessibilityIds = accessibilityIds
        }
        
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
        
        public struct Margins {
            public var imageTop: CGFloat
            public var imageBottom: CGFloat
            public var top: CGFloat
            public var bottom: CGFloat
            public var leading: CGFloat
            public var trailing: CGFloat
            public var spacing: CGFloat
            public var height: CGFloat
            
            public init(
                imageTop: CGFloat = 0,
                imageBottom: CGFloat = 0,
                top: CGFloat = 0,
                bottom: CGFloat = 0,
                leading: CGFloat = 0,
                trailing: CGFloat = 0,
                spacing: CGFloat = 0,
                height: CGFloat = 0
            ) {
                self.imageTop = imageTop
                self.imageBottom = imageBottom
                self.top = top
                self.bottom = bottom
                self.leading = leading
                self.trailing = trailing
                self.spacing = spacing
                self.height = height
            }
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - UI
    
    private let leftIconView = UIImageView()
    private let textLabel = UILabel()
    
    public override var isHighlighted: Bool {
        didSet {
            viewProperties.onHighlighted(isHighlighted)
        }
    }
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Public Methods
    
    public func update(with viewProperties: ViewProperties) {
        DispatchQueue.main.async {
            self.viewProperties = viewProperties
            self.setupProperties(with: viewProperties)
            self.setCornerRadius(with: viewProperties)
            self.setupActionButton(with: viewProperties)
            self.updateConstraints(with: viewProperties)
        }
        setupAccessibilityIds(with: viewProperties)
    }
    
    // MARK: - Private Methods
    
    private func setupProperties(with viewProperties: ViewProperties) {
        backgroundColor = viewProperties.backgroundColor
        isUserInteractionEnabled = viewProperties.isEnabled
        textLabel.attributedText = viewProperties.attributedText
        textLabel.isHidden = !(viewProperties.loader?.isHidden ?? true)
        leftIconView.image = viewProperties.leftIcon
    }

    private func updateConstraints(with viewProperties: ViewProperties) {
        removeConstraintsAndSubviews()
        if viewProperties.leftIcon != nil {
            setupFullView()
        } else {
            setupLabelView()
        }
        setupLoaderView(with: viewProperties)
    }
    
    private func setupLabelView() {
        addSubview(textLabel)
        textLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(viewProperties.margins.top)
            $0.leading.equalToSuperview().offset(viewProperties.margins.leading)
            $0.trailing.equalToSuperview().offset(-viewProperties.margins.trailing)
            $0.bottom.equalToSuperview().offset(-viewProperties.margins.bottom)
        }
    }
    
    private func setupFullView() {
        addSubview(leftIconView)
        leftIconView.snp.makeConstraints() {
            $0.top.equalToSuperview().offset(viewProperties.margins.imageTop)
            $0.leading.equalToSuperview().offset(viewProperties.margins.leading)
            $0.bottom.equalToSuperview().offset(-viewProperties.margins.imageBottom)
        }
        
        addSubview(textLabel)
        textLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(viewProperties.margins.top)
            $0.leading.equalTo(leftIconView.snp.trailing).offset(viewProperties.margins.spacing)
            $0.trailing.equalToSuperview().offset(-viewProperties.margins.trailing)
            $0.bottom.equalToSuperview().offset(-viewProperties.margins.bottom)
        }
    }
    
    private func setupLoaderView(with viewProperties: ViewProperties) {
        guard let loader = viewProperties.loader else { return }
        
        addSubview(loader)
        loader.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    private func removeConstraintsAndSubviews() {
        self.subviews.forEach { subview in
            subview.snp.removeConstraints()
            subview.removeFromSuperview()
        }
    }
    
    private func setCornerRadius(with viewProperties: ViewProperties) {
        cornerRadius(
            radius: viewProperties.cornerRadius,
            direction: .allCorners,
            clipsToBounds: true
        )
    }
    
    private func setupActionButton(with viewProperties: ViewProperties) {
        addTarget(self, action: #selector(didTapAction), for: .touchUpInside)
    }
    
    @objc
    private func didTapAction() {
        self.viewProperties.onTap()
    }
    
    private func setupAccessibilityIds(with viewProperties: ViewProperties) {
        isAccessibilityElement = true
        accessibilityIdentifier = viewProperties.accessibilityIds?.id
        textLabel.isAccessibilityElement = true
        textLabel.accessibilityIdentifier = viewProperties.accessibilityIds?.labelId
    }
}
