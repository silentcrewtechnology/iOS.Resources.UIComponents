import UIKit
import SnapKit

public class TagView: UIView {
    
    public typealias TapView = TapInsetView<UIImageView>
    
    public struct ViewProperties {
        public var height: CGFloat
        public var backgroundColor: UIColor
        public var cornerRadius: CGFloat
        public var leftProperties: TapView.ViewProperties?
        public var text: NSMutableAttributedString
        public var rightProperties: TapView.ViewProperties?
        public var insets: UIEdgeInsets
        
        public init(
            height: CGFloat = .zero,
            backgroundColor: UIColor = .clear,
            cornerRadius: CGFloat = .zero,
            leftProperties: TapView.ViewProperties? = nil,
            text: NSMutableAttributedString = .init(string: ""),
            rightProperties: TapView.ViewProperties? = nil,
            insets: UIEdgeInsets = .zero
        ) {
            self.height = height
            self.backgroundColor = backgroundColor
            self.cornerRadius = cornerRadius
            self.leftProperties = leftProperties
            self.text = text
            self.rightProperties = rightProperties
            self.insets = insets
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    private lazy var hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        return stack
    }()
    
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
        snp.makeConstraints { $0.height.equalTo(0) } // будет обновлено
        addSubview(hStack)
        hStack.snp.makeConstraints { $0.edges.equalToSuperview() } // будет обновлено
    }
    
    public func update(with viewProperties: ViewProperties) {
        backgroundColor = viewProperties.backgroundColor
        layer.cornerRadius = viewProperties.cornerRadius
        textLabel.attributedText = viewProperties.text
        updateHeight(height: viewProperties.height)
        updateStack(with: viewProperties)
        self.viewProperties = viewProperties
    }
    
    private func updateHeight(height: CGFloat) {
        guard self.viewProperties.height != height else { return }
        snp.updateConstraints { $0.height.equalTo(height) }
    }
    
    private func updateStack(with viewProperties: ViewProperties) {
        hStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        if let leftProperties = viewProperties.leftProperties {
            hStack.addArrangedSubview(tappableView(with: leftProperties))
        }
        hStack.addArrangedSubview(textLabel)
        if let rightProperties = viewProperties.rightProperties {
            hStack.addArrangedSubview(tappableView(with: rightProperties))
        }
        hStack.snp.updateConstraints {
            $0.edges.equalToSuperview().inset(viewProperties.insets)
        }
    }
    
    private func tappableView(
        with viewProperties: TapView.ViewProperties
    ) -> TapView {
        let view = TapView()
        view.update(with: viewProperties)
        return view
    }
}
