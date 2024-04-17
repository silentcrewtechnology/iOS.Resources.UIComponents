import UIKit
import SnapKit

public final class RowBaseContainer: UIView {
    
    public struct ViewProperties {
        
        public var leadingView: UIView?
        public var centerView: UIView?
        public var trailingView: UIView?
        public var viewsHeight: CGFloat
        public var margins: Margins
        
        public struct Margins {
            public var leading: CGFloat
            public var trailing: CGFloat
            public var top: CGFloat
            public var bottom: CGFloat
            public var spacing: CGFloat
            
            public init(
                leading: CGFloat = 0,
                trailing: CGFloat = 0,
                top: CGFloat = 0,
                bottom: CGFloat = 0,
                spacing: CGFloat = 0
            ) {
                self.leading = leading
                self.trailing = trailing
                self.top = top
                self.bottom = bottom
                self.spacing = spacing
            }
        }
        
        public init(
            leadingView: UIView? = nil,
            centerView: UIView? = nil,
            trailingView: UIView? = nil,
            viewsHeight: CGFloat = 0,
            margins: Margins = .init()
        ) {
            self.leadingView = leadingView
            self.centerView = centerView
            self.trailingView = trailingView
            self.viewsHeight = viewsHeight
            self.margins = margins
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private var viewProperties: ViewProperties = .init()
    
    private let leadingContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private let centralContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private let trailingContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    public func update(with viewProperties: ViewProperties) {
        removeSubviewsFromContainers()
        addViewsInContainers(with: viewProperties)
        remakeContainersConstraints(with: viewProperties)
    }
    
    private func removeSubviewsFromContainers() {
        leadingContainer.subviews.forEach { $0.removeFromSuperview() }
        centralContainer.subviews.forEach { $0.removeFromSuperview() }
        trailingContainer.subviews.forEach { $0.removeFromSuperview() }
    }
    
    private func addViewsInContainers(with viewProperties: ViewProperties) {
        if let leadingView = viewProperties.leadingView {
            leadingContainer.addSubview(leadingView)
            leadingView.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
        
        if let centerView = viewProperties.centerView {
            centralContainer.addSubview(centerView)
            centerView.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
        
        if let trailingView = viewProperties.trailingView {
            trailingContainer.addSubview(trailingView)
            trailingView.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
    }
    
    private func remakeContainersConstraints(with viewProperties: ViewProperties) {
        leadingContainer.snp.remakeConstraints {
            $0.leading.equalToSuperview().offset(viewProperties.margins.leading)
            $0.top.equalToSuperview().offset(viewProperties.margins.top)
            $0.bottom.equalToSuperview().offset(-viewProperties.margins.bottom)
            $0.height.equalTo(viewProperties.viewsHeight)
            $0.width.equalTo(viewProperties.leadingView?.snp.width ?? 0).priority(.high)
        }
        
        centralContainer.snp.remakeConstraints {
            $0.top.equalToSuperview().offset(viewProperties.margins.top)
            $0.bottom.equalToSuperview().offset(-viewProperties.margins.bottom)
            $0.leading.equalTo(leadingContainer.snp.trailing).offset(viewProperties.margins.spacing)
            $0.width.equalTo(viewProperties.centerView?.snp.width ?? 0).priority(.high)
        }
        
        trailingContainer.snp.remakeConstraints {
            $0.trailing.equalToSuperview().offset(-viewProperties.margins.trailing)
            $0.top.equalToSuperview().offset(viewProperties.margins.top)
            $0.bottom.equalToSuperview().offset(-viewProperties.margins.bottom)
            $0.width.equalTo(viewProperties.trailingView?.snp.width ?? 0).priority(.high)
            $0.leading.greaterThanOrEqualTo(centralContainer.snp.trailing).offset(viewProperties.margins.spacing)
        }
    }
    
    private func setupView() {
        addSubview(leadingContainer)
        leadingContainer.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
        }
        
        addSubview(centralContainer)
        centralContainer.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(leadingContainer.snp.trailing)
        }
        
        addSubview(trailingContainer)
        trailingContainer.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.greaterThanOrEqualTo(centralContainer.snp.trailing)
        }
    }
}
