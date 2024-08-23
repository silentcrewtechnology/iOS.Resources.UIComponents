import UIKit
import SnapKit

public class ChipsView: PressableView, ComponentProtocol {
    
    public struct ViewProperties {
        public var backgroundColor: UIColor
        public var cornerRadius: CGFloat
        public var leftImage: UIImage?
        public var leftImageColor: UIColor
        public var isLeftImageHidden: Bool?
        public var text: NSMutableAttributedString
        public var textColor: UIColor
        public var isTextHidden: Bool?
        public var rightImage: UIImage?
        public var rightImageColor: UIColor
        public var isRightImageHidden: Bool?
        public var isUserInteractionEnabled: Bool
        public var onChipsTap: (Bool) -> Void
        public var handleTap: (PressableView.State) -> Void
        public var onIconTap: () -> Void
        public var margins: Margins
        
        public struct Margins {
            public var spacing: CGFloat
            public var top: CGFloat
            public var leading: CGFloat
            public var trailing: CGFloat
            public var bottom: CGFloat
            public var height: CGFloat = 0
            
            public init(
                spacing: CGFloat = 0,
                top: CGFloat = 0,
                leading: CGFloat = 0,
                trailing: CGFloat = 0,
                bottom: CGFloat = 0,
                height: CGFloat = 0
            ) {
                self.spacing = spacing
                self.top = top
                self.leading = leading
                self.trailing = trailing
                self.bottom = bottom
                self.height = height
            }
        }
        
        public init(
            backgroundColor: UIColor = .clear,
            cornerRadius: CGFloat = 0,
            leftImage: UIImage? = nil,
            leftImageColor: UIColor = .clear,
            isLeftImageHidden: Bool = false,
            text: NSMutableAttributedString = .init(string: ""),
            isTextHidden: Bool = false,
            textColor: UIColor = .clear,
            rightImage: UIImage? = nil,
            rightImageColor: UIColor = .clear,
            isRightImageHidden: Bool = false,
            isUserInteractionEnabled: Bool = true,
            onChipsTap: @escaping (Bool) -> Void = { _ in },
            handleTap: @escaping (PressableView.State) -> Void = { _ in },
            onIconTap: @escaping () -> Void = { },
            margins: Margins = .init()
        ) {
            self.backgroundColor = backgroundColor
            self.cornerRadius = cornerRadius
            self.leftImage = leftImage
            self.leftImageColor = leftImageColor
            self.isLeftImageHidden = isLeftImageHidden
            self.text = text
            self.isTextHidden = isTextHidden
            self.textColor = textColor
            self.rightImage = rightImage
            self.rightImageColor = rightImageColor
            self.isRightImageHidden = isRightImageHidden
            self.isUserInteractionEnabled = isUserInteractionEnabled
            self.onChipsTap = onChipsTap
            self.handleTap = handleTap
            self.onIconTap = onIconTap
            self.margins = margins
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    // TODO: Проверить работу на устройстве
    
    // MARK: - UI
    
    private lazy var hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        return stack
    }()
    
    private let leftImageView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let rightImageView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
        self.backgroundColor = viewProperties.backgroundColor
        self.setCornerRadius(with: viewProperties)
        self.updateConstraints(with: viewProperties)
        self.updateStack(with: viewProperties)
        self.textLabel.textColor = viewProperties.textColor
        self.textLabel.attributedText = viewProperties.text
        self.isUserInteractionEnabled = viewProperties.isUserInteractionEnabled
    }
    
    private func setCornerRadius(with viewProperties: ViewProperties) {
        cornerRadius(
            radius: viewProperties.cornerRadius,
            direction: .allCorners,
            clipsToBounds: true
        )
    }
    
    private func updateStack(with viewProperties: ViewProperties) {
        
        if let leftImage = viewProperties.leftImage,
           let isLeftImageHidden = viewProperties.isLeftImageHidden {
            if !isLeftImageHidden {
                let gr = UITapGestureRecognizer(target: self, action: #selector(iconTapped))
                leftImageView.image = leftImage.withTintColor(viewProperties.leftImageColor)
                leftImageView.addGestureRecognizer(gr)
                hStack.addArrangedSubview(leftImageView)
            }
        }
        
        if let isTextHidden = viewProperties.isTextHidden {
            if !isTextHidden {
                hStack.addArrangedSubview(textLabel)
            }
        }
        
        // TODO / UITapGestureRecognizer - не работает с PressableView
        if let rightImage = viewProperties.rightImage,
           let isRightImageHidden = viewProperties.isRightImageHidden {
            if !isRightImageHidden {
                let gr = UITapGestureRecognizer(target: self, action: #selector(iconTapped))
                rightImageView.image = rightImage.withTintColor(viewProperties.rightImageColor)
                rightImageView.addGestureRecognizer(gr)
                hStack.addArrangedSubview(rightImageView)
            }
        }
    }
    
    private func updateConstraints(with viewProperties: ViewProperties) {
        removeConstraintsAndSubviews()
        addSubview(hStack)
        hStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(viewProperties.margins.top)
            $0.leading.equalToSuperview().offset(viewProperties.margins.leading)
            $0.trailing.equalToSuperview().offset(-viewProperties.margins.trailing)
            $0.bottom.equalToSuperview().offset(-viewProperties.margins.bottom)
            
        }
    }
    
    private func removeConstraintsAndSubviews() {
        hStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        self.subviews.forEach { subview in
            subview.snp.removeConstraints()
            subview.removeFromSuperview()
        }
    }
    
    public override func handlePress(state: State) {
        viewProperties.handleTap(state)
    }
    
    @objc
    private func iconTapped() {
        viewProperties.onIconTap()
    }
}

extension ChipsView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
