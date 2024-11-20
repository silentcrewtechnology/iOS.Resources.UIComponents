import UIKit
import SnapKit
import AccessibilityIds

public final class SegmentControlView: UIView, ComponentProtocol {
    
    // MARK: - Properties
    
    public struct ViewProperties {
        public var backgroundColor: UIColor
        public var itemViews: [UIView]
        public var cornerRadius: CGFloat
        public var margins: Margins
        public let accessibilityId: String?
        
        public struct Margins {
            public var insets: UIEdgeInsets
            public var height: CGFloat
            public var stackSpacing: CGFloat
            
            public init(
                insets: UIEdgeInsets = .zero,
                height: CGFloat = .zero,
                stackSpacing: CGFloat = .zero
            ) {
                self.insets = insets
                self.height = height
                self.stackSpacing = stackSpacing
            }
        }
        
        public init(
            backgroundColor: UIColor = .clear,
            itemViews: [UIView] = [],
            cornerRadius: CGFloat = .zero,
            margins: Margins = .init(),
            accessibilityId: String? = nil
        ) {
            self.backgroundColor = backgroundColor
            self.itemViews = itemViews
            self.cornerRadius = cornerRadius
            self.margins = margins
            self.accessibilityId = accessibilityId
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - UI
    
    private lazy var segmentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        
        return stack
    }()
    
    private lazy var containerView = UIView()

    // MARK: - Update
    
    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
        
        setupView(with: viewProperties)
        setupSegmentStackView(with: viewProperties)
        setupAccessibilityId(with: viewProperties)
        addSegmentItems(using: viewProperties)
    }
    
    // MARK: - Private methods
    
    private func setupView(with viewProperties: ViewProperties) {
        removeConstraintsAndSubviews()
        
        addSubview(containerView)
        containerView.isAccessibilityElement = true
        containerView.accessibilityIdentifier = DesignSystemAccessibilityIDs.SegmentControl.containerView
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(viewProperties.margins.height).priority(.required)
        }
        
        backgroundColor = viewProperties.backgroundColor
        cornerRadius(
            radius: viewProperties.cornerRadius,
            direction: .allCorners,
            clipsToBounds: true
        )
    }
    
    private func setupSegmentStackView(with viewProperties: ViewProperties) {
        containerView.addSubview(segmentStackView)
        segmentStackView.spacing = viewProperties.margins.stackSpacing
        segmentStackView.isAccessibilityElement = true
        segmentStackView.accessibilityIdentifier = DesignSystemAccessibilityIDs.SegmentControl.segmentStack
        segmentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(viewProperties.margins.insets)
        }
    }
    
    private func addSegmentItems(using viewProperties: ViewProperties) {
        for itemView in viewProperties.itemViews {
            itemView.isAccessibilityElement = true
            segmentStackView.addArrangedSubview(itemView)
        }
    }
    
    private func removeConstraintsAndSubviews() {
        segmentStackView.arrangedSubviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        containerView.subviews.forEach { subview in
            subview.snp.removeConstraints()
            subview.removeFromSuperview()
        }
        
        subviews.forEach { subview in
            subview.snp.removeConstraints()
            subview.removeFromSuperview()
        }
    }
    
    private func setupAccessibilityId(with viewProperties: ViewProperties) {
        isAccessibilityElement = true
        accessibilityIdentifier = viewProperties.accessibilityId
    }
}
