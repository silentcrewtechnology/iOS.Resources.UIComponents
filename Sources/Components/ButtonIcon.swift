import UIKit
import SnapKit

public class ButtonIcon: UIButton {
    
    public struct ViewProperties {
        public var isEnabled: Bool
        public var size: CGFloat
        public var cornerRadius: CGFloat
        public var backgroundColor: UIColor
        public var image: UIImage
        public var isLoading: Bool
        public var activityIndicator: ActivityIndicatorView.ViewProperties
        public var onHighlighted: (Bool) -> Void
        public var onTap: () -> Void
        
        public init(
            isEnabled: Bool = true,
            size: CGFloat = .zero,
            cornerRadius: CGFloat = .zero,
            backgroundColor: UIColor = .clear,
            icon: Icon = .image(.init()),
            image: UIImage = .init(),
            isLoading: Bool = false,
            activityIndicator: ActivityIndicatorView.ViewProperties = .init(),
            onHighlighted: @escaping (Bool) -> Void = { _ in },
            onTap: @escaping () -> Void = { }
        ) {
            self.isEnabled = isEnabled
            self.size = size
            self.cornerRadius = cornerRadius
            self.backgroundColor = backgroundColor
            self.image = image
            self.isLoading = isLoading
            self.activityIndicator = activityIndicator
            self.onHighlighted = onHighlighted
            self.onTap = onTap
        }
        
        public enum Icon {
            case image(UIImage)
            case loader
        }
    }
    
    public override var isHighlighted: Bool {
        didSet {
            viewProperties.onHighlighted(isHighlighted)
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    private let activityIndicator = ActivityIndicatorView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupView() {
        contentMode = .center
        imageView?.contentMode = .center
        layer.masksToBounds = true
        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        snp.makeConstraints {
            $0.size.equalTo(0) // будет изменён
        }
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    public func update(with viewProperties: ViewProperties) {
        updateSize(with: viewProperties)
        layer.cornerRadius = viewProperties.cornerRadius
        isEnabled = viewProperties.isEnabled
        backgroundColor = viewProperties.backgroundColor
        updateIcon(with: viewProperties)
        updateIndicator(indicator: viewProperties.activityIndicator)
        self.viewProperties = viewProperties
    }
    
    private func updateSize(with viewProperties: ViewProperties) {
        guard self.viewProperties.size != viewProperties.size else { return }
        snp.updateConstraints {
            $0.size.equalTo(viewProperties.size)
        }
    }
    
    private func updateIcon(with viewProperties: ViewProperties) {
        if viewProperties.isLoading {
            updateButtonImage(image: nil)
        } else {
            updateButtonImage(image: viewProperties.image)
        }
    }
    
    private func updateButtonImage(image: UIImage?) {
        setImage(image, for: .normal)
        setImage(image, for: .highlighted)
        setImage(image, for: .disabled)
    }
    
    @objc private func buttonTapped() {
        viewProperties.onTap()
    }
    
    private func updateIndicator(indicator: ActivityIndicatorView.ViewProperties) {
        imageView?.isHidden = indicator.isAnimating
        activityIndicator.update(with: indicator)
    }
}
