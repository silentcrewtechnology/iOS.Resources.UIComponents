import UIKit
import SnapKit

public final class StoryTileCollectionView: UICollectionView, ComponentProtocol {
    
    public struct ViewProperties {
        public var height: CGFloat
        public var flowLayout: UICollectionViewFlowLayout
        
        public init(
            height: CGFloat = 0,
            flowLayout: UICollectionViewFlowLayout = .init()
        ) {
            self.height = height
            self.flowLayout = flowLayout
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    public init() {
        super.init(frame: .zero, collectionViewLayout: .init())
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    public func update(with viewProperties: ViewProperties) {
        snp.updateConstraints { $0.height.equalTo(viewProperties.height) }
        setCollectionViewLayout(viewProperties.flowLayout, animated: false)
        self.viewProperties = viewProperties
        reloadData()
    }
    
    private func setupView() {
        snp.makeConstraints { $0.height.equalTo(0) }
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }
}
