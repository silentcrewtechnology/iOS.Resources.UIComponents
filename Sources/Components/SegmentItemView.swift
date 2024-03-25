import UIKit
import SnapKit

public class SegmentItemView: UIView {
    
    public struct ViewProperties {
        public var text: NSMutableAttributedString
        public var divider: DividerView.ViewProperties
        
        public init(
            text: NSMutableAttributedString = .init(string: ""),
            divider: DividerView.ViewProperties = .init()
        ) {
            self.text = text
            self.divider = divider
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let dividerView: DividerView = {
        let view = DividerView()
        return view
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupView() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.greaterThanOrEqualToSuperview().inset(8)
            $0.trailing.lessThanOrEqualToSuperview().inset(8)
            $0.center.equalToSuperview()
        }
        addSubview(dividerView)
        dividerView.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
        }
    }
    
    public func update(with viewProperties: ViewProperties) {
        titleLabel.attributedText = viewProperties.text
        dividerView.update(with: viewProperties.divider)
        self.viewProperties = viewProperties
    }
}
