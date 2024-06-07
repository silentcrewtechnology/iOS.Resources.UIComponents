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
    
    public var leadingView: UIView?
    public var centerView: UIView?
    public var trailingView: UIView?
    
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
        self.leadingView = viewProperties.leadingView
        self.centerView = viewProperties.centerView
        self.trailingView = viewProperties.trailingView
        emptyViewDetection()
        emptyConstraintsDetection()
        setConstraints()
    }
    
    private func removeSubviewsFromContainers() {
        leadingView?.removeFromSuperview()
        centerView?.removeFromSuperview()
        trailingView?.removeFromSuperview()
    }
    
    private func emptyViewDetection() {
        checkAndInitializeView(&leadingView, flag: &isLeadingViewNil)
        checkAndInitializeView(&centerView, flag: &isCenterViewNil)
        checkAndInitializeView(&trailingView, flag: &isTrailingViewNil)
    }
    
    private func checkAndInitializeView(_ view: inout UIView?, flag: inout Bool) {
        if view == nil {
            view = UIView()
            flag = true
        }
    }
    
    private func emptyConstraintsDetection() {
        leadingOffsetOfCenterView = viewProperties.margins.spacing
        leadingOffsetOfTrailingView = viewProperties.margins.spacing
        
        if isLeadingViewNil || isCenterViewNil {
            leadingOffsetOfCenterView = 0
        }
        
        if isTrailingViewNil {
            leadingOffsetOfTrailingView = 0
        }
    }
    
    private func setConstraints() {
        guard let leadingView = leadingView else { return }
        
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
        
        switch viewProperties.centralBlockAlignment {
        case .leading:
            setCentralLeadingConstraints()
        case .trailing:
            setCentralTrailingConstraints()
        }
    }
    
    private func setCentralLeadingConstraints() {
        guard let leadingView = leadingView,
              let centerView = centerView,
              let trailingView = trailingView else { return }
        
        addSubview(centerView)
        centerView.snp.makeConstraints {
            $0.top.greaterThanOrEqualToSuperview().offset(viewProperties.margins.top)
            $0.centerY.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview().offset(-viewProperties.margins.bottom)
            $0.leading.equalTo(leadingView.snp.trailing).offset(leadingOffsetOfCenterView)
            if isCenterViewNil {
                $0.height.width.equalTo(0)
            }
        }
        
        addSubview(trailingView)
        trailingView.snp.makeConstraints {
            $0.leading.greaterThanOrEqualTo(centerView.snp.trailing).offset(leadingOffsetOfTrailingView)
            $0.top.greaterThanOrEqualToSuperview().offset(viewProperties.margins.top)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-viewProperties.margins.trailing)
            $0.bottom.lessThanOrEqualToSuperview().offset(-viewProperties.margins.bottom)
            if isTrailingViewNil {
                $0.height.width.equalTo(0)
            }
        }
    }
    
    private func setCentralTrailingConstraints() {
        guard let leadingView = leadingView,
              let centerView = centerView,
              let trailingView = trailingView else { return }
        
        addSubview(centerView)
        centerView.snp.makeConstraints {
            $0.top.greaterThanOrEqualToSuperview().offset(viewProperties.margins.top)
            $0.centerY.equalToSuperview()
            $0.leading.greaterThanOrEqualTo(leadingView.snp.trailing).offset(leadingOffsetOfCenterView)
            $0.bottom.lessThanOrEqualToSuperview().offset(-viewProperties.margins.bottom)
            if isCenterViewNil {
                $0.height.width.equalTo(0)
            }
        }
        
        addSubview(trailingView)
        trailingView.snp.makeConstraints {
            $0.leading.equalTo(centerView.snp.trailing).offset(leadingOffsetOfTrailingView)
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
