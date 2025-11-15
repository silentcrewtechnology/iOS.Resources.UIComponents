import UIKit
import SnapKit

public final class StoryTileView: UIView, ComponentProtocol {
    
    // MARK: - ViewProperties
    
    public struct ViewProperties {
        public var title: NSMutableAttributedString
        public var titleInsets: UIEdgeInsets
        public var content: Content
        public var border: Border
        public var size: CGSize
        public var onTap: () -> Void
        
        public init(
            title: NSMutableAttributedString = .init(string: ""),
            titleInsets: UIEdgeInsets = .zero,
            content: Content = .init(),
            border: Border = .init(),
            size: CGSize = .zero,
            onTap: @escaping () -> Void = { }
        ) {
            self.title = title
            self.titleInsets = titleInsets
            self.content = content
            self.border = border
            self.size = size
            self.onTap = onTap
        }
        
        public struct Content {
            public var image: UIImage
            public var color: UIColor
            public var cornerRadius: CGFloat
            public var insets: UIEdgeInsets
            public var gradient: GradientView
            public var gradientInsets: UIEdgeInsets
            
            public init(
                image: UIImage = .init(),
                color: UIColor = .clear,
                cornerRadius: CGFloat = 0,
                insets: UIEdgeInsets = .zero,
                gradient: GradientView = .init(),
                gradientInsets: UIEdgeInsets = .zero
            ) {
                self.image = image
                self.color = color
                self.cornerRadius = cornerRadius
                self.insets = insets
                self.gradient = gradient
                self.gradientInsets = gradientInsets
            }
        }
        
        public struct Border {
            public var color: UIColor
            public var width: CGFloat
            public var cornerRadius: CGFloat
            
            public init(
                color: UIColor = .clear,
                width: CGFloat = 0,
                cornerRadius: CGFloat = 0
            ) {
                self.color = color
                self.width = width
                self.cornerRadius = cornerRadius
            }
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - UI
    
    private let contentView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private var borderView: UIView = {
        let view = UIView()
        return view
    }()
    
    // MARK: - init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    public func update(with viewProperties: ViewProperties) {
        snp.updateConstraints { $0.size.equalTo(viewProperties.size) }
        updateContent(with: viewProperties)
        updateGradient(with: viewProperties)
        updateTitle(with: viewProperties)
        updateIndicator(with: viewProperties)
        self.viewProperties = viewProperties
    }
    
    // MARK: - private methods
    
    private func setupView() {
        snp.makeConstraints { $0.size.equalTo(0) }
        addSubview(borderView)
        borderView.snp.makeConstraints { $0.edges.equalToSuperview() }
        addSubview(contentView)
        contentView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func updateContent(with viewProperties: ViewProperties) {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        contentView.backgroundColor = viewProperties.content.color
        contentView.image = viewProperties.content.image
        contentView.layer.cornerRadius = viewProperties.content.cornerRadius
        contentView.snp.updateConstraints {
            $0.edges.equalToSuperview().inset(viewProperties.content.insets)
        }
    }
    
    private func updateGradient(with viewProperties: ViewProperties) {
        let gradientView = viewProperties.content.gradient
        contentView.addSubview(gradientView)
        gradientView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(viewProperties.content.gradientInsets)
        }
        gradientView.cornerRadius(radius: viewProperties.content.cornerRadius, direction: .top, clipsToBounds: true)
    }
    
    private func updateTitle(with viewProperties: ViewProperties) {
        titleLabel.removeFromSuperview()
        titleLabel.attributedText = viewProperties.title
        // отступы внутри градиента, чтобы сохранить контрастность текста
        viewProperties.content.gradient.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview().inset(viewProperties.titleInsets)
            $0.bottom.lessThanOrEqualToSuperview().inset(viewProperties.titleInsets)
        }
    }
    
    private func updateIndicator(with viewProperties: ViewProperties) {
        UIView.animate(withDuration: 0.2) { [self] in
            borderView.layer.borderColor = viewProperties.border.color.cgColor
            borderView.layer.cornerRadius = viewProperties.border.cornerRadius
            borderView.layer.borderWidth = viewProperties.border.width
        }
    }
}
