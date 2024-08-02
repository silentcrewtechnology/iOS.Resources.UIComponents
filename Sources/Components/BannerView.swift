import UIKit
import SnapKit

public final class BannerView: UIView {
    
    // MARK: - Properties
    
    public struct ViewProperties {
        public var title: NSMutableAttributedString?
        public var subtitle: NSMutableAttributedString?
        public var bottomButton: BottomButton?
        public var icon: Icon
        public var backgroundColor: UIColor
        public var cornerRadius: CGFloat
        public var rightStackViewSpacing: CGFloat
        public var horizontalStackViewSpacing: CGFloat
        public var height: Int
        public var stackViewInsets: UIEdgeInsets
        public var containerViewInsets: UIEdgeInsets
        public var spacerViewProperties: SpacerView.ViewProperties?
        
        public struct BottomButton {
            public var text: NSMutableAttributedString?
            public var action: () -> Void
            
            public init(
                text: NSMutableAttributedString? = nil,
                action: @escaping () -> Void = { }
            ) {
                self.text = text
                self.action = action
            }
        }
        
        public struct Icon {
            public var image: UIImage
            public var size: CGSize
            
            public init(
                image: UIImage = .init(),
                size: CGSize = .zero
            ) {
                self.image = image
                self.size = size
            }
        }
        
        public init(
            title: NSMutableAttributedString? = nil,
            subtitle: NSMutableAttributedString? = nil,
            bottomButton: BottomButton? = nil,
            icon: Icon = .init(),
            backgroundColor: UIColor = .clear,
            cornerRadius: CGFloat = 0,
            rightStackViewSpacing: CGFloat = .zero,
            horizontalStackViewSpacing: CGFloat = 12,
            height: Int = .zero,
            stackViewInsets: UIEdgeInsets = .zero,
            containerViewInsets: UIEdgeInsets = .zero,
            spacerViewProperties: SpacerView.ViewProperties? = nil
        ) {
            self.title = title
            self.subtitle = subtitle
            self.bottomButton = bottomButton
            self.icon = icon
            self.backgroundColor = backgroundColor
            self.cornerRadius = cornerRadius
            self.stackViewInsets = stackViewInsets
            self.containerViewInsets = containerViewInsets
            self.rightStackViewSpacing = rightStackViewSpacing
            self.horizontalStackViewSpacing = horizontalStackViewSpacing
            self.height = height
            self.spacerViewProperties = spacerViewProperties
        }
    }
    
    // MARK: - Private properties
    
    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        
        return label
    }()
    
    private lazy var rightStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            subtitleLabel,
            bottomButtonTopSpacer,
            bottomButton
        ])
        stack.axis = .vertical
        stack.alignment = .leading
        
        return stack
    }()
    
    private lazy var hStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            iconImageView,
            rightStackView
        ])
        stack.axis = .horizontal
        stack.alignment = .leading
        
        return stack
    }()
    
    private lazy var containerView = UIView()
    private lazy var bottomButtonTopSpacer = SpacerView()
    private lazy var bottomButton = UIButton()
    
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - Methods

    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
        
        containerView.backgroundColor = viewProperties.backgroundColor
        containerView.layer.cornerRadius = viewProperties.cornerRadius
        setupView(viewProperties: viewProperties)
        updateTitleLabel(title: viewProperties.title)
        updateSubtitleLabel(subtitle: viewProperties.subtitle)
        updateIconImageView(icon: viewProperties.icon)
        updateBottomButton(button: viewProperties.bottomButton)
        updateBottomButtonTopSpacer(with: viewProperties)
    }
    
    // MARK: - Private methods
    
    private func setupView(viewProperties: ViewProperties){
        removeConstraintsAndSubviews()
        
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(viewProperties.containerViewInsets)
            make.height.lessThanOrEqualTo(viewProperties.height)
        }
        
        containerView.addSubview(hStackView)
        hStackView.spacing = viewProperties.horizontalStackViewSpacing
        rightStackView.spacing = viewProperties.rightStackViewSpacing
        hStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(viewProperties.stackViewInsets)
        }
        // Запрет пропуска нажатий сквозь вьюху
        containerView.addGestureRecognizer(UITapGestureRecognizer())
    }
    
    private func updateTitleLabel(title: NSMutableAttributedString?) {
        titleLabel.attributedText = title
        titleLabel.isHidden = title == nil
    }
    
    private func updateSubtitleLabel(subtitle: NSMutableAttributedString?) {
        subtitleLabel.attributedText = subtitle
        subtitleLabel.isHidden = subtitle == nil
    }
    
    private func updateIconImageView(icon: ViewProperties.Icon) {
        iconImageView.image = icon.image
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(icon.size)
        }
    }
    
    private func updateBottomButton(button: ViewProperties.BottomButton?) {
        bottomButton.setAttributedTitle(viewProperties.bottomButton?.text, for: .normal)
        bottomButton.addTarget(self, action: #selector(bottomButtonTapped), for: .touchUpInside)
    }
    
    private func updateBottomButtonTopSpacer(with viewProperties: ViewProperties) {
        bottomButtonTopSpacer.isHidden = viewProperties.bottomButton == nil
            || viewProperties.title == nil
            && viewProperties.subtitle == nil
        
        guard let spacerViewProperties = viewProperties.spacerViewProperties else { return }
        
        bottomButtonTopSpacer.update(with: spacerViewProperties)
    }
    
    private func removeConstraintsAndSubviews() {
        subviews.forEach { subview in
            subview.snp.removeConstraints()
            subview.removeFromSuperview()
        }
    }
    
    @objc private func bottomButtonTapped() {
        viewProperties.bottomButton?.action()
    }
}
