import UIKit
import SnapKit


public final class ButtonView: UIButton, ComponentProtocol {
    
    public struct ViewProperties {
        public var isEnabled: Bool
        public var attributedText: NSMutableAttributedString
        public var leftIcon: UIImage?
        public var rightIcon: UIImage?
        public var backgroundColor: UIColor
        public var onHighlighted: (Bool) -> Void
        public var activityIndicator: ActivityIndicatorView.ViewProperties
        public var onTap: () -> Void
        public var insets: UIEdgeInsets
        
        public init(
            isEnabled: Bool = true,
            isLoading: Bool = false,
            attributedText: NSMutableAttributedString = .init(string: ""),
            leftIcon: UIImage? = nil,
            rightIcon: UIImage? = nil,
            backgroundColor: UIColor = .clear,
            activityIndicator: ActivityIndicatorView.ViewProperties = .init(),
            onHighlighted: @escaping (Bool) -> Void = { _ in },
            onTap: @escaping () -> Void = { },
            insets: UIEdgeInsets = .zero
        ) {
            self.isEnabled = isEnabled
            self.attributedText = attributedText
            self.leftIcon = leftIcon
            self.rightIcon = rightIcon
            self.backgroundColor = backgroundColor
            self.activityIndicator = activityIndicator
            self.onHighlighted = onHighlighted
            self.onTap = onTap
            self.insets = insets
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - UI
    
    private let activityIndicator = ActivityIndicatorView()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.isUserInteractionEnabled = false
        return stackView
    }()
    
    private let leftIconView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        return view
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private let rightIconView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        return view
    }()
    
    public override var isHighlighted: Bool {
        didSet {
            viewProperties.onHighlighted(isHighlighted)
        }
    }
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Public Methods
    
    public func update(with viewProperties: ViewProperties) {
        setupProperties(with: viewProperties)
        updateInsets(with: viewProperties)
        setupActionButton(with: viewProperties)
        updateIndicator(indicator: viewProperties.activityIndicator)
        self.viewProperties = viewProperties
    }
    
    // MARK: - Private Methods
    
    private func setupProperties(with viewProperties: ViewProperties) {
        backgroundColor = viewProperties.backgroundColor
        isUserInteractionEnabled = viewProperties.isEnabled
        textLabel.attributedText = viewProperties.attributedText
        
        if let leftIcon = viewProperties.leftIcon {
            leftIconView.image = leftIcon
        } else {
            stackView.removeArrangedSubview(leftIconView)
        }
        
        if let rightIcon = viewProperties.rightIcon {
            rightIconView.image = rightIcon
        } else {
            stackView.removeArrangedSubview(rightIconView)
        }
    }
    
    private func setupActionButton(with viewProperties: ViewProperties) {
        addTarget(self, action: #selector(didTapAction), for: .touchUpInside)
    }
    
    private func setupView() {
        
        layer.cornerRadius = 8
        
        [stackView, activityIndicator].forEach { addSubview($0) }
        [leftIconView, textLabel, rightIconView].forEach { stackView.addArrangedSubview($0) }
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func updateInsets(with viewProperties: ViewProperties) {
        guard self.viewProperties.insets != viewProperties.insets else { return }
        stackView.snp.updateConstraints {
            $0.leading.greaterThanOrEqualToSuperview().offset(viewProperties.insets.left)
            $0.trailing.lessThanOrEqualToSuperview().inset(viewProperties.insets.right)
            $0.top.bottom.equalToSuperview().inset(viewProperties.insets)
        }
    }
    
    private func updateIndicator(indicator: ActivityIndicatorView.ViewProperties) {
        stackView.isHidden = indicator.isAnimating
        activityIndicator.update(with: indicator)
    }
    
    @objc
    private func didTapAction() {
        self.viewProperties.onTap()
    }
}
