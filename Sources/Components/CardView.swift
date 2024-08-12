import UIKit
import SnapKit

public class CardView: UIView {
    
    // MARK: - Properties
    
    public struct ViewProperties {
        public var backgroundImage: UIImage?
        public var paymentSystemImage: UIImage?
        public var centerImage: UIImage?
        public var emptyBand: EmptyBand?
        public var backgroundColor: UIColor?
        public var size: CGSize
        public var cornerRadius: CGFloat
        public var containerInsets: UIEdgeInsets
        public var paymentSystemImageInsets: UIEdgeInsets
        public var paymentSystemImageSize: CGSize
        public var maskedCardNumberLabelInsets: UIEdgeInsets
        public var maskedCardNumber: NSMutableAttributedString?
        public var gradientViewProperties: GradientView.ViewProperties?
        public var stackCardView: StackCardView?
        
        public struct EmptyBand {
            public var backgroundColor: UIColor
            public var topInset: CGFloat
            public var height: CGFloat
            
            init(
                backgroundColor: UIColor = .clear,
                topInset: CGFloat = .zero,
                height: CGFloat = .zero
            ) {
                self.backgroundColor = backgroundColor
                self.topInset = topInset
                self.height = height
            }
        }
        
        public struct StackCardView {
            public var stackCardViewProperties: [CardView.ViewProperties]
            public var alphaValue: CGFloat
            public var insets: UIEdgeInsets
            
            public init(
                stackCardViewProperties: [CardView.ViewProperties] = [],
                alphaValue: CGFloat = .zero,
                insets: UIEdgeInsets = .zero
            ) {
                self.stackCardViewProperties = stackCardViewProperties
                self.alphaValue = alphaValue
                self.insets = insets
            }
        }
        
        public init(
            backgroundImage: UIImage? = nil,
            paymentSystemImage: UIImage? = nil,
            centerImage: UIImage? = nil,
            emptyBand: EmptyBand? = nil,
            backgroundColor: UIColor? = nil,
            size: CGSize = .zero,
            cornerRadius: CGFloat = .zero,
            containerInsets: UIEdgeInsets = .zero,
            paymentSystemImageInsets: UIEdgeInsets = .zero,
            paymentSystemImageSize: CGSize = .zero,
            maskedCardNumberLabelInsets: UIEdgeInsets = .zero,
            maskedCardNumber: NSMutableAttributedString? = nil,
            gradientViewProperties: GradientView.ViewProperties? = nil,
            stackCardView: StackCardView? = nil
        ) {
            self.backgroundImage = backgroundImage
            self.paymentSystemImage = paymentSystemImage
            self.centerImage = centerImage
            self.emptyBand = emptyBand
            self.backgroundColor = backgroundColor
            self.size = size
            self.cornerRadius = cornerRadius
            self.containerInsets = containerInsets
            self.paymentSystemImageInsets = paymentSystemImageInsets
            self.paymentSystemImageSize = paymentSystemImageSize
            self.maskedCardNumberLabelInsets = maskedCardNumberLabelInsets
            self.maskedCardNumber = maskedCardNumber
            self.gradientViewProperties = gradientViewProperties
            self.stackCardView = stackCardView
        }
    }
    
   // MARK: - Private properties
    
