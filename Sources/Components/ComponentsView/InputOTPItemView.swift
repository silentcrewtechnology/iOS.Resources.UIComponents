import UIKit
import SnapKit

public class InputOTPItemView: UIView, ComponentProtocol {
    
    public struct ViewProperties {
        public var backgroundColor: UIColor
        public var size: CGSize
        public var cornerRadius: CGFloat
        public var text: NSMutableAttributedString
        public var borderColor: UIColor
        public var borderWidth: CGFloat
        
        public init(
            backgroundColor: UIColor = .clear,
            size: CGSize = .zero,
            cornerRadius: CGFloat = 0,
            text: NSMutableAttributedString = .init(string: ""),
            borderColor: UIColor = .clear,
            borderWidth: CGFloat = 0
        ) {
            self.backgroundColor = backgroundColor
            self.size = size
            self.cornerRadius = cornerRadius
            self.text = text
            self.borderColor = borderColor
            self.borderWidth = borderWidth
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupView() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { $0.center.equalToSuperview() }
        snp.makeConstraints { $0.size.equalTo(0) } // будет обновлено
    }
    
    public func update(with viewProperties: ViewProperties) {
        updateBackground(with: viewProperties)
        titleLabel.attributedText = viewProperties.text
        updateBorder(with: viewProperties)
        updateSize(size: viewProperties.size)
        self.viewProperties = viewProperties
    }
    
    public func updateBackground(with viewProperties: ViewProperties) {
        backgroundColor = viewProperties.backgroundColor
        layer.cornerRadius = viewProperties.cornerRadius
    }
    
    public func updateBorder(with viewProperties: ViewProperties) {
        layer.borderColor = viewProperties.borderColor.cgColor
        layer.borderWidth = viewProperties.borderWidth
    }
    
    private func updateSize(size: CGSize) {
        guard self.viewProperties.size != size else { return }
        snp.updateConstraints { $0.size.equalTo(size) }
    }
}
