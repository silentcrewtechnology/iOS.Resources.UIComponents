import UIKit
import SnapKit

public class ActivityIndicatorView: UIView {
    
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
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupView() {
        isHidden = true
        addSubview(indicatorView)
        indicatorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        snp.makeConstraints {
            $0.size.equalTo(0) // будет обновлено
        }
    }
    
    public func update(with viewProperties: ViewProperties) {
        indicatorView.image = viewProperties.icon
        updateSize(with: viewProperties)
        updateAnimating(with: viewProperties)
        accessibilityIdentifier = viewProperties.accessibilityId
        self.viewProperties = viewProperties
    }
    
    private func updateSize(with viewProperties: ViewProperties) {
        guard self.viewProperties.size != viewProperties.size else { return }
        snp.updateConstraints {
            $0.size.equalTo(viewProperties.size)
        }
    }
    
    private func updateAnimating(with viewProperties: ViewProperties) {
        guard self.viewProperties.isAnimating != viewProperties.isAnimating else { return }
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
