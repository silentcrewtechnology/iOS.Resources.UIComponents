import UIKit
import SnapKit

@available(*, deprecated, message: "Use HintView")
public final class OldHintView: UIView {
    
    public struct ViewProperties {
        public var leftText: NSMutableAttributedString?
        public var rightText: NSMutableAttributedString?
        public var minHeight: CGFloat
        
        public init(
            leftText: NSMutableAttributedString? = nil,
            rightText: NSMutableAttributedString? = nil,
            minHeight: CGFloat = 0
        ) {
            self.leftText = leftText
            self.rightText = rightText
            self.minHeight = minHeight
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    private lazy var hStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            leftLabel,
            rightLabel
        ])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .top
        return stack
    }()
    
    private let leftLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let rightLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.defaultHigh + 1, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
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
            $0.edges.equalToSuperview().inset(UIEdgeInsets(
                top: 4, left: 0, bottom: 4, right: 0))
        }
        snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(0) // будет обновлено
        }
    }
    
    public func update(with viewProperties: ViewProperties) {
        updateLabels(with: viewProperties)
        updateMinHeight(minHeight: viewProperties.minHeight)
        self.viewProperties = viewProperties
    }
    
    private func updateLabels(with viewProperties: ViewProperties) {
        leftLabel.attributedText = viewProperties.leftText
        leftLabel.isHidden = viewProperties.leftText == nil
        rightLabel.attributedText = viewProperties.rightText
        rightLabel.isHidden = viewProperties.rightText == nil
    }
    
    private func updateMinHeight(minHeight: CGFloat) {
        guard self.viewProperties.minHeight != minHeight else { return }
        snp.updateConstraints {
            $0.height.greaterThanOrEqualTo(minHeight)
        }
    }
}
