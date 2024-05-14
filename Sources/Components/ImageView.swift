import UIKit
import SnapKit

public class ImageView: UIView {
    
    public struct ViewProperties {
        public var size: CGSize
        public var backgroundColor: UIColor
        public var cornerRadius: CGFloat
        public var text: NSMutableAttributedString?
        public var image: UIImage?
        
        public init(
            size: CGSize = .zero,
            backgroundColor: UIColor = .clear,
            cornerRadius: CGFloat = 0,
            text: NSMutableAttributedString? = nil,
            image: UIImage? = nil
        ) {
            self.size = size
            self.backgroundColor = backgroundColor
            self.cornerRadius = cornerRadius
            self.text = text
            self.image = image
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byClipping
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
        }
        
        addSubview(imageView)
        imageView.snp.makeConstraints() {
            $0.edges.equalToSuperview()
        }
        
        snp.makeConstraints {
            $0.size.equalTo(0) // будет обновлено
        }
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    public func update(with viewProperties: ViewProperties) {
        updateSize(with: viewProperties)
        updateBackground(with: viewProperties)
        updateText(with: viewProperties)
        updateImage(with: viewProperties)
        self.viewProperties = viewProperties
    }
    
    private func updateSize(with viewProperties: ViewProperties) {
        guard self.viewProperties.size != viewProperties.size else { return }
        snp.updateConstraints { $0.size.equalTo(viewProperties.size) }
    }
    
    private func updateBackground(with viewProperties: ViewProperties) {
        backgroundColor = viewProperties.backgroundColor
        layer.cornerRadius = viewProperties.cornerRadius
        clipsToBounds = true
    }
    
    private func updateText(with viewProperties: ViewProperties) {
        titleLabel.attributedText = viewProperties.text
    }
    
    private func updateImage(with viewProperties: ViewProperties) {
        imageView.image = viewProperties.image
    }
}
