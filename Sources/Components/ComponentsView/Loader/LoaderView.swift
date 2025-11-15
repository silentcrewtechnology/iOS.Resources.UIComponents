import UIKit
import SnapKit

public final class LoaderView: UIView, ComponentProtocol {
    
    // MARK: - ViewProperties
    
    public struct ViewProperties {
        public var size: CGSize
        public var isHidden: Bool
        public var animationLayer: LoaderAnimationLayer
        
        public init(
            size: CGSize = .zero,
            isHidden: Bool = true,
            animationLayer: LoaderAnimationLayer = .init()
        ) {
            self.size = size
            self.isHidden = isHidden
            self.animationLayer = animationLayer
        }
    }
    
    // MARK: - Private properties
    
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Methods
    
    public func update(with viewProperties: ViewProperties) {
        updateSize(size: viewProperties.size)
        isHidden = viewProperties.isHidden
        updateCircleLayer(circleLayer: viewProperties.animationLayer)
        self.viewProperties = viewProperties
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        snp.makeConstraints {
            $0.size.equalTo(CGSize.zero) // будет обновляться
        }
    }
    
    private func updateSize(size: CGSize) {
        guard self.viewProperties.size != size else { return }
        snp.updateConstraints { $0.size.equalTo(size) }
    }
    
    private func updateCircleLayer(circleLayer: LoaderAnimationLayer) {
        guard circleLayer.superlayer != layer else { return }
        layer.addSublayer(circleLayer)
    }
}
