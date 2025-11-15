import UIKit
import SnapKit

public final class ChipsView: PressableView, ComponentProtocol {
    
    // MARK: - Properties
    
    public struct ViewProperties {
        public var backgroundColor: UIColor
        public var cornerRadius: CGFloat
        public var leftImage: UIImage?
        public var isLeftImageHidden: Bool?
        public var text: NSMutableAttributedString
        public var isTextHidden: Bool?
        public var rightImage: UIImage?
        public var isRightImageHidden: Bool?
        public var isUserInteractionEnabled: Bool
        public var onChipsTap: (Bool) -> Void
        public var handleTap: (PressableView.State) -> Void
        public var onIconTap: (() -> Void)?
        public var margins: Margins
        
        public struct Margins {
            public var insets: UIEdgeInsets
            public var spacing: CGFloat
            public var height: CGFloat
            
            public init(
                insets: UIEdgeInsets = .zero,
                spacing: CGFloat = .zero,
                height: CGFloat = .zero
            ) {
                self.insets = insets
                self.spacing = spacing
                self.height = height
            }
        }
        
        public init(
            backgroundColor: UIColor = .clear,
            cornerRadius: CGFloat = 0,
            leftImage: UIImage? = nil,
            isLeftImageHidden: Bool = false,
            text: NSMutableAttributedString = .init(string: ""),
            isTextHidden: Bool = false,
            rightImage: UIImage? = nil,
            isRightImageHidden: Bool = false,
            isUserInteractionEnabled: Bool = true,
            onChipsTap: @escaping (Bool) -> Void = { _ in },
            handleTap: @escaping (PressableView.State) -> Void = { _ in },
            onIconTap: (() -> Void)? = nil,
            margins: Margins = .init()
        ) {
            self.backgroundColor = backgroundColor
            self.cornerRadius = cornerRadius
            self.leftImage = leftImage
            self.isLeftImageHidden = isLeftImageHidden
            self.text = text
            self.isTextHidden = isTextHidden
            self.rightImage = rightImage
            self.isRightImageHidden = isRightImageHidden
            self.isUserInteractionEnabled = isUserInteractionEnabled
            self.onChipsTap = onChipsTap
            self.handleTap = handleTap
            self.onIconTap = onIconTap
            self.margins = margins
        }
    }
    
    // MARK: - Private properties
    
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - UI
    
    private lazy var hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        
        return stack
    }()

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var leftIconButton = UIButton()
    private lazy var rightIconButton = UIButton()
    
    // MARK: - Methods
    
    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
        
        isUserInteractionEnabled = viewProperties.isUserInteractionEnabled
        textLabel.attributedText = viewProperties.text
        setCornerRadius(with: viewProperties)
        updateConstraints(with: viewProperties)
        updateStack(with: viewProperties)
        
        UIView.animate(withDuration: 0.1) {
            self.backgroundColor = viewProperties.backgroundColor
        }
    }
    
    // MARK: - Private methods
    
    private func setCornerRadius(with viewProperties: ViewProperties) {
        cornerRadius(
            radius: viewProperties.cornerRadius,
            direction: .allCorners,
            clipsToBounds: true
        )
    }
    
    private func updateStack(with viewProperties: ViewProperties) {
        hStack.spacing = viewProperties.margins.spacing
        if let leftImage = viewProperties.leftImage,
           let isLeftImageHidden = viewProperties.isLeftImageHidden {
            if !isLeftImageHidden {
                leftIconButton.setImage(leftImage, for: .normal)
                leftIconButton.setImage(leftImage, for: .disabled)
                leftIconButton.addTarget(self, action: #selector(iconButtonTapped), for: .touchUpInside)
                leftIconButton.isEnabled = viewProperties.onIconTap != nil
                hStack.addArrangedSubview(leftIconButton)
            }
        }
        
        if let isTextHidden = viewProperties.isTextHidden {
            if !isTextHidden {
                hStack.addArrangedSubview(textLabel)
            }
        }
        
        if let rightImage = viewProperties.rightImage,
           let isRightImageHidden = viewProperties.isRightImageHidden {
            if !isRightImageHidden {
                rightIconButton.setImage(rightImage, for: .normal)
                rightIconButton.setImage(rightImage, for: .disabled)
                rightIconButton.addTarget(self, action: #selector(iconButtonTapped), for: .touchUpInside)
                rightIconButton.isEnabled = viewProperties.onIconTap != nil
                hStack.addArrangedSubview(rightIconButton)
            }
        }
    }
    
    private func updateConstraints(with viewProperties: ViewProperties) {
        removeConstraintsAndSubviews()
        
        addSubview(hStack)
        hStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(viewProperties.margins.insets)
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
    
    @objc private func iconButtonTapped() {
        viewProperties.onIconTap?()
    }
}

// MARK: - UIGestureRecognizerDelegate

extension ChipsView: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
}
