import UIKit
import SnapKit

public final class HintView: UIView {
    
    public struct ViewProperties {
        public var text: NSMutableAttributedString?
        public var textIsHidden: Bool
        public var additionalText: NSMutableAttributedString?
        public var additionalTextIsHidden: Bool
        public var minHeight: CGFloat
        
        public init(
            text: NSMutableAttributedString? = nil,
            textIsHidden: Bool = false,
            additionalText: NSMutableAttributedString? = nil,
            additionalTextIsHidden: Bool = false,
            minHeight: CGFloat = 0
        ) {
            self.text = text
            self.textIsHidden = textIsHidden
            self.additionalText = additionalText
            self.additionalTextIsHidden = additionalTextIsHidden
            self.minHeight = minHeight
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    private lazy var hStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            label,
            additionalLabel
        ])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .top
        return stack
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let additionalLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.defaultHigh + 1, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    
    public func update(with viewProperties: ViewProperties) {
        removeConstraintsAndSubviews()
        updateLabels(with: viewProperties)
        updateView(with: viewProperties)
        self.viewProperties = viewProperties
    }
    
    private func updateLabels(with viewProperties: ViewProperties) {
        label.attributedText = viewProperties.text
        label.isHidden = viewProperties.textIsHidden
        additionalLabel.attributedText = viewProperties.additionalText
        additionalLabel.isHidden = viewProperties.additionalTextIsHidden
    }
    
    private func updateView(with viewProperties: ViewProperties) {
        addSubview(hStack)
        hStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(
                top: 4, left: 0, bottom: 4, right: 0))
        }
        snp.makeConstraints {
            $0.height.equalToSuperview().offset(viewProperties.minHeight)
        }
    }
    
    private func removeConstraintsAndSubviews() {
        self.subviews.forEach { subview in
            subview.snp.removeConstraints()
            subview.removeFromSuperview()
        }
    }
}
