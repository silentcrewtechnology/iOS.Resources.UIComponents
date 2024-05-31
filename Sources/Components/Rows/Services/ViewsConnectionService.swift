import UIKit
import SnapKit

public struct ViewsConnectionService {
    
    // MARK: - Life cycle
    
    public init() { }
    
    // MARK: - Methods
    
    public func connect(topView: UIView, bottomView: UIView) -> UIView {
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.alignment = .fill
            stackView.distribution = .fill
            stackView.spacing = 0
            return stackView
        }()
        
        stackView.addArrangedSubview(topView)
        stackView.addArrangedSubview(bottomView)
        
        return stackView
    }
    
    public func connect(leftView: UIView, rightView: UIView, spacing: Int = .zero) -> UIView {
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .fill
            stackView.distribution = .fill
            stackView.spacing = CGFloat(spacing)
            return stackView
        }()
        
        stackView.addArrangedSubview(leftView)
        stackView.addArrangedSubview(rightView)
        
        return stackView
    }
    
    public func connect(horizontalyViews: [UIView]) -> UIView {
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .fill
            stackView.distribution = .fill
            stackView.spacing = 0
            return stackView
        }()
        
        guard !horizontalyViews.isEmpty else {
            return stackView
        }
        
        for view in horizontalyViews {
            stackView.addArrangedSubview(view)
        }
        
        return stackView
    }
    
    public func connect(verticalyViews: [UIView]) -> UIView {
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.alignment = .fill
            stackView.distribution = .fill
            stackView.spacing = 0
            return stackView
        }()
        
        guard !verticalyViews.isEmpty else {
            return stackView
        }
        
        for view in verticalyViews {
            stackView.addArrangedSubview(view)
        }
        
        return stackView
    }
}

