import UIKit
import SnapKit

public class CardImageView: UIView {
    
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
        setupGradientColor()
    }
   
    private lazy var gradientView: GradientView = {
        let gradientView = GradientView(frame: bounds)
        gradientView.gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientView.gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        return gradientView
    }()
    
    private func setupView() {
        addSubview(imageView)
        imageView.layer.cornerRadius = 4
        imageView.layer.masksToBounds = true
        imageView.snp.makeConstraints() {
            $0.size.equalTo(CGSize(width: 48, height: 32))
            $0.top.equalToSuperview().offset(4)
            $0.leading.trailing.equalToSuperview()
        }
        
        addSubview(paymentSystemImageView)
        paymentSystemImageView.snp.makeConstraints() {
            $0.size.equalTo(CGSize(width: 24, height: 24))
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(4)
        }
        
        addSubview(gradientView)
        gradientView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 48, height: 40))
        }
        clipsToBounds = true
    }
    
    private func setupGradientColor() {
        gradientView.gradientLayer.colors = [UIColor.black.withAlphaComponent(0).cgColor,
                                             UIColor.black.withAlphaComponent(0.25).cgColor]
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

class GradientView: UIView {

     lazy var gradientLayer: CAGradientLayer = {
        let result = CAGradientLayer()
        self.layer.addSublayer(result)
        return result
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradientLayer.frame = self.bounds
    }
}
