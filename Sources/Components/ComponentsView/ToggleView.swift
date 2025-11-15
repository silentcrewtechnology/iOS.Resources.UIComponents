import UIKit
import AccessibilityIds

public final class ToggleView: UIView, ComponentProtocol {
    
    // MARK: - Properties
    
    public struct ViewProperties {
        public var isEnabled: Bool
        public var isChecked: Bool
        public var offTintColor: UIColor?
        public var onTintColor: UIColor?
        public var thumbColor: UIColor
        public var accessibilityIds: AccessibilityIds?
        public var checkAction: (Bool) -> Void
        public var handlePress: (Bool) -> Void
        
        public struct AccessibilityIds {
            public var id: String?
            public var switchViewId: String?
            
            public init(
                id: String? = nil,
                switchViewId: String = DesignSystemAccessibilityIDs.ToggleView.switchView
            ) {
                self.id = id
                self.switchViewId = switchViewId
            }
        }
        
        public init(
            isEnabled: Bool = true,
            isChecked: Bool = false,
            offTintColor: UIColor? = nil,
            onTintColor: UIColor? = nil,
            thumbColor: UIColor = .clear,
            accessibilityIds: AccessibilityIds? = nil,
            checkAction: @escaping (Bool) -> Void = { _ in },
            handlePress: @escaping (Bool) -> Void = { _ in }
        ) {
            self.isEnabled = isEnabled
            self.isChecked = isChecked
            self.offTintColor = offTintColor
            self.onTintColor = onTintColor
            self.thumbColor = thumbColor
            self.accessibilityIds = accessibilityIds
            self.checkAction = checkAction
            self.handlePress = handlePress
        }
    }
    
    // MARK: - Private properties
    
    private var viewProperties: ViewProperties = .init()
    private lazy var switchView = UISwitch()
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Public Methods
    
    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
        
        setupProperties(with: viewProperties)
        setupAccessibilityIds(with: viewProperties)
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        backgroundColor = .clear
        
        addSubview(switchView)
        switchView.addTarget(self, action: #selector(switchTapped), for: .valueChanged)
        switchView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupAccessibilityIds(with viewProperties: ViewProperties) {
        isAccessibilityElement = true
        accessibilityIdentifier = viewProperties.accessibilityIds?.id
        switchView.isAccessibilityElement = true
        switchView.accessibilityIdentifier = viewProperties.accessibilityIds?.switchViewId
    }
    
    private func setupProperties(with viewProperties: ViewProperties) {
        switchView.setOn(viewProperties.isChecked, animated: true)
        switchView.isEnabled = viewProperties.isEnabled
        
        UIView.animate(withDuration: 0.1) {
            if let onTintColor = viewProperties.onTintColor {
                self.switchView.onTintColor = onTintColor
            }
            
            if let offTintColor = viewProperties.offTintColor {
                self.switchView.tintColor = offTintColor
                self.switchView.subviews[0].subviews[0].backgroundColor = offTintColor
            }
            
            self.setupThumbColor(isOn: viewProperties.isChecked)
        }
    }
    
    private func setupThumbColor(isOn: Bool) {
        switchView.thumbTintColor = viewProperties.thumbColor
    }
    
    @objc private func switchTapped(_ sender: UISwitch) {
        viewProperties.handlePress(sender.isOn)
    }
}
