import UIKit
import SnapKit

public class SpacerView: UIView, ComponentProtocol {
    
    public struct ViewProperties {
        public var size: CGSize
        
        public init(
            size: CGSize = .zero
        ) {
            self.size = size
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupView() {
        snp.makeConstraints {
            $0.size.equalTo(0) // будет обновляться
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    public func update(with viewProperties: ViewProperties) {
        updateSize(size: viewProperties.size)
        self.viewProperties = viewProperties
    }
    
    private func updateSize(size: CGSize) {
        guard self.viewProperties.size != size else { return }
        snp.updateConstraints {
            $0.size.equalTo(size)
        }
    }
}

