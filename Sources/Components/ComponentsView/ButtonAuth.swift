import UIKit
import SnapKit

public final class ButtonAuth: UIButton, ComponentProtocol {
    
    // MARK: - ViewProperties
    
    public struct ViewProperties {
        public var image: UIImage
        public var title: NSMutableAttributedString
        public var backgroundColor: UIColor
        public var spacing: CGFloat
        public var cornerRadius: CGFloat
        public var height: CGFloat
        public var onTap: () -> Void
        
        public init(
            image: UIImage = .init(),
            title: NSMutableAttributedString = .init(string: ""),
            backgroundColor: UIColor = .clear,
            spacing: CGFloat = .zero,
            cornerRadius: CGFloat = 0,
            height: CGFloat = 0,
            onTap: @escaping () -> Void = { }
        ) {
            self.image = image
            self.title = title
            self.backgroundColor = backgroundColor
            self.spacing = spacing
            self.cornerRadius = cornerRadius
            self.height = height
            self.onTap = onTap
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
        updateImage(image: viewProperties.image)
        updateTitle(title: viewProperties.title)
        updateInsets(spacing: viewProperties.spacing)
        updateCornerRadius(with: viewProperties)
        updateHeight(with: viewProperties)
        backgroundColor = viewProperties.backgroundColor
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    // MARK: - private methods

    private func updateImage(image: UIImage) {
        setImage(image, for: .normal)
        setImage(image, for: .highlighted)
    }
    
    private func updateTitle(title: NSMutableAttributedString) {
        setAttributedTitle(title, for: .normal)
        setAttributedTitle(title, for: .highlighted)
    }
    
    private func updateInsets(spacing: CGFloat) {
        let halfSpacing = spacing / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -halfSpacing, bottom: 0, right: halfSpacing)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: halfSpacing, bottom: 0, right: -halfSpacing)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: halfSpacing, bottom: 0, right: halfSpacing)
    }
    
    @objc private func buttonTapped() {
        viewProperties.onTap()
    }
    
    private func updateCornerRadius(with viewProperties: ViewProperties) {
        cornerRadius(
            radius: viewProperties.cornerRadius,
            direction: .allCorners,
            clipsToBounds: true
        )
    }
    
    private func updateHeight(with viewProperties: ViewProperties) {
        snp.makeConstraints {
            $0.height.equalTo(viewProperties.height)
        }
    }
}
