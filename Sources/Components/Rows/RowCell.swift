import UIKit
import SnapKit

public final class RowCell: UITableViewCell {
    public var customView: UIView? {
        didSet {
            if let newCustomView = customView {
                setupCustomView(newCustomView)
            }
        }
    }
    
    private func setupCustomView(_ view: UIView) {
        contentView.addSubview(view)
        view.snp.makeConstraints {
            $0.edges.equalToSuperview().priority(999)
        }
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        contentView.subviews.forEach { $0.removeFromSuperview() }
    }
}
