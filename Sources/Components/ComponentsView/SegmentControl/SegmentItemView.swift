import UIKit
import SnapKit
import AccessibilityIds

public final class SegmentItemView: PressableView, ComponentProtocol {
    
    // MARK: - ViewProperties
    
    public struct ViewProperties {
        public var backgroundColor: UIColor?
        public var cornerRadius: CGFloat
        public var text: NSMutableAttributedString
        public var margins: Margins
        public var divider: UIView?
        public var isDividerHidden: Bool
        public var onItemTap: (Bool) -> Void
        public var handlePress: (PressableView.State) -> Void
        public var accessibilityIds: AccessibilityIds?
        
        public struct Margins {
            public var height: CGFloat
            public var textInsets: UIEdgeInsets
            public var dividerInsets: UIEdgeInsets
            public var dividerHeight: CGFloat
            
            public init(
                height: CGFloat = .zero,
                textInsets: UIEdgeInsets = .zero,
                dividerInsets: UIEdgeInsets = .zero,
                dividerHeight: CGFloat = .zero
            ) {
                self.height = height
                self.textInsets = textInsets
                self.dividerInsets = dividerInsets
                self.dividerHeight = dividerHeight
            }
        }
        
        public struct AccessibilityIds {
            public var id: String
            public var labelId: String
            
            public init(
                id: String,
                labelId: String
            ) {
                self.id = id
                self.labelId = labelId
            }
        }
        
        public init(
            backgroundColor: UIColor? = nil,
            cornerRadius: CGFloat = 0,
            text: NSMutableAttributedString = .init(string: ""),
            margins: Margins = .init(),
            divider: UIView? = nil,
            isDividerHidden: Bool = true,
            onItemTap: @escaping (Bool) -> Void = { _ in },
            handlePress: @escaping (PressableView.State) -> Void = { _ in },
            accessibilityIds: AccessibilityIds? = nil
        ) {
            self.backgroundColor = backgroundColor
            self.cornerRadius = cornerRadius
            self.text = text
            self.margins = margins
            self.divider = divider
            self.isDividerHidden = isDividerHidden
            self.onItemTap = onItemTap
            self.handlePress = handlePress
            self.accessibilityIds = accessibilityIds
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - UI
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        
        return label
    }()

    private lazy var containerView = UIView()
    
    // MARK: - Init
    
    public override func handlePress(state: State) {
        viewProperties.handlePress(state)
    }
    
    // MARK: - Update
    
    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
        
        setupView(with: viewProperties)
        setupTitleLabel(with: viewProperties)
        setupDividerView(with: viewProperties)
        setupAccessibilityIds(with: viewProperties)
        
        UIView.animate(withDuration: 0.1) {
            self.backgroundColor = viewProperties.backgroundColor
        }
    }
    
    // MARK: - Private methods
    
    private func setupView(with viewProperties: ViewProperties) {
        removeConstraintsAndSubviews()
        
        addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(viewProperties.margins.height).priority(.required)
        }
        
        cornerRadius(
            radius: viewProperties.cornerRadius,
            direction: .allCorners,
            clipsToBounds: true
        )
    }
    
    private func setupTitleLabel(with viewProperties: ViewProperties) {
        containerView.addSubview(titleLabel)
        titleLabel.attributedText = viewProperties.text
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(viewProperties.margins.textInsets)
        }
    }
    
    private func setupDividerView(with viewProperties: ViewProperties) {
        guard let dividerView = viewProperties.divider else { return }
        
        containerView.addSubview(dividerView)
        dividerView.isHidden = viewProperties.isDividerHidden
        dividerView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(viewProperties.margins.dividerInsets)
            $0.height.equalTo(viewProperties.margins.height)
        }
    }

    private func removeConstraintsAndSubviews() {
        containerView.subviews.forEach { subview in
            subview.snp.removeConstraints()
            subview.removeFromSuperview()
        }
        
        subviews.forEach { subview in
            subview.snp.removeConstraints()
            subview.removeFromSuperview()
        }
    }
    
    private func setupAccessibilityIds(with viewProperties: ViewProperties) {
        isAccessibilityElement = true
        accessibilityIdentifier = viewProperties.accessibilityIds?.id
        containerView.isAccessibilityElement = true
        containerView.accessibilityIdentifier = DesignSystemAccessibilityIDs.SegmentItemView.containerView
        titleLabel.isAccessibilityElement = true
        titleLabel.accessibilityIdentifier = viewProperties.accessibilityIds?.labelId
    }
}
