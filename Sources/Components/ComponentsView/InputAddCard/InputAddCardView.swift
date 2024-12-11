import UIKit
import SnapKit

public final class InputAddCardView: UIView, ComponentProtocol {
    
    public struct ViewProperties {
        public var cardView: UIView
        public var numberHintedField: UIView
        public var buttonIcon: UIView?
        public var dateHintedField: UIView
        public var margins: Margins
        public var isUserInteractionEnabled: Bool
        
        public init(
            cardView: UIView = .init(),
            numberHintedField: UIView = .init(),
            buttonIcon: UIView? = nil,
            dateHintedField: UIView = .init(),
            margins: Margins = .init(),
            isUserInteractionEnabled: Bool = true
        ) {
            self.cardView = cardView
            self.numberHintedField = numberHintedField
            self.buttonIcon = buttonIcon
            self.dateHintedField = dateHintedField
            self.margins = margins
            self.isUserInteractionEnabled = isUserInteractionEnabled
        }
        
        public struct Margins {
            public var cardRowInsets: UIEdgeInsets
            public var spacing: CGFloat
            
            public init(
                cardRowInsets: UIEdgeInsets = .zero,
                spacing: CGFloat = 0
            ) {
                self.cardRowInsets = cardRowInsets
                self.spacing = spacing
            }
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    private let vStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        return stack
    }()
    
    private let hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        return stack
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    public func update(with viewProperties: ViewProperties) {
        setupHBlock(with: viewProperties)
        setupVBlock(with: viewProperties)
        isUserInteractionEnabled = viewProperties.isUserInteractionEnabled
        self.viewProperties = viewProperties
    }
    
    private func setupHBlock(with viewProperties: ViewProperties) {
        hStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        hStack.spacing = viewProperties.margins.spacing
        hStack.addArrangedSubview(viewProperties.cardView)
        hStack.addArrangedSubview(viewProperties.numberHintedField)
        if let buttonIcon = viewProperties.buttonIcon {
            hStack.addArrangedSubview(buttonIcon)
        }
        hStack.layoutMargins = viewProperties.margins.cardRowInsets
        hStack.isLayoutMarginsRelativeArrangement = true
    }
    
    private func setupVBlock(with viewProperties: ViewProperties) {
        vStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        vStack.addArrangedSubview(hStack)
        vStack.addArrangedSubview(viewProperties.dateHintedField)
    }
    
    private func setupView() {
        addSubview(vStack)
        vStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
