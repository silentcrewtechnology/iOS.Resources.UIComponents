import UIKit
import SnapKit

public final class KeyPinBottomRightView: PressableView, ComponentProtocol {
    
    public struct ViewProperties {
        public var icon: UIImage
        public var isUserInteractionEnabled: Bool
        public var onPressChange: (State) -> Void
        public var accessibilityIds: AccessibilityIds?
        
        public struct AccessibilityIds {
            public var id: String
            public var imageViewId: String
            
            public init(
                id: String,
                imageViewId: String
            ) {
                self.id = id
                self.imageViewId = imageViewId
            }
        }
        
        public init(
            icon: UIImage = .init(),
            isUserInteractionEnabled: Bool = true,
            onPressChange: @escaping (State) -> Void = { _ in },
            accessibilityIds: AccessibilityIds? = nil
        ) {
            self.icon = icon
            self.isUserInteractionEnabled = isUserInteractionEnabled
            self.onPressChange = onPressChange
            self.accessibilityIds = accessibilityIds
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        return view
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupView() {
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    public func update(with viewProperties: ViewProperties) {
        imageView.image = viewProperties.icon
        isUserInteractionEnabled = viewProperties.isUserInteractionEnabled
        self.viewProperties = viewProperties
        setupAccessibilityIds(with: viewProperties)
    }
    
    public override func handlePress(state: State) {
        viewProperties.onPressChange(state)
    }
    
    private func setupAccessibilityIds(with viewProperties: ViewProperties) {
        isAccessibilityElement = true
        accessibilityIdentifier = viewProperties.accessibilityIds?.id
        imageView.accessibilityIdentifier = viewProperties.accessibilityIds?.imageViewId
    }
}
