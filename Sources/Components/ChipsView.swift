import UIKit
import SnapKit

public class ChipsView: PressableView {
    
    public struct ViewProperties {
        public var backgroundColor: UIColor
        public var leftView: UIView?
        public var text: NSMutableAttributedString
        public var rightView: UIView?
        public var insets: UIEdgeInsets
        public var onPressChange: (State) -> Void
        
        public init(
            backgroundColor: UIColor = .clear,
            leftView: UIView? = nil,
            text: NSMutableAttributedString = .init(string: ""),
            rightView: UIView? = nil,
            insets: UIEdgeInsets = .zero,
            onPressChange: @escaping (State) -> Void = { _ in }
        ) {
            self.backgroundColor = backgroundColor
            self.leftView = leftView
            self.text = text
            self.rightView = rightView
            self.insets = insets
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
        }
    }
    
    public func update(with viewProperties: ViewProperties) {
        backgroundColor = viewProperties.backgroundColor
        textLabel.attributedText = viewProperties.text
        updateStack(with: viewProperties)
        updateInsets(with: viewProperties)
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
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    public override func handlePress(state: State) {
        viewProperties.onPressChange(state)
    }
}
