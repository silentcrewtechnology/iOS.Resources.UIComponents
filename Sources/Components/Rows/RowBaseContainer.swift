import UIKit
import SnapKit
import AccessibilityIds

public final class RowBaseContainer: UIView {
    
    public struct ViewProperties {
        
        public var leadingView: UIView?
        public var centerView: UIView?
        public var trailingView: UIView?
        public var centralBlockAlignment: BlockAlignment
        public var verticalAlignment: VerticalAlignment
        public var margins: Margins
        public var accessibilityIds: AccessibilityIds?
        
        public struct AccessibilityIds {
            var id: String?
            
            public init(
                id: String? = nil
            ) {
                self.id = id
            }
        }
        
        public enum BlockAlignment {
            case leading
            case center
            case trailing
            case fill
        }
        
        public enum VerticalAlignment {
            case top
            case center
            case bottom
            case fill
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
            verticalAlignment: VerticalAlignment = .center,
            margins: Margins = .init(),
            accessibilityIds: AccessibilityIds? = nil
        ) {
            self.leadingView = leadingView
            self.centerView = centerView
            self.trailingView = trailingView
            self.centralBlockAlignment = centralBlockAlignment
            self.verticalAlignment = verticalAlignment
            self.margins = margins
            self.accessibilityIds = accessibilityIds
        }
    }
    
    private var hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        return stack
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private var viewProperties: ViewProperties = .init()
    
    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
        setupHStack(with: viewProperties)
        setupBlocks(with: viewProperties)
        setupAccessibilityIds(with: viewProperties)
    }
    
    private func setupAccessibilityIds(with viewProperties: ViewProperties) {
        isAccessibilityElement = true
        accessibilityIdentifier = viewProperties.accessibilityIds?.id
    }
    
    private func setupHStack(with viewProperties: ViewProperties) {
        subviews.forEach { $0.removeFromSuperview() }
        hStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        addSubview(hStack)
        hStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(
                top: viewProperties.margins.top,
                left: viewProperties.margins.leading,
                bottom: viewProperties.margins.bottom,
                right: viewProperties.margins.trailing
            ))
        }
        hStack.spacing = viewProperties.margins.spacing
        hStack.alignment = {
            switch viewProperties.verticalAlignment {
            case .top: .top
            case .center: .center
            case .bottom: .bottom
            case .fill: .fill
            }
        }()
    }
    
    private func setupBlocks(with viewProperties: ViewProperties) {
        if let leadingView = viewProperties.leadingView {
            hStack.addArrangedSubview(leadingView)
        }
        
        setupCenterBlock(with: viewProperties)
        
        if let trailingView = viewProperties.trailingView {
            hStack.addArrangedSubview(trailingView)
        }
    }
    
    private func setupCenterBlock(with viewProperties: RowBaseContainer.ViewProperties) {
        guard let centerView = viewProperties.centerView else {
            return hStack.addArrangedSubview(makeGrowingHSpacer())
        }
        
        var (leadingCenterSpacer, trailingCenterSpacer): (UIView?, UIView?)
        
        if [.center, .trailing].contains(viewProperties.centralBlockAlignment) {
            let spacer = makeGrowingHSpacer()
            hStack.addArrangedSubview(spacer)
            leadingCenterSpacer = spacer
        }
        
        hStack.addArrangedSubview(centerView)
        
        if [.leading, .center].contains(viewProperties.centralBlockAlignment) {
            let spacer = makeGrowingHSpacer()
            hStack.addArrangedSubview(spacer)
            trailingCenterSpacer = spacer
        }
        
        if let leadingCenterSpacer, let trailingCenterSpacer {
            leadingCenterSpacer.snp.makeConstraints {
                $0.width.equalTo(trailingCenterSpacer)
            }
        }
    }
    
    private func makeGrowingHSpacer() -> UIView {
        let view = UIView()
        view.snp.makeConstraints { $0.width.equalTo(CGFloat.greatestFiniteMagnitude).priority(.low)
        }
        return view
    }
}
