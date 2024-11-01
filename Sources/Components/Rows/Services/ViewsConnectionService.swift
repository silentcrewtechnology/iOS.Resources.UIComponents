import UIKit
import SnapKit
import AccessibilityIds

public struct ViewsConnectionService {
    
    // MARK: - Life cycle
    
    public init() { }
    
    // MARK: - Methods
    
    public func connect(topView: UIView, bottomView: UIView) -> UIView {
        let stackView = UIStackView(arrangedSubviews: [topView, bottomView])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.isAccessibilityElement = true
        stackView.accessibilityIdentifier = DesignSystemAccessibilityIDs.RowView.verticalStack
        return stackView
    }
    
    public func connect(leftView: UIView, rightView: UIView, spacing: Int = .zero) -> UIView {
        let stackView = UIStackView(arrangedSubviews: [leftView, rightView])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = CGFloat(spacing)
        stackView.isAccessibilityElement = true
        stackView.accessibilityIdentifier = DesignSystemAccessibilityIDs.RowView.horizontalStack
        return stackView
    }
    
    public func connect(horizontalyViews: [UIView], spacing: CGFloat = 0) -> UIView {
        let stackView = UIStackView(arrangedSubviews: horizontalyViews)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = spacing
        stackView.isAccessibilityElement = true
        stackView.accessibilityIdentifier = DesignSystemAccessibilityIDs.RowView.horizontalArrayStack
        return stackView
    }
    
    public func connectOnScroll(horizontalyViews: [UIView], spacing: CGFloat = 0) -> UIView {
        let scrollView = UIScrollView()
        let stackView = UIStackView(arrangedSubviews: horizontalyViews)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = spacing
        scrollView.addSubview(stackView)
        stackView.isAccessibilityElement = true
        stackView.accessibilityIdentifier = DesignSystemAccessibilityIDs.RowView.horizontalScrollStack
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
            $0.width.greaterThanOrEqualToSuperview()
        }
        return scrollView
    }
    
    public func connect(verticalyViews: [UIView]) -> UIView {
        let stackView = UIStackView(arrangedSubviews: verticalyViews)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.isAccessibilityElement = true
        stackView.accessibilityIdentifier = DesignSystemAccessibilityIDs.RowView.verticalArrayStack
        return stackView
    }
}

