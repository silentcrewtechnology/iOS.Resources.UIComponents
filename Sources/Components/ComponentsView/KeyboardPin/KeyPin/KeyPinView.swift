import UIKit
import SnapKit

public final class KeyPinView: PressableView, ComponentProtocol {
    
    public struct ViewProperties {
        public var size: CGSize
        public var backgroundColor: UIColor
        public var cornerRadius: CGFloat
        public var digit: NSMutableAttributedString
        public var borderColor: UIColor
        public var borderWidth: CGFloat
        public var onPressChange: (State) -> Void
        
        public init(
            size: CGSize = .zero,
            backgroundColor: UIColor = .clear,
            cornerRadius: CGFloat = 0,
            digit: NSMutableAttributedString = .init(string: ""),
            borderColor: UIColor = .clear,
            borderWidth: CGFloat = 0,
            onPressChange: @escaping (State) -> Void = { _ in }
        ) {
            self.size = size
            self.backgroundColor = backgroundColor
            self.cornerRadius = cornerRadius
            self.digit = digit
            self.borderColor = borderColor
            self.borderWidth = borderWidth
            self.onPressChange = onPressChange
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    private let digitLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupView() {
        layer.masksToBounds = true
        snp.makeConstraints { $0.size.equalTo(0) }
        addSubview(digitLabel)
        digitLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    public func update(with viewProperties: ViewProperties) {
        updateBorder(with: viewProperties)
        updateSize(with: viewProperties)
        digitLabel.attributedText = viewProperties.digit
        UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve) { [self] in
            backgroundColor = viewProperties.backgroundColor
        }
        self.viewProperties = viewProperties
    }
    
    private func updateSize(with viewProperties: ViewProperties) {
        guard self.viewProperties.size != viewProperties.size else { return }
        snp.updateConstraints {
            $0.size.equalTo(viewProperties.size)
        }
    }
    
    private func updateBorder(with viewProperties: ViewProperties) {
        layer.cornerRadius = viewProperties.cornerRadius
        layer.borderColor = viewProperties.borderColor.cgColor
        layer.borderWidth = viewProperties.borderWidth
    }
    
    public override func handlePress(state: State) {
        viewProperties.onPressChange(state)
    }
}
