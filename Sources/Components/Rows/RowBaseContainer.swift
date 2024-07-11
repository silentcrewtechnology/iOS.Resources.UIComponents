import UIKit
import SnapKit

public final class RowBaseContainer: UIView {
    
    public struct ViewProperties {
        
        public var leadingView: UIView?
        public var centerView: UIView?
        public var trailingView: UIView?
        public var centralBlockAlignment: BlockAlignment
        public var margins: Margins
        
        public enum BlockAlignment {
            case leading
            case trailing
        }
        
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
            centralBlockAlignment: BlockAlignment = .leading,
            margins: Margins = .init()
        ) {
            self.leadingView = leadingView
            self.centerView = centerView
            self.trailingView = trailingView
            self.centralBlockAlignment = centralBlockAlignment
            self.margins = margins
        }
    }
    
    public var leadingView = UIView()
    public var centerView = UIView()
    public var trailingView = UIView()
    
    private var isLeadingViewNil: Bool = false
    private var isCenterViewNil: Bool = false
    private var isTrailingViewNil: Bool = false
    
    private var leadingOffsetOfCenterView: CGFloat = 0
    private var leadingOffsetOfTrailingView: CGFloat = 0
    
    public init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private var viewProperties: ViewProperties = .init()
    
    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
        removeSubviewsFromContainers()
        emptyViewDetection()
        emptyConstraintsDetection()
        setConstraints()
        
    }
    
    private func removeSubviewsFromContainers() {
        leadingView.removeFromSuperview()
        centerView.removeFromSuperview()
        trailingView.removeFromSuperview()
    }
    
    private func emptyViewDetection() {
        isLeadingViewNil = viewProperties.leadingView == nil
        isCenterViewNil = viewProperties.centerView == nil
        isTrailingViewNil = viewProperties.trailingView == nil
        
        leadingView = viewProperties.leadingView ?? .init()
        centerView = viewProperties.centerView ?? .init()
        trailingView = viewProperties.trailingView ?? .init()
    }
    
    private func emptyConstraintsDetection() {
        leadingOffsetOfCenterView = viewProperties.margins.spacing
        leadingOffsetOfTrailingView = viewProperties.margins.spacing
        
        if isLeadingViewNil || isCenterViewNil {
            leadingOffsetOfCenterView = 0
        }
        
        if isLeadingViewNil && isCenterViewNil || isCenterViewNil && isTrailingViewNil {
            leadingOffsetOfCenterView = 0
            leadingOffsetOfTrailingView = 0
        }
        
        if isTrailingViewNil {
            leadingOffsetOfTrailingView = 0
        }
    }
    
    private func setConstraints() {
        addSubview(leadingView)
        leadingView.snp.makeConstraints {
            $0.top.greaterThanOrEqualToSuperview().offset(viewProperties.margins.top)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(viewProperties.margins.leading)
            $0.bottom.lessThanOrEqualToSuperview().offset(-viewProperties.margins.bottom)
            if isLeadingViewNil {
                $0.height.width.equalTo(0)
            }
        }
        
        addSubview(centerView)
        centerView.snp.makeConstraints {
            switch viewProperties.centralBlockAlignment {
            case .leading:
                $0.leading.equalTo(leadingView.snp.trailing).offset(leadingOffsetOfCenterView)
            case .trailing:
                $0.leading.greaterThanOrEqualTo(leadingView.snp.trailing).offset(leadingOffsetOfCenterView)
            }
            $0.top.greaterThanOrEqualToSuperview().offset(viewProperties.margins.top)
            $0.centerY.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview().offset(-viewProperties.margins.bottom)
            if isCenterViewNil {
                $0.height.width.equalTo(0)
            }
        }
        
        addSubview(trailingView)
        trailingView.snp.makeConstraints {
            switch viewProperties.centralBlockAlignment {
            case .leading:
                $0.leading.greaterThanOrEqualTo(centerView.snp.trailing).offset(leadingOffsetOfTrailingView)
            case .trailing:
                $0.leading.equalTo(centerView.snp.trailing).offset(leadingOffsetOfTrailingView)
            }
            $0.top.greaterThanOrEqualToSuperview().offset(viewProperties.margins.top)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-viewProperties.margins.trailing)
            $0.bottom.lessThanOrEqualToSuperview().offset(-viewProperties.margins.bottom)
            if isTrailingViewNil {
                $0.height.width.equalTo(0)
            }
        }
    }
}
