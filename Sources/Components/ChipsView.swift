import UIKit
import SnapKit

public class ChipsView: PressableView {
    
    public struct ViewProperties {
        public var height: CGFloat
        public var backgroundColor: UIColor
        public var cornerRadius: CGFloat
        public var leftView: UIView?
        public var text: NSMutableAttributedString
        public var rightView: UIView?
        public var insets: UIEdgeInsets
        public var isUserInteractionEnabled: Bool
        public var onPressChange: (State) -> Void
        
        public init(
            height: CGFloat = 0,
            backgroundColor: UIColor = .clear,
            cornerRadius: CGFloat = 0,
            leftView: UIView? = nil,
            text: NSMutableAttributedString = .init(string: ""),
            rightView: UIView? = nil,
            insets: UIEdgeInsets = .zero,
            isUserInteractionEnabled: Bool = true,
            onPressChange: @escaping (State) -> Void = { _ in }
        ) {
            self.height = height
            self.backgroundColor = backgroundColor
            self.cornerRadius = cornerRadius
            self.leftView = leftView
            self.text = text
            self.rightView = rightView
            self.insets = insets
            self.isUserInteractionEnabled = isUserInteractionEnabled
            self.onPressChange = onPressChange
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    private lazy var hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 8
        return stack
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupView() {
        addSubview(hStack)
        hStack.snp.makeConstraints {
            $0.edges.equalToSuperview() // будет обновлено
            $0.height.equalTo(0) // будет обновлено
        }
        textLabel.snp.makeConstraints {
            $0.width.lessThanOrEqualTo(200)
        }
    }
    
    public func update(with viewProperties: ViewProperties) {
        backgroundColor = viewProperties.backgroundColor
        layer.cornerRadius = viewProperties.cornerRadius
        textLabel.attributedText = viewProperties.text
        isUserInteractionEnabled = viewProperties.isUserInteractionEnabled
        updateStack(with: viewProperties)
        updateInsets(with: viewProperties)
        updateHeight(with: viewProperties)
        self.viewProperties = viewProperties
    }
    
    private func updateStack(with viewProperties: ViewProperties) {
        hStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if let leftView = viewProperties.leftView {
            hStack.addArrangedSubview(leftView)
        }
        
        hStack.addArrangedSubview(textLabel)
        
        if let rightView = viewProperties.rightView {
            hStack.addArrangedSubview(rightView)
        }
    }
    
    private func updateInsets(with viewProperties: ViewProperties) {
        guard self.viewProperties.insets != viewProperties.insets else { return }
        hStack.snp.updateConstraints {
            $0.edges.equalToSuperview().inset(viewProperties.insets)
        }
    }
    
    private func updateHeight(with viewProperties: ViewProperties) {
        guard self.viewProperties.height != viewProperties.height else { return }
        hStack.snp.updateConstraints {
            $0.height.equalTo(viewProperties.height)
        }
    }
    
    public override func handlePress(state: State) {
        UIView.animate(withDuration: 0.2) {
            self.viewProperties.onPressChange(state)
        }
    }
}
