import UIKit
import SnapKit

public class ImageCardView: UIView {
    
    public struct ViewProperties {
        public var backgroundImage: UIImage?
        public var paymentSystemImage: UIImage?
        
        public init(
            backgroundImage: UIImage? = nil,
            paymentSystemImage: UIImage? = nil
        ) {
            self.backgroundImage = backgroundImage
            self.paymentSystemImage = paymentSystemImage
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        return view
    }()
    
    private let paymentSystemImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        return view
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
        
        addSubview(imageView)
        imageView.snp.makeConstraints() {
            $0.size.equalTo(CGSize(width: 48, height: 32))
            $0.top.equalToSuperview().offset(4)
            $0.leading.trailing.equalToSuperview()
        }
        
        addSubview(paymentSystemImageView)
        paymentSystemImageView.snp.makeConstraints() {
            $0.size.equalTo(CGSize(width: 24, height: 24))
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(4)
        }
        
        snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 48, height: 40))
        }
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    public func update(with viewProperties: ViewProperties) {
        updateImage(with: viewProperties)
        self.viewProperties = viewProperties
    }
    
    private func updateImage(with viewProperties: ViewProperties) {
        imageView.image = viewProperties.backgroundImage
        paymentSystemImageView.image = viewProperties.paymentSystemImage
    }
}
