import UIKit
import SnapKit

public final class StepperItemView: UIView {
    
    public struct ViewProperties {
        public var backgroundColor: UIColor
        public var progressViewWidth: CGFloat
        public var progressViewBackgroundColor: UIColor
        public var cornerRadius: CGFloat
        public var height: CGFloat
        
        public init(
            backgroundColor: UIColor = .clear,
            progressViewBackgroundColor: UIColor = .clear,
            progressViewWidth: CGFloat = 0,
            cornerRadius: CGFloat = 0,
            height: CGFloat = 0
        ) {
            self.backgroundColor = backgroundColor
            self.progressViewBackgroundColor = progressViewBackgroundColor
            self.progressViewWidth = progressViewWidth
            self.cornerRadius = cornerRadius
            self.height = height
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    private let progressView: UIView = {
        let view = UIView()
        return view
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    public func update(with viewProperties: ViewProperties) {
        backgroundColor = viewProperties.backgroundColor
        progressView.backgroundColor = viewProperties.progressViewBackgroundColor
        updateCornerRadius(with: viewProperties)
        updateAllConstraints(with: viewProperties)
        self.viewProperties = viewProperties
    }
    
    private func updateCornerRadius(with viewProperties: ViewProperties) {
        layer.cornerRadius = viewProperties.cornerRadius
        progressView.layer.cornerRadius = viewProperties.cornerRadius
    }
    
    private func updateAllConstraints(with viewProperties: ViewProperties) {
        snp.updateConstraints {
            $0.height.equalTo(viewProperties.height)
        }
        
        progressView.snp.updateConstraints {
            $0.width.equalTo(viewProperties.progressViewWidth)
        }
    }
    
    private func setupView() {
        
        addSubview(progressView)
        progressView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(viewProperties.progressViewWidth) // будет обновляться
        }
        
        snp.makeConstraints {
            $0.height.equalTo(viewProperties.height) // будет обновляться
        }
    }
}
