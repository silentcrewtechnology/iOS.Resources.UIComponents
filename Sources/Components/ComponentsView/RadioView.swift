import UIKit
import SnapKit

public final class RadioView: PressableView, ComponentProtocol {
    
    // MARK: - ViewProperties
    
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
    
    // MARK: - UI
    
    private let indicatorView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    // MARK: - init
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) { fatalError() }

    public func update(with viewProperties: ViewProperties) {
        UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve) { [self] in
            self.viewProperties = viewProperties
            isUserInteractionEnabled = viewProperties.isUserInteractionEnabled
            updateBackground(with: viewProperties)
            setCornerRadius(with: viewProperties)
            updateBorder(with: viewProperties)
            updateIndicator(with: viewProperties)
            updateConstraints(with: viewProperties)
        }
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
    
    private func updateBorder(with viewProperties: ViewProperties) {
        layer.borderColor = viewProperties.borderColor.cgColor
        layer.borderWidth = viewProperties.borderWidth
    }
    
    private func updateIndicator(with viewProperties: ViewProperties) {
        indicatorView.image = viewProperties.checkIcon
    }
    
    public override func handlePress(state: State) {
        viewProperties.onPressChange(state)
    }
    
    private func updateConstraints(with viewProperties: ViewProperties) {
        removeConstraintsAndSubviews()
        if viewProperties.checkIcon != nil {
            setupSimpleView()
            setupIndicatorView()
        } else {
            setupSimpleView()
        }
    }
    
    private func setupSimpleView() {
        let view = UIView()
        view.backgroundColor = .clear
        addSubview(view)
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(viewProperties.size.height)
            $0.width.equalTo(viewProperties.size.width)
        }
    }
    
    private func setupIndicatorView() {
        addSubview(indicatorView)
        indicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func removeConstraintsAndSubviews() {
        self.subviews.forEach { subview in
            subview.snp.removeConstraints()
            subview.removeFromSuperview()
        }
    }
}
