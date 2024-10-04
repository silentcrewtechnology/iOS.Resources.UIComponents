import UIKit
import SnapKit

@available(*, deprecated, message: "Use LoaderView instead")
public class ActivityIndicatorView: UIView, ComponentProtocol {
    
    public struct ViewProperties {
        public var icon: UIImage
        public var size: CGSize
        public var isAnimating: Bool
        public let accessibilityId: String?
        
        public init(
            icon: UIImage = .init(),
            size: CGSize = .zero,
            isAnimating: Bool = false,
            accessibilityId: String? = nil
        ) {
            self.icon = icon
            self.size = size
            self.isAnimating = isAnimating
            self.accessibilityId = accessibilityId
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    private var indicatorView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
        removeConstraintsAndSubviews()
        setupView()
        indicatorView.image = viewProperties.icon
        updateAnimating(with: viewProperties)
        accessibilityIdentifier = viewProperties.accessibilityId
    }
    
    private func setupView() {
        isHidden = true
        addSubview(indicatorView)
        indicatorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        snp.makeConstraints {
            $0.size.equalTo(viewProperties.size)
        }
    }
    
    private func removeConstraintsAndSubviews() {
        self.subviews.forEach { subview in
            subview.snp.removeConstraints()
            subview.removeFromSuperview()
        }
    }
    
    private func updateAnimating(with viewProperties: ViewProperties) {
        if viewProperties.isAnimating {
            startAnimating()
        } else {
            stopAnimating()
        }
    }
    
    private func startAnimating() {
        let animation = rotateAnimation()
        indicatorView.layer.add(animation, forKey: Constants.kRotationAnimationKey)
        isHidden = false
    }
    
    private func rotateAnimation() -> CAAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = .pi * 2.0 // поворот на 360 градусов
        animation.duration = 1 // за 1 секунду
        animation.isCumulative = true
        animation.repeatCount = .greatestFiniteMagnitude
        return animation
    }
    
    private func stopAnimating() {
        indicatorView.layer.removeAnimation(forKey: Constants.kRotationAnimationKey)
        isHidden = true
    }
}

private enum Constants {
    static let kRotationAnimationKey = "activity.RotationAnimation"
}
