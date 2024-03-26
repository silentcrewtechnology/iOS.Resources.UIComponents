import UIKit
import SnapKit

public final class TextBlockView: UIView {
    
    public struct ViewProperties {
        public var text: NSMutableAttributedString
        public var contentInsets: UIEdgeInsets
        public var title: NSMutableAttributedString
        public var isMarked: Bool
        public var background: Background
        public var icon: Icon?
        
        public init(
            text: NSMutableAttributedString = .init(string: ""),
            contentInsets: UIEdgeInsets = .init(),
            title: NSMutableAttributedString = .init(string: ""),
            isMarked: Bool = false,
            background: Background = .init(),
            icon: Icon? = nil
        ) {
            self.text = text
            self.contentInsets = contentInsets
            self.title = title
            self.isMarked = isMarked
            self.background = background
            self.icon = icon
        }
        
        public struct Background {
            public var color: UIColor
            public var cornerRadius: CGFloat
            
            public init(
                color: UIColor = .clear,
                cornerRadius: CGFloat = .zero
            ) {
                self.color = color
                self.cornerRadius = cornerRadius
            }
        }

        public struct Icon {
            public var image: UIImage?
            public var text: NSMutableAttributedString
            public var backgroundColor: UIColor
            
            public init(
                image: UIImage? = nil,
                text: NSMutableAttributedString = .init(string: ""),
                backgroundColor: UIColor = . clear
            ) {
                self.image = image
                self.text = text
                self.backgroundColor = backgroundColor
            }
        }
        
    }
    
    // MARK: - UI
    
    private let plainLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let titleLabel = UILabel()
    
    private let verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    private let horizonalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Constants.stackSpacing
        stack.alignment = .top
        return stack
    }()
    
    private let iconView: UIImageView = {
        let view = UIImageView()
        view.isHidden = true
        view.layer.cornerRadius = Constants.iconCornerRadius
        view.layer.masksToBounds = true
        view.contentMode = .center
        return view
    }()
    
    private let iconNumber = UILabel()
    
    // MARK: - Private Properties
    
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - Init
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Public Methods
    
    public func update(with viewProperties: ViewProperties) {
        setupProperties(viewProperties: viewProperties)
        self.viewProperties = viewProperties
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        layer.masksToBounds = true
        addSubview(horizonalStack)
        horizonalStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        horizonalStack.addArrangedSubview(iconView)
        iconView.snp.makeConstraints {
            $0.size.equalTo(Constants.iconSize)
        }
        iconView.addSubview(iconNumber)
        iconNumber.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        horizonalStack.addArrangedSubview(verticalStack)
        verticalStack.addArrangedSubview(titleLabel)
        verticalStack.addArrangedSubview(plainLabel)
    }
    
    private func setupProperties(viewProperties: ViewProperties) {
        let plainText = viewProperties.text
        if viewProperties.isMarked {
            plainText.insert(.init(string: Constants.markerSymbol), at: 0)
        }
        plainLabel.attributedText = plainText
        titleLabel.attributedText = viewProperties.title
    
        if viewProperties.contentInsets != self.viewProperties.contentInsets {
            horizonalStack.snp.updateConstraints {
                $0.edges.equalTo(viewProperties.contentInsets)
            }
        }
        
        setupIcon(icon: viewProperties.icon)
        setupBackground(background: viewProperties.background)
    }

    private func setupBackground(background: ViewProperties.Background) {
        backgroundColor = background.color
        layer.cornerRadius = background.cornerRadius
    }
    
    private func setupIcon(icon: ViewProperties.Icon?) {
        guard let icon else {
            iconView.isHidden = true
            return
        }
        iconView.isHidden = false
        iconView.backgroundColor = icon.backgroundColor
        iconNumber.attributedText = icon.text
        iconView.image = icon.image
        iconNumber.isHidden = icon.image != nil
    }
}

private struct Constants {
    static let markerSymbol: String = "\u{2022} "
    static let iconSize: CGSize = CGSize(width: 40, height: 40)
    static let iconCornerRadius: CGFloat = 20
    static let stackSpacing: CGFloat = 16
}

