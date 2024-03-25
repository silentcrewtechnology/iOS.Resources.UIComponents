import UIKit
import SnapKit

public final class CheckboxView: UIView {
    
    public struct ViewProperties {
        public var background: Background
        public var indicator: CheckboxIndicator
        
        public init(
            background: Background = .init(),
            indicator: CheckboxIndicator = .init()
        ) {
            self.background = background
            self.indicator = indicator
        }
        
        public struct Background {
            public var color: UIColor
            public var size: CGFloat
            public var cornerRadius: CGFloat
            
            public init(
                color: UIColor = .clear,
                size: CGFloat = .zero,
                cornerRadius: CGFloat = .zero
            ) {
                self.color = color
                self.size = size
                self.cornerRadius = cornerRadius
            }
        }
        
        public struct CheckboxIndicator {
            public var backgroundColor: UIColor
            public var size: CGFloat
            public var cornerRadius: CGFloat
            public var image: UIImage?
            
            public init(
                backgroundColor: UIColor = .clear,
                size: CGFloat = .zero,
                cornerRadius: CGFloat = .zero,
                image: UIImage? = nil
            ) {
                self.backgroundColor = backgroundColor
                self.size = size
                self.cornerRadius = cornerRadius
                self.image = image
            }
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    private let checkView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
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
        addSubview(checkView)
        checkView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(0) // будет обновляться
        }
    }
    
    public func update(with viewProperties: ViewProperties) {
        setupBackground(background: viewProperties.background)
        setupIndicator(indicator: viewProperties.indicator)
        self.viewProperties = viewProperties
    }
    
    private func setupBackground(background: ViewProperties.Background) {
        backgroundColor = background.color
        if self.viewProperties.background.size != background.size {
            snp.updateConstraints {
                $0.size.equalTo(background.size)
            }
        }
        layer.cornerRadius = background.cornerRadius
    }
    
    private func setupIndicator(indicator: ViewProperties.CheckboxIndicator) {
        checkView.layer.cornerRadius = indicator.cornerRadius
        checkView.image = indicator.image
        checkView.backgroundColor = indicator.backgroundColor
        if self.viewProperties.indicator.size != indicator.size {
            checkView.snp.updateConstraints {
                $0.size.equalTo(indicator.size)
            }
        }
    }
}
