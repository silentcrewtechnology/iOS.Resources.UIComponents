import UIKit
import SnapKit
import AccessibilityIds

public class SegmentItemView: PressableView, ComponentProtocol {
    
    // MARK: - ViewProperties
    
    public struct ViewProperties {
        public var backgroundColor: UIColor?
        public var cornerRadius: CGFloat
        public var text: NSMutableAttributedString
        public var textColor: UIColor
        public var textAlignment: NSTextAlignment
        public var margins: Margins
        public var divider: DividerView.ViewProperties
        public var isDividerHidden: Bool
        public var handleTap: (PressableView.State) -> Void
        public var onItemTap: (Bool) -> Void
        public var accessibilityIds: AccessibilityIds?
        
        public struct Margins {
            public var height: CGFloat
            public var textLeading: CGFloat
            public var textTrailing: CGFloat
            public var textTop: CGFloat
            public var textBottom: CGFloat
            public var dividerTop: CGFloat
            public var dividerTrailing: CGFloat
            public var dividerBottom: CGFloat
            
            public init(
                height: CGFloat = 0,
                textLeading: CGFloat = 0,
                textTrailing: CGFloat = 0,
                textTop: CGFloat = 0,
                textBottom: CGFloat = 0,
                dividerTop: CGFloat = 0,
                dividerTrailing: CGFloat = 0,
                dividerBottom: CGFloat = 0
            ) {
                self.height = height
                self.textLeading = textLeading
                self.textTrailing = textTrailing
                self.textTop = textTop
                self.textBottom = textBottom
                self.dividerTop = dividerTop
                self.dividerTrailing = dividerTrailing
                self.dividerBottom = dividerBottom
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
            textColor: UIColor = .clear,
            textAlignment: NSTextAlignment = .center,
            margins: Margins = .init(),
            divider: DividerView.ViewProperties = .init(),
            isDividerHidden: Bool = true,
            handleTap: @escaping (PressableView.State) -> Void = { _ in },
            onItemTap: @escaping (Bool) -> Void = { _ in },
            accessibilityIds: AccessibilityIds? = nil
        ) {
            self.backgroundColor = backgroundColor
            self.cornerRadius = cornerRadius
            self.text = text
            self.textColor = textColor
            self.textAlignment = textAlignment
            self.margins = margins
            self.divider = divider
            self.isDividerHidden = isDividerHidden
            self.handleTap = handleTap
            self.onItemTap = onItemTap
            self.accessibilityIds = accessibilityIds
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - UI
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let dividerView: DividerView = {
        let view = DividerView()
        return view
    }()
    
    private let containerView = UIView()
    
    // MARK: - init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    public override func handlePress(state: State) {
        viewProperties.handleTap(state)
    }
    
    // MARK: - Update
    
    public func update(with viewProperties: ViewProperties) {
        updateConstraints(with: viewProperties)
        self.viewProperties = viewProperties
        updateLabel(with: viewProperties)
        updatedividerView(with: viewProperties)
        setBackgroundColor(with: viewProperties)
        setCornerRadius(with: viewProperties)
        setupAccessibilityIds(with: viewProperties)
    }
}

// MARK: - private methods

// MARK: Update Properties

extension SegmentItemView {
    private func setCornerRadius(with viewProperties: ViewProperties) {
        cornerRadius(
            radius: viewProperties.cornerRadius,
            direction: .allCorners,
            clipsToBounds: true
        )
    }
    
    private func updateLabel(with viewProperties: ViewProperties) {
        titleLabel.attributedText = viewProperties.text
        titleLabel.textColor = viewProperties.textColor
        titleLabel.textAlignment = viewProperties.textAlignment
    }
    
    private func updatedividerView(with viewProperties: ViewProperties) {
        dividerView.update(with: viewProperties.divider)
        dividerView.isHidden = viewProperties.isDividerHidden
    }
    
    private func setBackgroundColor(with viewProperties: ViewProperties) {
        backgroundColor = viewProperties.backgroundColor
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

// MARK: Setup Constraints

extension SegmentItemView {
    private func setupConstraints() {
        setupContainer()
        setupTitleLabel()
        setupDeviderView()
    }
    
    private func setupContainer() {
        addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(0).priority(.required)
        }
    }
    
    private func setupTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(0)
            $0.trailing.equalToSuperview().offset(0)
        }
    }
    
    private func setupDeviderView() {
        containerView.addSubview(dividerView)
        dividerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(0)
            $0.trailing.equalToSuperview().offset(0)
            $0.bottom.equalToSuperview().offset(0)
        }
    }
}

// MARK: Update Constraints

extension SegmentItemView {
    private func updateConstraints(with viewProperties: ViewProperties) {
        updateContainer(with: viewProperties)
        updateTitleLabel(with: viewProperties)
        updateDeviderView(with: viewProperties)
    }
    
    private func updateContainer(with viewProperties: ViewProperties) {
        guard self.viewProperties.margins.height != viewProperties.margins.height else { return }
        containerView.snp.updateConstraints {
            $0.height.equalTo(viewProperties.margins.height).priority(.required)
        }
    }
    
    private func updateTitleLabel(with viewProperties: ViewProperties) {
        guard self.viewProperties.margins.textLeading != viewProperties.margins.textLeading ||
              self.viewProperties.margins.textTrailing != viewProperties.margins.textTrailing
        else { return }
        
        titleLabel.snp.updateConstraints {
            $0.leading.equalToSuperview().offset(viewProperties.margins.textLeading)
            $0.trailing.equalToSuperview().offset(-viewProperties.margins.textTrailing)
        }
    }
    
    private func updateDeviderView(with viewProperties: ViewProperties) {
        guard self.viewProperties.margins.dividerTop != viewProperties.margins.dividerTop ||
              self.viewProperties.margins.dividerTrailing != viewProperties.margins.dividerTrailing ||
              self.viewProperties.margins.dividerBottom != viewProperties.margins.dividerBottom
        else { return }
        dividerView.snp.updateConstraints {
            $0.top.equalToSuperview().offset(viewProperties.margins.dividerTop)
            $0.trailing.equalToSuperview().offset(-viewProperties.margins.dividerTrailing)
            $0.bottom.equalToSuperview().offset(-viewProperties.margins.dividerBottom)
        }
    }
}
