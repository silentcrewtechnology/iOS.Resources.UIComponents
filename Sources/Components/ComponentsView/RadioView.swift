import UIKit
import SnapKit
import AccessibilityIds

public final class RadioView: PressableView, ComponentProtocol {
    
    // MARK: - Properties
    
    public struct ViewProperties {
        public var backgroundColor: UIColor
        public var size: CGSize
        public var cornerRadius: CGFloat
        public var borderColor: UIColor
        public var borderWidth: CGFloat
        public var checkIcon: UIImage?
        public var isUserInteractionEnabled: Bool
        public var accessibilityIds: AccessibilityIds?
        public var onPressChange: (State) -> Void
        public var onTap: ((Bool) -> Void)?
        
        public struct AccessibilityIds {
            public var id: String?
            public var indicatorViewId: String?
            
            public init(
                id: String? = nil,
                indicatorViewId: String = DesignSystemAccessibilityIDs.RadioView.indicatorView
            ) {
                self.id = id
                self.indicatorViewId = indicatorViewId
            }
        }
        
        public init(
            backgroundColor: UIColor = .clear,
            size: CGSize = .zero,
            cornerRadius: CGFloat = .zero,
            borderColor: UIColor = .clear,
            borderWidth: CGFloat = .zero,
            checkIcon: UIImage? = nil,
            isUserInteractionEnabled: Bool = true,
            accessibilityIds: AccessibilityIds? = nil,
            onPressChange: @escaping (State) -> Void = { _ in },
            onTap: ((Bool) -> Void)? = nil
        ) {
            self.backgroundColor = backgroundColor
            self.size = size
            self.cornerRadius = cornerRadius
            self.borderColor = borderColor
            self.borderWidth = borderWidth
            self.checkIcon = checkIcon
            self.isUserInteractionEnabled = isUserInteractionEnabled
            self.accessibilityIds = accessibilityIds
            self.onPressChange = onPressChange
            self.onTap = onTap
        }
    }
    
    // MARK: - Private properties
    
    private var viewProperties: ViewProperties = .init()
    
    private lazy var indicatorView = UIImageView()
    
    // MARK: - Life cycle
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Methods

    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
        
        isUserInteractionEnabled = viewProperties.isUserInteractionEnabled
        setCornerRadius(with: viewProperties)
        updateIndicator(with: viewProperties)
        updateConstraints(with: viewProperties)
        setupAccessibilityIds(with: viewProperties)
        
        UIView.animate(withDuration: 0.2) {
            self.updateBackground(with: viewProperties)
            self.updateBorder(with: viewProperties)
        }
    }
    
    public override func handlePress(state: State) {
        viewProperties.onPressChange(state)
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        layer.masksToBounds = true
        snp.makeConstraints {
            $0.size.equalTo(0) // будет обновляться
        }
        
        addSubview(indicatorView)
        indicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
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
    
    private func updateBorder(with viewProperties: ViewProperties) {
        layer.borderColor = viewProperties.borderColor.cgColor
        layer.borderWidth = viewProperties.borderWidth
    }
    
    private func updateIndicator(with viewProperties: ViewProperties) {
        indicatorView.image = viewProperties.checkIcon
    }
    
    private func updateConstraints(with viewProperties: ViewProperties) {
        snp.updateConstraints {
            $0.size.equalTo(viewProperties.size)
        }
    }

    private func setupAccessibilityIds(with viewProperties: ViewProperties) {
        isAccessibilityElement = true
        accessibilityIdentifier = viewProperties.accessibilityIds?.id
        indicatorView.isAccessibilityElement = true
        indicatorView.accessibilityIdentifier = viewProperties.accessibilityIds?.indicatorViewId
    }
}
