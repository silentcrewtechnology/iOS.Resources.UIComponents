import UIKit
import SnapKit

public final class RadioView: PressableView, ComponentProtocol {
    
    public struct ViewProperties {
        public var backgroundColor: UIColor
        public var size: CGSize
        public var cornerRadius: CGFloat
        public var borderColor: UIColor
        public var borderWidth: CGFloat
        public var checkIcon: UIImage?
        public var isUserInteractionEnabled: Bool
        public var onPressChange: (State) -> Void
        
        public init(
            backgroundColor: UIColor = .clear,
            size: CGSize = .zero,
            cornerRadius: CGFloat = 0,
            borderColor: UIColor = .clear,
            borderWidth: CGFloat = 0,
            checkIcon: UIImage? = nil,
            isUserInteractionEnabled: Bool = true,
            onPressChange: @escaping (State) -> Void = { _ in }
        ) {
            self.backgroundColor = backgroundColor
            self.size = size
            self.cornerRadius = cornerRadius
            self.borderColor = borderColor
            self.borderWidth = borderWidth
            self.checkIcon = checkIcon
            self.isUserInteractionEnabled = isUserInteractionEnabled
            self.onPressChange = onPressChange
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    private let indicatorView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
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
    
    public func update(with viewProperties: ViewProperties) {
        UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve) { [self] in
            isUserInteractionEnabled = viewProperties.isUserInteractionEnabled
            setupBackground(with: viewProperties)
            setupBorder(with: viewProperties)
            setupIndicator(with: viewProperties)
            self.viewProperties = viewProperties
        }
    }
    
    private func setupBackground(with viewProperties: ViewProperties) {
        backgroundColor = viewProperties.backgroundColor
        if self.viewProperties.size != viewProperties.size {
            snp.updateConstraints {
                $0.size.equalTo(viewProperties.size)
            }
        }
        layer.cornerRadius = viewProperties.cornerRadius
    }
    
    private func setupBorder(with viewProperties: ViewProperties) {
        layer.borderColor = viewProperties.borderColor.cgColor
        layer.borderWidth = viewProperties.borderWidth
    }
    
    private func setupIndicator(with viewProperties: ViewProperties) {
        indicatorView.image = viewProperties.checkIcon
    }
    
    public override func handlePress(state: State) {
        viewProperties.onPressChange(state)
    }
}
