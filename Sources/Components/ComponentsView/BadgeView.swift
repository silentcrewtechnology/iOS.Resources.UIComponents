import UIKit
import SnapKit

public final class BadgeView: UIView, ComponentProtocol {
    
    // MARK: - ViewProperties
    
    public struct ViewProperties {
        public var isTextHidden: Bool
        public var isImageHidden: Bool
        public var text: NSMutableAttributedString?
        public var backgroundColor: UIColor?
        public var textColor: UIColor?
        public var image: UIImage?
        public var cornerRadius: CGFloat
        public var textAlignment: NSTextAlignment
        public var margins: Margins
        
        public struct Margins {
            public var imageTop: CGFloat
            public var imageBottom: CGFloat
            public var leading: CGFloat
            public var trailing: CGFloat
            public var top: CGFloat
            public var bottom: CGFloat
            public var spacing: CGFloat
            public var height: CGFloat
            
            public init(
                imageTop: CGFloat = 0,
                imageBottom: CGFloat = 0,
                leading: CGFloat = 0,
                trailing: CGFloat = 0,
                top: CGFloat = 0,
                bottom: CGFloat = 0,
                spacing: CGFloat = 0,
                height: CGFloat = 0
            ) {
                self.imageTop = imageTop
                self.imageBottom = imageBottom
                self.leading = leading
                self.trailing = trailing
                self.top = top
                self.bottom = bottom
                self.spacing = spacing
                self.height = height
            }
        }
        
        public init(
            isTextHidden: Bool = false,
            isImageHidden: Bool = false,
            text: NSMutableAttributedString? = nil,
            backgroundColor: UIColor? = nil,
            textColor: UIColor? = nil,
            image: UIImage? = nil,
            height: CGFloat = 0,
            width: CGFloat = 0,
            cornerRadius: CGFloat = 0,
            textAlignment: NSTextAlignment = .center,
            margins: Margins = .init()
        ) {
            self.isTextHidden = isTextHidden
            self.isImageHidden = isImageHidden
            self.text = text
            self.backgroundColor = backgroundColor
            self.textColor = textColor
            self.image = image
            self.cornerRadius = cornerRadius
            self.textAlignment = textAlignment
            self.margins = margins
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - UI
    
    private lazy var containerView = UIView()
    private lazy var titleLabel = UILabel()
    private lazy var imageView = UIImageView()
    
    // MARK: - init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - public methods
    
    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
        
        setText(with: viewProperties)
        setBackgroundColor(with: viewProperties)
        setImage(with: viewProperties)
        setCornerRadius(with: viewProperties)
        updateConstraints(with: viewProperties)
    }
    
    // MARK: - private methods
    
    private func setText(with viewProperties: ViewProperties) {
        titleLabel.attributedText = viewProperties.text
        titleLabel.textAlignment = viewProperties.textAlignment
        titleLabel.textColor = viewProperties.textColor
    }
    
    private func setBackgroundColor(with viewProperties: ViewProperties) {
        backgroundColor = viewProperties.backgroundColor
    }
    
    private func setImage(with viewProperties: ViewProperties) {
        imageView.image = viewProperties.image
    }
    
    private func setCornerRadius(with viewProperties: ViewProperties) {
        cornerRadius(
            radius: viewProperties.cornerRadius,
            direction: .allCorners,
            clipsToBounds: true
        )
    }
    
    private func updateConstraints(with viewProperties: ViewProperties) {
        removeConstraintsAndSubviews()
        
        addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(viewProperties.margins.height)
        }
        
        if viewProperties.isImageHidden && viewProperties.isTextHidden {
            setupSimpleView()
        } else if viewProperties.isImageHidden && !viewProperties.isTextHidden {
            setupBasicView()
        } else {
            setupFullView()
        }
    }
    
    private func setupSimpleView() {
        containerView.snp.makeConstraints {
            $0.width.equalTo(viewProperties.margins.height)
        }
    }
    
    private func setupBasicView() {
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(viewProperties.margins.leading)
            $0.trailing.equalToSuperview().offset(-viewProperties.margins.trailing)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setupFullView() {
        containerView.addSubview(imageView)
        imageView.snp.makeConstraints() {
            $0.top.equalToSuperview().offset(viewProperties.margins.imageTop)
            $0.leading.equalToSuperview().offset(viewProperties.margins.leading)
            $0.bottom.equalToSuperview().offset(-viewProperties.margins.imageBottom)
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(viewProperties.margins.top)
            $0.leading.equalTo(imageView.snp.trailing).offset(viewProperties.margins.spacing)
            $0.trailing.equalToSuperview().offset(-viewProperties.margins.trailing)
            $0.bottom.equalToSuperview().offset(-viewProperties.margins.bottom)
        }
    }
    
    private func removeConstraintsAndSubviews() {
        containerView.subviews.forEach { subview in
            subview.snp.removeConstraints()
            subview.removeFromSuperview()
        }
        containerView.snp.removeConstraints()
        containerView.removeFromSuperview()
    }
}
