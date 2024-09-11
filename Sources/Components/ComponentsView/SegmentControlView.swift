import UIKit
import SnapKit
import AccessibilityIds

public class SegmentControlView: UIView, ComponentProtocol {
    
    public struct ViewProperties {
        public var backgroundColor: UIColor
        public var itemViews: [SegmentItemView]
        public var selectedSegmentIndex: Int
        public var cornerRadius: CGFloat
        public var margins: Margins
        public let accessibilityId: String?
        
        public struct Margins {
            public var top: CGFloat
            public var bottom: CGFloat
            public var leading: CGFloat
            public var trailing: CGFloat
            public var height: CGFloat
            
            public init(
                top: CGFloat = 0,
                bottom: CGFloat = 0,
                leading: CGFloat = 0,
                trailing: CGFloat = 0,
                height: CGFloat = 0
            ) {
                self.top = top
                self.bottom = bottom
                self.leading = leading
                self.trailing = trailing
                self.height = height
            }
        }
        
        public init(
            backgroundColor: UIColor = .clear,
            itemViews: [SegmentItemView] = [],
            selectedSegmentIndex: Int = 0,
            cornerRadius: CGFloat = .zero,
            margins: Margins = .init(),
            accessibilityId: String? = nil
        ) {
            self.backgroundColor = backgroundColor
            self.itemViews = itemViews
            self.selectedSegmentIndex = selectedSegmentIndex
            self.cornerRadius = cornerRadius
            self.margins = margins
            self.accessibilityId = accessibilityId
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - UI
    
    private let segmentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = .zero
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let containerView = UIView()
    
    // MARK: - init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Update
    
    public func update(with viewProperties: ViewProperties) {
        updateConstraints(with: viewProperties)
        self.viewProperties = viewProperties
        setBackgroundColor(with: viewProperties)
        setCornerRadius(with: viewProperties)
        createSegments(using: viewProperties)
        setupAccessibilityId(with: viewProperties)
    }
}

// MARK: - private methods

// MARK: Update Properties

extension SegmentControlView {
    private func setBackgroundColor(with viewProperties: ViewProperties) {
        backgroundColor = viewProperties.backgroundColor
    }
    
    private func setCornerRadius(with viewProperties: ViewProperties) {
        cornerRadius(
            radius: viewProperties.cornerRadius,
            direction: .allCorners,
            clipsToBounds: true
        )
    }
    
    private func createSegments(using viewProperties: ViewProperties) {
        for itemView in viewProperties.itemViews {
            itemView.isAccessibilityElement = true
            segmentStack.addArrangedSubview(itemView)
        }
    }
    
    private func setupAccessibilityId(with viewProperties: ViewProperties) {
        isAccessibilityElement = true
        accessibilityIdentifier = viewProperties.accessibilityId
    }
}

// MARK: Setup Constraints

extension SegmentControlView {
    
    private func setupConstraints() {
        setupContainer()
        setupSegmentStack()
    }
    
    private func setupContainer() {
        addSubview(containerView)
        containerView.isAccessibilityElement = true
        containerView.accessibilityIdentifier = DesignSystemAccessibilityIDs.SegmentControl.containerView
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(0).priority(.required)
        }
    }
    
    private func setupSegmentStack() {
        containerView.addSubview(segmentStack)
        segmentStack.isAccessibilityElement = true
        segmentStack.accessibilityIdentifier = DesignSystemAccessibilityIDs.SegmentControl.segmentStack
        segmentStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(0)
            $0.leading.equalToSuperview().offset(0)
            $0.trailing.equalToSuperview().offset(0)
            $0.bottom.equalToSuperview().offset(0)
        }
    }
}

// MARK: Update Constraints

extension SegmentControlView {
    
    private func updateConstraints(with viewProperties: ViewProperties) {
        updateContainer(with: viewProperties)
        updateSegmentStack(with: viewProperties)
    }
    
    private func updateContainer(with viewProperties: ViewProperties) {
        guard self.viewProperties.margins.height != viewProperties.margins.height else { return }
        containerView.snp.updateConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(viewProperties.margins.height).priority(.required)
        }
    }
    
    private func updateSegmentStack(with viewProperties: ViewProperties) {
        guard self.viewProperties.margins.top != viewProperties.margins.top ||
              self.viewProperties.margins.leading != viewProperties.margins.leading ||
              self.viewProperties.margins.trailing != viewProperties.margins.trailing ||
              self.viewProperties.margins.bottom != viewProperties.margins.bottom
        else { return }
        segmentStack.snp.updateConstraints {
            $0.top.equalToSuperview().offset(viewProperties.margins.top)
            $0.leading.equalToSuperview().offset(viewProperties.margins.leading)
            $0.trailing.equalToSuperview().offset(-viewProperties.margins.trailing)
            $0.bottom.equalToSuperview().offset(-viewProperties.margins.bottom)
        }
    }
}
