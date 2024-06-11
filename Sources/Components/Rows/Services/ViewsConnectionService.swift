import UIKit
import SnapKit

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
        return stackView
    }
    
    public func connect(leftView: UIView, rightView: UIView, spacing: Int = .zero) -> UIView {
        let stackView = UIStackView(arrangedSubviews: [leftView, rightView])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = CGFloat(spacing)
        return stackView
    }
    
    public func connect(horizontalyViews: [UIView]) -> UIView {
        let stackView = UIStackView(arrangedSubviews: horizontalyViews)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }
    
    public func connect(verticalyViews: [UIView]) -> UIView {
        let stackView = UIStackView(arrangedSubviews: verticalyViews)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }
}

