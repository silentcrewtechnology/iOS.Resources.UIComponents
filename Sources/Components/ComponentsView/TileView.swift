import UIKit
import SnapKit

public final class TileView: PressableView, ComponentProtocol {
    
    // MARK: - Properties
    
    public struct ViewProperties {
        public var imageView: UIView
        public var text: NSMutableAttributedString
        public var backgroundColor: UIColor
        public var cornerRadius: CGFloat
        public var imageCornerRadius: CGFloat
        public var insets: UIEdgeInsets
        public var imageInsets: UIEdgeInsets
        public var textInsets: UIEdgeInsets
        public var imageSize: CGSize
        public var size: CGSize
        public var shouldUseImageSize: Bool
        public var isFloatingHeight: Bool
        public var onTap: (() -> Void)?
        
        public init(
            imageView: UIView = .init(),
            text: NSMutableAttributedString = .init(string: ""),
            backgroundColor: UIColor = .clear,
            cornerRadius: CGFloat = .zero,
            imageCornerRadius: CGFloat = .zero,
            insets: UIEdgeInsets = .zero,
            imageInsets: UIEdgeInsets = .zero,
            textInsets: UIEdgeInsets = .zero,
            imageSize: CGSize = .zero,
            size: CGSize = .zero,
            shouldUseImageSize: Bool = false,
            isFloatingHeight: Bool = false,
            onTap: (() -> Void)? = nil
        ) {
            self.imageView = imageView
            self.text = text
            self.backgroundColor = backgroundColor
            self.cornerRadius = cornerRadius
            self.imageCornerRadius = imageCornerRadius
            self.insets = insets
            self.imageInsets = imageInsets
            self.textInsets = textInsets
            self.imageSize = imageSize
            self.size = size
            self.shouldUseImageSize = shouldUseImageSize
            self.isFloatingHeight = isFloatingHeight
            self.onTap = onTap
        }
    }
    
    // MARK: - Private properties
    
    private var viewProperties: ViewProperties = .init()

    private lazy var textLabel = UILabel()
    
    // MARK: - Methods

    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
        
        setupView(with: viewProperties)
        setupImageView(with: viewProperties)
        setupLabelView(with: viewProperties)
    }
    
    public override func handlePress(state: PressableView.State) {
        if state == .unpressed { viewProperties.onTap?() }
    }
    
    // MARK: - private methods
    
    private func setupView(with viewProperties: ViewProperties) {
        removeSubviewsAndConstraints()
        
        backgroundColor = viewProperties.backgroundColor
        cornerRadius(
            radius: viewProperties.cornerRadius,
            direction: .allCorners,
            clipsToBounds: true
        )
        snp.makeConstraints {
            $0.width.equalTo(viewProperties.size.width)
            if viewProperties.isFloatingHeight {
                $0.height.greaterThanOrEqualTo(viewProperties.size.height)
            } else {
                $0.height.equalTo(viewProperties.size.height)
            }
        }
    }
    
    private func setupLabelView(with viewProperties: ViewProperties) {
        addSubview(textLabel)
        textLabel.attributedText = viewProperties.text
        textLabel.lineBreakMode = .byTruncatingTail
        textLabel.numberOfLines = .zero
        textLabel.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview().inset(viewProperties.textInsets)
            $0.top.equalTo(viewProperties.imageView.snp.bottom).inset(-viewProperties.textInsets.top)
        }
    }
    
    private func setupImageView(with viewProperties: ViewProperties) {
        addSubview(viewProperties.imageView)
        viewProperties.imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(viewProperties.imageInsets)
        }
        
        if viewProperties.shouldUseImageSize {
            viewProperties.imageView.cornerRadius(
                radius: viewProperties.imageCornerRadius,
                direction: .allCorners,
                clipsToBounds: true
            )
            viewProperties.imageView.snp.makeConstraints {
                $0.size.equalTo(viewProperties.imageSize)
            }
        }
    }
    
    private func removeSubviewsAndConstraints() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
        snp.removeConstraints()
    }
}
