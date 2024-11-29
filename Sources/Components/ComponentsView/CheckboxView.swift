import UIKit
import SnapKit
import AccessibilityIds

public final class CheckboxView: PressableView, ComponentProtocol {
    
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
            public var checkViewId: String?
            
            public init(
                id: String? = nil,
                checkViewId: String = DesignSystemAccessibilityIDs.CheckboxView.checkView
            ) {
                self.id = id
                self.checkViewId = checkViewId
            }
        }
        
        public init(
            backgroundColor: UIColor = .clear,
            size: CGSize = .zero,
            cornerRadius: CGFloat = 0,
            borderColor: UIColor = .clear,
            borderWidth: CGFloat = 0,
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
    
    public override func handlePress(state: State) {
        viewProperties.onPressChange(state)
    }
    
    // MARK: - Private properties
    
    private var viewProperties: ViewProperties = .init()
    
    private lazy var checkView = UIImageView()
    
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
        setupIndicator(with: viewProperties)
        setupAccessibilityIds(with: viewProperties)
        
        UIView.animate(withDuration: 0.1) {
            self.setupBackground(with: viewProperties)
            self.setupBorder(with: viewProperties)
        }
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        layer.masksToBounds = true
        snp.makeConstraints {
            $0.size.equalTo(0) // будет обновляться
        }
        
        addSubview(checkView)
        checkView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func setupBackground(with viewProperties: ViewProperties) {
        backgroundColor = viewProperties.backgroundColor
        layer.cornerRadius = viewProperties.cornerRadius
        
        snp.updateConstraints {
            $0.size.equalTo(viewProperties.size)
        }
    }
    
    private func setupBorder(with viewProperties: ViewProperties) {
        layer.borderColor = viewProperties.borderColor.cgColor
        layer.borderWidth = viewProperties.borderWidth
    }
    
    private func setupIndicator(with viewProperties: ViewProperties) {
        checkView.image = viewProperties.checkIcon
    }
    
    private func setupAccessibilityIds(with viewProperties: ViewProperties) {
        isAccessibilityElement = true
        accessibilityIdentifier = viewProperties.accessibilityIds?.id
        checkView.isAccessibilityElement = true
        checkView.accessibilityIdentifier = viewProperties.accessibilityIds?.checkViewId
    }
}
