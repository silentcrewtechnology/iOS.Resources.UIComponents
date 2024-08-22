import UIKit
import SnapKit

public class LabelView: UIView, ComponentProtocol {
    
    // MARK: - ViewProperties
    
    public struct ViewProperties {
        public var text: NSMutableAttributedString
        public var size: Size
        public var accessibilityIds: AccessibilityIds?
        public var longPressGestureRecognizer: UILongPressGestureRecognizer?
        
        public struct Size: Equatable {
            public var inset: UIEdgeInsets
            public var lineHeight: CGFloat
            
            public init(
                inset: UIEdgeInsets = .zero,
                lineHeight: CGFloat = .zero
            ) {
                self.inset = inset
                self.lineHeight = lineHeight
            }
        }
        
        public struct AccessibilityIds {
            public var id: String
            public var labelViewId: String
            
            public init(id: String, labelViewId: String) {
                self.id = id
                self.labelViewId = labelViewId
            }
        }
        
        public init(
            text: NSMutableAttributedString = .init(string: ""),
            size: Size = .init(),
            accessibilityIds: AccessibilityIds? = nil,
            longPressGestureRecognizer: UILongPressGestureRecognizer? = nil
        ) {
            self.text = text
            self.size = size
            self.longPressGestureRecognizer = longPressGestureRecognizer
            self.accessibilityIds = accessibilityIds
        }
    }
    
    // MARK: - Properties
    
    public override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - Private properties
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        
        return label
    }()
    private var container = UIView()
    
    private lazy var longPressGesture = UILongPressGestureRecognizer()
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - Public methods
    
    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
        
        self.setupView(size: viewProperties.size)
        self.updateLabel(with: viewProperties.text)
        self.setupAccessibilityIds(with: viewProperties.accessibilityIds)
        
        if let longPressGestureRecognizer = viewProperties.longPressGestureRecognizer {
            self.addGestureRecognizer(longPressGestureRecognizer)
            self.longPressGesture = longPressGestureRecognizer
        } else {
            self.removeGestureRecognizer(self.longPressGesture)
        }
    }
    
    // MARK: - Private methods
    
    private func setupView(size: ViewProperties.Size) {
        removeConstraintsAndSubviews()
        addSubview(container)
        container.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        container.addSubview(textLabel)
        textLabel.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(size.lineHeight)
            $0.edges.equalToSuperview().inset(size.inset)
        }
    }
    
    private func updateLabel(with text: NSMutableAttributedString?) {
        textLabel.attributedText = text
        textLabel.isHidden = text == nil
    }
    
    private func removeConstraintsAndSubviews() {
        subviews.forEach { subview in
            subview.snp.removeConstraints()
            subview.removeFromSuperview()
        }
    }
    
    private func setupAccessibilityIds(with accessibilityIds: ViewProperties.AccessibilityIds?) {
        isAccessibilityElement = true
        accessibilityIdentifier = accessibilityIds?.id
        textLabel.accessibilityIdentifier = accessibilityIds?.labelViewId
    }
}
