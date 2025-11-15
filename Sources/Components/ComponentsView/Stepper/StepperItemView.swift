import UIKit
import SnapKit

public final class StepperItemView: UIView, ComponentProtocol {
    
    // MARK: - Properties
    
    public struct ViewProperties {
        public var backgroundColor: UIColor
        public var progressViewWidth: CGFloat
        public var progressViewBackgroundColor: UIColor
        public var cornerRadius: CGFloat
        public var height: CGFloat
        public var progressViewInsets: UIEdgeInsets
        public var shouldStretchProgressView: Bool
        
        public init(
            backgroundColor: UIColor = .clear,
            progressViewBackgroundColor: UIColor = .clear,
            progressViewWidth: CGFloat = .zero,
            cornerRadius: CGFloat = .zero,
            height: CGFloat = .zero,
            progressViewInsets: UIEdgeInsets = .zero,
            shouldStretchProgressView: Bool = false
        ) {
            self.backgroundColor = backgroundColor
            self.progressViewBackgroundColor = progressViewBackgroundColor
            self.progressViewWidth = progressViewWidth
            self.cornerRadius = cornerRadius
            self.height = height
            self.progressViewInsets = progressViewInsets
            self.shouldStretchProgressView = shouldStretchProgressView
        }
    }
    
    // MARK: - Private properties
    
    private var viewProperties: ViewProperties = .init()
    
    private lazy var progressView = UIView()
    
    // MARK: - Life cyle
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Methods
    
    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
        
        removeConstraintsAndSubviews()
        updateCornerRadius(with: viewProperties)
        updateConstraints(with: viewProperties)
        UIView.animate(withDuration: 0.4) {
            self.backgroundColor = viewProperties.backgroundColor
            self.setupProgressView(with: viewProperties)
            self.layoutIfNeeded()
        }
    }
    
    // MARK: - Private methods
    
    private func updateCornerRadius(with viewProperties: ViewProperties) {
        layer.cornerRadius = viewProperties.cornerRadius
       
    }
    
    private func updateConstraints(with viewProperties: ViewProperties) {
        snp.updateConstraints {
            $0.height.equalTo(viewProperties.height)
        }
    }
    
    private func setupProgressView(with viewProperties: ViewProperties) {
        addSubview(progressView)
        progressView.layer.cornerRadius = viewProperties.cornerRadius
        progressView.backgroundColor = viewProperties.progressViewBackgroundColor
        progressView.snp.makeConstraints {
            $0.bottom.top.left.equalToSuperview().inset(viewProperties.progressViewInsets)
            
            if viewProperties.shouldStretchProgressView {
                $0.width.equalToSuperview()
            } else {
                $0.width.equalTo(viewProperties.progressViewWidth)
            }
        }
    }
    
    private func setupView() {
        snp.makeConstraints {
            $0.height.equalTo(0) // Будет обновляться
        }
    }
    
    private func removeConstraintsAndSubviews() {
        for subview in subviews {
            subview.snp.removeConstraints()
            subview.removeFromSuperview()
        }
    }
}
