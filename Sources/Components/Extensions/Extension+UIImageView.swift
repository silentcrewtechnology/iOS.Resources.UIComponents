import UIKit

public extension UIImageView {
    
    func circled(radius: CGFloat) -> Self {
        circled(diameter: radius * 2)
    }
    
    func circled(diameter: CGFloat) -> Self {
        snp.makeConstraints { $0.size.equalTo(diameter) }
        layer.cornerRadius = diameter / 2
        clipsToBounds = true
        return self
    }
}
