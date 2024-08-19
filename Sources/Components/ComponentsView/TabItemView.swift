import UIKit
import SnapKit

public class TabItemView: UIView, ComponentProtocol {
    
    public struct ViewProperties {
        public var text: NSMutableAttributedString
        public var rightView: UIView?
        public var onTap: () -> Void
        
        public init(
            text: NSMutableAttributedString = .init(string: ""),
            rightView: UIView? = nil,
            onTap: @escaping () -> Void = { }
        ) {
            self.text = text
            self.rightView = rightView
            self.onTap = onTap
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    private let hStack: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 8
        stack.alignment = .center
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
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.top.bottom.equalToSuperview()
        }
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
    }
    
    public func update(with viewProperties: ViewProperties) {
        textLabel.attributedText = viewProperties.text
        updateStack(with: viewProperties)
        self.viewProperties = viewProperties
    }
    
    private func updateStack(with viewProperties: ViewProperties) {
        hStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        hStack.addArrangedSubview(textLabel)
        
        if let rightView = viewProperties.rightView {
            hStack.addArrangedSubview(rightView)
        }
    }
    
    @objc private func tapped() {
        viewProperties.onTap()
    }
}
