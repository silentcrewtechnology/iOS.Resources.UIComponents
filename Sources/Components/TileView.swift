import UIKit
import SnapKit

public final class TileView: UIView {
    
    public struct ViewProperties {
        public var icon: UIImage
        public var text: NSMutableAttributedString
        public var backgroundColor: UIColor
        public var width: CGFloat
        public var cornerRadius: CGFloat
        public var textWidth: CGFloat
        public var action: () -> Void
        
        public init(
            icon: UIImage = .init(),
            text: NSMutableAttributedString = .init(string: ""),
            backgroundColor: UIColor = .clear,
            width: CGFloat = .zero,
            cornerRadius: CGFloat = .zero,
            textWidth: CGFloat = .zero,
            action: @escaping () -> Void = { }
        ) {
            self.icon = icon
            self.text = text
            self.backgroundColor = backgroundColor
            self.width = width
            self.cornerRadius = cornerRadius
            self.textWidth = textWidth
            self.action = action
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    private let iconView: UIImageView = {
        let view = UIImageView()
            .circled(diameter: 48)
        view.contentMode = .center
        return view
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    public func update(with viewProperties: ViewProperties) {
        textLabel.attributedText = viewProperties.text
        setupSizeConstraints(with: viewProperties)
        backgroundColor = viewProperties.backgroundColor
        layer.cornerRadius = viewProperties.cornerRadius
        iconView.image = viewProperties.icon
        self.viewProperties = viewProperties
    }
    
    private func setupView() {
        snp.makeConstraints {
            $0.width.equalTo(0) // будет обновлён
        }
        addSubview(iconView)
        iconView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.centerX.equalToSuperview()
        }
        addSubview(textLabel)
        textLabel.snp.makeConstraints {
            $0.top.equalTo(iconView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview().inset(16)
            $0.width.equalTo(0) // будет обновлён
        }
        setupGestureRecognizer()
    }
    
    private func setupGestureRecognizer() {
        let gr = UITapGestureRecognizer(target: self, action: #selector(tapped))
        addGestureRecognizer(gr)
    }
    
    private func setupSizeConstraints(
        with viewProperties: ViewProperties
    ) {
        guard
            self.viewProperties.width != viewProperties.width,
            self.viewProperties.textWidth != viewProperties.textWidth
        else { return }
        snp.updateConstraints {
            $0.width.equalTo(viewProperties.width)
        }
        textLabel.snp.updateConstraints {
            $0.width.equalTo(viewProperties.textWidth)
        }
    }
    
    @objc
    private func tapped() {
        viewProperties.action()
    }
}