    private lazy var backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        
        return view
    }()
    
    private lazy var paymentSystemImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    private lazy var centerImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        
        return view
    }()
    
    private lazy var stackCardView = CardView()
    private lazy var gradientView = GradientView(frame: bounds)
    private lazy var cardNumberLabel = UILabel()
    private lazy var bandView = UIView()
    private lazy var containerView = UIView()
    
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - Methods
    
    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
       
        setupContainerView(viewProperties: viewProperties)
        
        if let centerImage = viewProperties.centerImage {
            setupWithCenterImageView(centerImage: centerImage)
        } else if let emptyBand = viewProperties.emptyBand {
            setupWithEmptyBand(emptyBand: emptyBand)
        } else if viewProperties.maskedCardNumber != nil {
            setupWithCardLabel(viewProperties: viewProperties)
        } else {
            setupWithPaymentSystemLabel(viewProperties: viewProperties)
        }
        
        if let stackCardView = viewProperties.stackCardView {
            setupStackCardView(cardView: stackCardView)
        }
    }
   
    // MARK: - Private methods
    
    private func setupContainerView(viewProperties: ViewProperties) {
        removeConstraintsAndSubviews()
        
        snp.makeConstraints { make in
            make.size.equalTo(viewProperties.size)
        }
        
        addSubview(containerView)
        containerView.layer.cornerRadius = viewProperties.cornerRadius
        containerView.backgroundColor = viewProperties.backgroundColor
        containerView.layer.masksToBounds = true
        containerView.clipsToBounds = true
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(viewProperties.containerInsets)
        }
    }
    
    private func setupWithCenterImageView(centerImage: UIImage) {
        containerView.addSubview(centerImageView)
        centerImageView.image = centerImage
        centerImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupWithEmptyBand(emptyBand: ViewProperties.EmptyBand) {
        containerView.addSubview(bandView)
        bandView.backgroundColor = emptyBand.backgroundColor
        bandView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(emptyBand.topInset)
            make.height.equalTo(emptyBand.height)
        }
    }
    
    private func setupWithCardLabel(viewProperties: ViewProperties) {
        containerView.addSubview(backgroundImageView)
        backgroundImageView.image = viewProperties.backgroundImage
        backgroundImageView.snp.makeConstraints() { make in
            make.edges.equalToSuperview()
        }
        
        containerView.addSubview(paymentSystemImageView)
        paymentSystemImageView.image = viewProperties.paymentSystemImage
        paymentSystemImageView.snp.makeConstraints { make in
            make.size.equalTo(viewProperties.paymentSystemImageSize)
            make.leading.bottom.equalToSuperview().inset(viewProperties.paymentSystemImageInsets)
        }
        
        containerView.addSubview(cardNumberLabel)
        cardNumberLabel.attributedText = viewProperties.maskedCardNumber
        cardNumberLabel.snp.makeConstraints { make in
            make.bottom.leading.equalToSuperview().inset(viewProperties.maskedCardNumberLabelInsets)
        }
    }
    
    private func setupWithPaymentSystemLabel(viewProperties: ViewProperties) {
        containerView.addSubview(backgroundImageView)
        backgroundImageView.image = viewProperties.backgroundImage
        backgroundImageView.snp.makeConstraints() { make in
            make.edges.equalToSuperview()
        }
        
        if let gradientViewProperties = viewProperties.gradientViewProperties {
            containerView.addSubview(gradientView)
            gradientView.update(with: gradientViewProperties)
            gradientView.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(gradientViewProperties.insets)
            }
        }
        
        containerView.addSubview(paymentSystemImageView)
        paymentSystemImageView.image = viewProperties.paymentSystemImage
        paymentSystemImageView.snp.makeConstraints() { make in
            make.size.equalTo(viewProperties.paymentSystemImageSize)
            make.trailing.top.equalToSuperview().inset(viewProperties.paymentSystemImageInsets)
        }
    }
    
    private func setupStackCardView(cardView: ViewProperties.StackCardView) {
        if let cardViewProperties = cardView.stackCardViewProperties.first {
            addSubview(stackCardView)
            sendSubviewToBack(stackCardView)
            stackCardView.update(with: cardViewProperties)
            stackCardView.alpha = cardView.alphaValue
            
            stackCardView.snp.remakeConstraints { make in
                make.size.equalTo(cardViewProperties.size)
                make.centerX.bottom.equalTo(containerView).inset(cardView.insets)
            }
        }
    }
   
    private func removeConstraintsAndSubviews() {
        subviews.forEach { subview in
            subview.snp.removeConstraints()
            subview.removeFromSuperview()
        }
    }
}

public final class GradientView: UIView {
    
    // MARK: - Properties
    
    public struct ViewProperties {
        public var startPoint: CGPoint
        public var endPoint: CGPoint
        public var colors: [Any]?
        public var insets: UIEdgeInsets
        
        public init(
            startPoint: CGPoint = .zero,
            endPoint: CGPoint = .zero,
            colors: [Any]? = nil,
            insets: UIEdgeInsets = .zero
        ) {
            self.startPoint = startPoint
            self.endPoint = endPoint
            self.colors = colors
            self.insets = insets
        }
    }
    
    // MARK: - Private properties
    
    private lazy var gradientLayer: CAGradientLayer = {
        let result = CAGradientLayer()
        self.layer.addSublayer(result)
         
        return result
    }()
    
    // MARK: - Life cycle

    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.gradientLayer.frame = self.bounds
    }
    
    // MARK: - Methods
    
    public func update(with viewProperties: ViewProperties) {
        gradientLayer.startPoint = viewProperties.startPoint
        gradientLayer.endPoint = viewProperties.endPoint
        gradientLayer.colors = viewProperties.colors
    }
}
