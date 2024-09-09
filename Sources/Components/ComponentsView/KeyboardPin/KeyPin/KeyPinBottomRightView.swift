import UIKit
import SnapKit

public final class KeyPinBottomRightView: PressableView, ComponentProtocol {
    
    public struct ViewProperties {
        public var icon: UIImage
        public var isUserInteractionEnabled: Bool
        public var onPressChange: (State) -> Void
        
        public init(
            icon: UIImage = .init(),
            isUserInteractionEnabled: Bool = true,
            onPressChange: @escaping (State) -> Void = { _ in }
        ) {
            self.icon = icon
            self.isUserInteractionEnabled = isUserInteractionEnabled
            self.onPressChange = onPressChange
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
    }
    
    public override func handlePress(state: State) {
        viewProperties.onPressChange(state)
    }
}
