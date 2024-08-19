import UIKit
import SnapKit

public final class TileView: UIView, ComponentProtocol {
    
    // MARK: - ViewProperties
    
    public struct ViewProperties {
        public var imageViewProperties: ImageView.ViewProperties
        public var text: NSMutableAttributedString
        public var backgroundColor: UIColor
        public var cornerRadius: CGFloat
        public var margins: Margins
        public var numberOfLines: Int
        public var onTap: () -> Void
        
        public init(
            imageViewProperties: ImageView.ViewProperties = .init(),
            text: NSMutableAttributedString = .init(string: ""),
            backgroundColor: UIColor = .clear,
            cornerRadius: CGFloat = 0,
            margins: Margins = .init(),
            numberOfLines: Int = 0,
            onTap: @escaping () -> Void = { }
        ) {
            self.imageViewProperties = imageViewProperties
            self.text = text
            self.backgroundColor = backgroundColor
            self.cornerRadius = cornerRadius
            self.margins = margins
            self.numberOfLines = numberOfLines
            self.onTap = onTap
        }
        
        public struct Margins {
            public var imageTop: CGFloat
            public var labelTop: CGFloat
            public var labelBottom: CGFloat
            public var labelLeading: CGFloat
            public var labelTrailing: CGFloat
            public var width: CGFloat
            
            public init(
                imageTop: CGFloat = 0,
                labelTop: CGFloat = 0,
                labelBottom: CGFloat = 0,
                labelLeading: CGFloat = 0,
                labelTrailing: CGFloat = 0,
                width: CGFloat = 0
            ) {
                self.imageTop = imageTop
                self.labelTop = labelTop
                self.labelBottom = labelBottom
                self.labelLeading = labelLeading
                self.labelTrailing = labelTrailing
                self.width = width
            }
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - UI
    
    private let imageView = ImageView()
    
    private let textLabel = UILabel()
    
    // MARK: - init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    public func update(with viewProperties: ViewProperties) {
        DispatchQueue.main.async {
            self.viewProperties = viewProperties
            self.textLabel.attributedText = viewProperties.text
            self.textLabel.numberOfLines = viewProperties.numberOfLines
            self.textLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            self.setBackgroundColor(with: viewProperties)
            self.setCornerRadius(with: viewProperties)
            self.updateImageView(with: viewProperties)
            self.updateConstraints(with: viewProperties)
        }
    }
    
    // MARK: - private methods
    
    private func updateConstraints(with viewProperties: ViewProperties) {
        removeConstraintsAndSubviews()
        setupWidthView(with: viewProperties)
        setupImageView(with: viewProperties)
        setupLabel(with: viewProperties)
        setupGestureRecognizer()
    }
    
    // TODO: Костыль, заменить на $0.width.equalTo(viewProperties.margins.width)
    // Когда обновится подход к таблице (обновление по новой архитектуре)
    private func setupWidthView(with viewProperties: ViewProperties) {
        let view = UIView()
        view.backgroundColor = .clear
        addSubview(view)
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(viewProperties.margins.width)
        }
    }
    
    private func setupImageView(with viewProperties: ViewProperties) {
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(viewProperties.margins.imageTop)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func setupLabel(with viewProperties: ViewProperties) {
        addSubview(textLabel)
        textLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(viewProperties.margins.labelTop)
            $0.leading.equalToSuperview().offset(viewProperties.margins.labelLeading)
            $0.trailing.equalToSuperview().offset(-viewProperties.margins.labelTrailing)
            $0.bottom.equalToSuperview().offset(-viewProperties.margins.labelBottom)
        }
    }
    
    private func removeConstraintsAndSubviews() {
        self.subviews.forEach { subview in
            subview.snp.removeConstraints()
            subview.removeFromSuperview()
        }
    }
    
    private func setBackgroundColor(with viewProperties: ViewProperties) {
        backgroundColor = viewProperties.backgroundColor
    }
    
    private func updateImageView(with viewProperties: ViewProperties) {
        imageView.update(with: viewProperties.imageViewProperties)
    }
    
    private func setCornerRadius(with viewProperties: ViewProperties) {
        cornerRadius(
            radius: viewProperties.cornerRadius,
            direction: .allCorners,
            clipsToBounds: true
        )
    }
    
    private func setupGestureRecognizer() {
        let gr = UITapGestureRecognizer(target: self, action: #selector(tapped))
        addGestureRecognizer(gr)
    }
    
    @objc
    private func tapped() {
        viewProperties.onTap()
    }
}
