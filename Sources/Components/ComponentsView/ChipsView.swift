import UIKit
import SnapKit

public class ChipsView: PressableView, ComponentProtocol {
    
    public struct ViewProperties {
        public var defaultBackgroundColor: UIColor
        public var pressedBackgroundColor: UIColor
        public var selectedBackgroundColor: UIColor
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
        public var isSelected: Bool
        public var onChipsTap: (Bool) -> Void
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
            defaultBackgroundColor: UIColor = .clear,
            pressedBackgroundColor: UIColor = .clear,
            selectedBackgroundColor: UIColor = .clear,
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
            isSelected: Bool = false,
            onChipsTap: @escaping (Bool) -> Void = { _ in },
            onIconTap: @escaping () -> Void = { },
            margins: Margins = .init()
        ) {
            self.defaultBackgroundColor = defaultBackgroundColor
            self.pressedBackgroundColor = pressedBackgroundColor
            self.selectedBackgroundColor = selectedBackgroundColor
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
            self.isSelected = isSelected
            self.onChipsTap = onChipsTap
            self.onIconTap = onIconTap
            self.margins = margins
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    private var isSelected: Bool = false
    
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
        self.isSelected = viewProperties.isSelected
        setBackgroundColor(with: viewProperties)
        self.setCornerRadius(with: viewProperties)
        self.updateConstraints(with: viewProperties)
        self.updateStack(with: viewProperties)
        self.textLabel.tintColor = viewProperties.textColor
        self.textLabel.attributedText = viewProperties.text
        self.isUserInteractionEnabled = viewProperties.isUserInteractionEnabled
    }
    
    private func setBackgroundColor(with viewProperties: ViewProperties) {
        let bgcolor = isSelected ? viewProperties.selectedBackgroundColor : viewProperties.defaultBackgroundColor
        backgroundColor = bgcolor
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
            $0.top.equalToSuperview().offset(viewProperties.margins.top)//.priority(.high)
            $0.leading.equalToSuperview().offset(viewProperties.margins.leading)//.priority(.high)
            $0.trailing.equalToSuperview().offset(-viewProperties.margins.trailing)//.priority(.high)
            $0.bottom.equalToSuperview().offset(-viewProperties.margins.bottom)//.priority(.high)
            
        }
        
//        snp.makeConstraints {
//            $0.height.equalTo(viewProperties.margins.height)//.priority(.high)
//        }
    }
    
    private func removeConstraintsAndSubviews() {
        hStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        self.subviews.forEach { subview in
            subview.snp.removeConstraints()
            subview.removeFromSuperview()
        }
    }
    
//    private func setupGestureRecognizer() {
//        let gr = UITapGestureRecognizer(target: self, action: #selector(chipsTapped))
//        addGestureRecognizer(gr)
//    }
    
    private func setupGestureRecognizer() {
//        let gr = UITapGestureRecognizer(target: self, action: #selector(chipsTapped))
//        gr.delegate = self
//        addGestureRecognizer(gr)
    }
    
//    @objc
//    private func chipsTapped() {
//        viewProperties.onChipsTap()
//    }
    
    public override func handlePress(state: State) {
        switch state {
        case .pressed:
            backgroundColor = viewProperties.pressedBackgroundColor
        case .unpressed:
            isSelected = !isSelected
            let bgcolor = isSelected ? viewProperties.selectedBackgroundColor : viewProperties.defaultBackgroundColor
            backgroundColor = bgcolor
            viewProperties.onChipsTap(isSelected)
        case .cancelled:
            let bgcolor = isSelected ? viewProperties.selectedBackgroundColor : viewProperties.defaultBackgroundColor
            backgroundColor = bgcolor
            break
        }
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
