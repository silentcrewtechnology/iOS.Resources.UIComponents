import UIKit
import SnapKit

public final class SectionMessageView: UIView, ComponentProtocol {
    
    public struct ViewProperties {
        public var title: NSMutableAttributedString?
        public var subtitle: NSMutableAttributedString?
        public var bottomButton: BottomButton?
        public var icon: Icon
        public var backgroundColor: UIColor
        public var cornerRadius: CGFloat
        public var insets: UIEdgeInsets
        
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
            insets: UIEdgeInsets = .zero
        ) {
            self.title = title
            self.subtitle = subtitle
            self.bottomButton = bottomButton
            self.icon = icon
            self.backgroundColor = backgroundColor
            self.cornerRadius = cornerRadius
            self.insets = insets
        }
    }
    
    //MARK: - UI
    
    private let iconView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        view.snp.makeConstraints {
            $0.size.equalTo(0) // будет обновлен
        }
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let bottomButtonTopSpacer: UIView = {
        let view = SpacerView()
        view.update(with: .init(size: .init(width: 4, height: 4)))
        return view
    }()
    
    private lazy var bottomButtonLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonTapped)))
        label.isHidden = true
        return label
    }()
    
    private lazy var rightStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            subtitleLabel,
            bottomButtonTopSpacer,
            bottomButtonLabel
        ])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 0
        return stack
    }()
    
    private lazy var hStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            iconView,
            rightStack
        ])
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.spacing = 12
        return stack
    }()
    
    //MARK: - private properties
    
    private var viewProperties: ViewProperties = .init()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupView(){
        addSubview(hStack)
        hStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.greaterThanOrEqualTo(16)
        }
        // Запрет пропуска нажатий сквозь вьюху
        addGestureRecognizer(UITapGestureRecognizer())
    }
    
    public func update(with viewProperties: ViewProperties) {
        updateTitle(title: viewProperties.title)
        updateSubtitle(subtitle: viewProperties.subtitle)
        updateIcon(icon: viewProperties.icon)
        updateButton(button: viewProperties.bottomButton)
        updateButtonTopSpacer(with: viewProperties)
        backgroundColor = viewProperties.backgroundColor
        layer.cornerRadius = viewProperties.cornerRadius
        updateInsets(insets: viewProperties.insets)
        self.viewProperties = viewProperties
    }
    
    private func updateTitle(title: NSMutableAttributedString?) {
        if let title = title {
            titleLabel.attributedText = title
            titleLabel.isHidden = false
        } else {
            titleLabel.isHidden = true
        }
    }
    
    private func updateSubtitle(subtitle: NSMutableAttributedString?) {
        if let subtitle = subtitle {
            subtitleLabel.attributedText = subtitle
            subtitleLabel.isHidden = false
        } else {
            subtitleLabel.isHidden = true
        }
    }
    
    private func updateIcon(icon: ViewProperties.Icon) {
        iconView.image = icon.image
        guard self.viewProperties.icon.size != icon.size else { return }
        iconView.snp.updateConstraints { $0.size.equalTo(icon.size) }
    }
    
    private func updateButton(button: ViewProperties.BottomButton?) {
        bottomButtonLabel.attributedText = button?.text
        bottomButtonLabel.isHidden = button == nil
    }
    
    private func updateButtonTopSpacer(with viewProperties: ViewProperties) {
        bottomButtonTopSpacer.isHidden = viewProperties.bottomButton == nil
        || viewProperties.title == nil && viewProperties.subtitle == nil
    }
    
    private func updateInsets(insets: UIEdgeInsets) {
        guard self.viewProperties.insets != insets else { return }
        hStack.snp.updateConstraints {
            $0.edges.equalToSuperview().inset(insets)
        }
    }
    
    @objc private func buttonTapped() {
        viewProperties.bottomButton?.action()
    }
}
