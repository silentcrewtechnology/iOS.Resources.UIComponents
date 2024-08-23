import UIKit
import SnapKit

public final class HintView: UIView {
    
    public struct ViewProperties {
        public var margins: Margins
        public var text: NSMutableAttributedString?
        public var textIsHidden: Bool
        public var additionalText: NSMutableAttributedString?
        public var additionalTextIsHidden: Bool
        
        public struct Margins {
            public var top: CGFloat
            public var trailing: CGFloat
            public var leading: CGFloat
            public var bottom: CGFloat
            public var spacing: CGFloat
            
            public init(top: CGFloat = 0,
                        trailing: CGFloat = 0,
                        leading: CGFloat = 0,
                        bottom: CGFloat = 0,
                        spacing: CGFloat = 0
            ) {
                self.top = top
                self.trailing = trailing
                self.leading = leading
                self.bottom = bottom
                self.spacing = spacing
            }
        }
        
        public init(
            margins: Margins = .init(),
            text: NSMutableAttributedString? = nil,
            textIsHidden: Bool = false,
            additionalText: NSMutableAttributedString? = nil,
            additionalTextIsHidden: Bool = false
        ) {
            self.margins = margins
            self.text = text
            self.textIsHidden = textIsHidden
            self.additionalText = additionalText
            self.additionalTextIsHidden = additionalTextIsHidden
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    private var containerView = UIView()
    
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
        self.viewProperties = viewProperties
        updateConstraint(with: viewProperties)
        updateLabels(with: viewProperties)
    }
    
    private func updateLabels(with viewProperties: ViewProperties) {
        label.attributedText = viewProperties.text
        additionalLabel.attributedText = viewProperties.additionalText
    }
    
    private func updateConstraint(with viewProperties: ViewProperties) {
        removeConstraintsAndSubviews()
        addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        setupLabelIfNeeded(with: viewProperties)
        setupAdditionalLabelIfNeeded(with: viewProperties)
    }
    
    private func removeConstraintsAndSubviews() {
        containerView.subviews.forEach { subview in
            subview.snp.removeConstraints()
            subview.removeFromSuperview()
        }
        containerView.snp.removeConstraints()
        containerView.removeFromSuperview()
    }
    
    private func setupLabelIfNeeded(with viewProperties: ViewProperties) {
        if !viewProperties.textIsHidden {
            containerView.addSubview(label)
            label.snp.makeConstraints {
                $0.top.equalToSuperview().offset(viewProperties.margins.top)
                $0.leading.equalToSuperview().offset(viewProperties.margins.leading)
                $0.bottom.equalToSuperview().offset(-viewProperties.margins.bottom)
            }
            
            if viewProperties.additionalTextIsHidden {
                label.snp.makeConstraints {
                    $0.trailing.equalToSuperview().offset(-viewProperties.margins.trailing)
                }
            }
        }
    }
    private func setupAdditionalLabelIfNeeded(with viewProperties: ViewProperties) {
        if !viewProperties.additionalTextIsHidden {
            containerView.addSubview(additionalLabel)
            additionalLabel.snp.makeConstraints {
                $0.top.equalToSuperview().offset(viewProperties.margins.top)
                $0.leading.greaterThanOrEqualTo(label.snp.trailing).offset(viewProperties.margins.spacing)
                $0.trailing.equalToSuperview().offset(-viewProperties.margins.trailing)
                $0.bottom.equalToSuperview().offset(-viewProperties.margins.bottom)
            }
        }
    }
}
