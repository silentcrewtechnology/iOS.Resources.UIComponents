import UIKit

public final class RowCell: UITableViewCell {
    public var customView: UIView? {
        willSet {
            customView?.removeFromSuperview()
        }
        didSet {
            if let newCustomView = customView {
                setupCustomView(newCustomView)
            }
        }
    }
    
    private func setupCustomView(_ view: UIView) {
        contentView.addSubview(view)
        view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
