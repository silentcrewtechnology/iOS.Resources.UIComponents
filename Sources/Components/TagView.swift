import UIKit
import SnapKit

public class TagView: UIView {
    
    public struct ViewProperties {
        public var backgroundColor: UIColor
        public var text: NSMutableAttributedString
        public var cornerRadius: CGFloat
        public var insets: UIEdgeInsets
        
        public init(
            backgroundColor: UIColor = .clear,
            text: NSMutableAttributedString = .init(string: ""),
            cornerRadius: CGFloat = .zero,
            insets: UIEdgeInsets = .zero
        ) {
            self.backgroundColor = backgroundColor
            self.text = text
            self.cornerRadius = cornerRadius
            self.insets = insets
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
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
        addSubview(textLabel)
        textLabel.snp.makeConstraints {
            $0.edges.equalToSuperview() // будет обновлено
        }
    }
    
    public func update(with viewProperties: ViewProperties) {
        backgroundColor = viewProperties.backgroundColor
        textLabel.attributedText = viewProperties.text
        layer.cornerRadius = viewProperties.cornerRadius
        updateInsets(with: viewProperties)
        self.viewProperties = viewProperties
    }
    
    private func updateInsets(with viewProperties: ViewProperties) {
        guard self.viewProperties.insets != viewProperties.insets else { return }
        textLabel.snp.updateConstraints {
            $0.edges.equalToSuperview().inset(viewProperties.insets)
        }
    }
}
