import UIKit
import SnapKit

public final class RadioView: UIView {
    
    public struct ViewProperties {
        public var background: Background
        public var onIndicator: Indicator
        public var offIndicator: Indicator
        
        public init(
            background: Background = .init(),
            onIndicator: Indicator = .init(),
            offIndicator: Indicator = .init()
        ) {
            self.background = background
            self.onIndicator = onIndicator
            self.offIndicator = offIndicator
        }
        
        public struct Background {
            public var color: UIColor
            public var size: CGFloat
            
            public init(
                color: UIColor = .clear,
                size: CGFloat = .zero
            ) {
                self.color = color
                self.size = size
            }
        }
        
        public struct Indicator {
            public var color: UIColor
            public var size: CGFloat
            
            public init(
                color: UIColor = .clear,
                size: CGFloat = .zero
            ) {
                self.color = color
                self.size = size
            }
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    private let onIndicatorView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let offIndicatorView: UIView = {
        let view = UIView()
        return view
    }()
    
    private func setupView() {
        snp.makeConstraints {
            $0.size.equalTo(0) // будет обновляться
        }
        addSubview(onIndicatorView)
        onIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(0) // будет обновляться
        }
        addSubview(offIndicatorView)
        offIndicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(0) // будет обновляться
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable) required init?(coder: NSCoder) { fatalError() }
    
    public func update(viewProperties: ViewProperties) {
        setupBackground(background: viewProperties.background)
        setupOnIndicator(indicator: viewProperties.onIndicator)
        setupOffIndicator(indicator: viewProperties.offIndicator)
        self.viewProperties = viewProperties
    }
    
    private func setupBackground(background: ViewProperties.Background) {
        backgroundColor = background.color
        if self.viewProperties.background.size != background.size {
            layer.cornerRadius = background.size / 2
            snp.updateConstraints {
                $0.size.equalTo(background.size)
            }
        }
    }
    
    private func setupOnIndicator(indicator: ViewProperties.Indicator) {
        onIndicatorView.backgroundColor = indicator.color
        if self.viewProperties.onIndicator.size != indicator.size {
            onIndicatorView.layer.cornerRadius = indicator.size / 2
            onIndicatorView.snp.updateConstraints {
                $0.size.equalTo(indicator.size)
            }
        }
    }
    
    private func setupOffIndicator(indicator: ViewProperties.Indicator) {
        offIndicatorView.backgroundColor = indicator.color
        if self.viewProperties.offIndicator.size != indicator.size {
            offIndicatorView.layer.cornerRadius = indicator.size / 2
            offIndicatorView.snp.updateConstraints {
                $0.size.equalTo(indicator.size)
            }
        }
    }
}
