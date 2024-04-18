import UIKit
import SnapKit

public final class PageControl: UIView {
    
    public struct ViewProperties {
        public var numberOfPages: Int
        public var currentPage: Float
        public var dotSize: CGSize
        public var selectedBackgroundColor: UIColor
        public var notSelectedBackgroundColor: UIColor
        public var selectedDotWidth: CGFloat
        public var maxNumberOfVisiblePages: Int
        // разница уменьшения pageItemo'в при скролле
        public var pageItemSizeDifference: CGFloat

        public init(
            numberOfPages: Int = 0,
            currentPage: Float = 0,
            dotSize: CGSize = CGSize(width: 8, height: 8),
            selectedBackgroundColor: UIColor = .white,
            notSelectedBackgroundColor: UIColor = .lightGray,
            selectedDotWidth: CGFloat = 24,
            maxNumberOfVisiblePages: Int = 5,
            pageItemSizeDifference: CGFloat = 2
        ) {
            self.numberOfPages = numberOfPages
            self.currentPage = currentPage
            self.dotSize = dotSize
            self.selectedBackgroundColor = selectedBackgroundColor
            self.notSelectedBackgroundColor = notSelectedBackgroundColor
            self.selectedDotWidth = selectedDotWidth
            self.maxNumberOfVisiblePages = maxNumberOfVisiblePages
            self.pageItemSizeDifference = pageItemSizeDifference
        }
    }
    
    // MARK: - Private properties
    private var viewProperties: ViewProperties = .init()
    
    private var dotViews: [UIView] = []
    
    private let containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()

    private var currentPropertyAnimator: UIViewPropertyAnimator?
    private var currentPropertyAnimatorPage: Int?
    private var isBackward = true

    // MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        configure()
        setCurrentPage(animated: false)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
    
    public override var intrinsicContentSize: CGSize {
        .init(
            width: viewProperties.selectedDotWidth + (viewProperties.dotSize.width * 2) * CGFloat(max(viewProperties.maxNumberOfVisiblePages, self.viewProperties.numberOfPages - 1)),
            height: viewProperties.dotSize.height
        )
    }

    
    // MARK: - Public methods
    public func update(with viewProperties: ViewProperties) {
        let needReconfigured = self.viewProperties.numberOfPages != viewProperties.numberOfPages
        self.viewProperties = viewProperties

        if needReconfigured { configure() }
        setCurrentPage(animated: !needReconfigured)
    }
    
    // MARK: - Private methods
    private func layout() {
        addSubview(containerView)

        containerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(intrinsicContentSize)
        }
    }
    
    private func configure() {
        containerView.subviews.forEach({ $0.removeFromSuperview() })
        
        for index in 0..<viewProperties.numberOfPages {
            let dotView = UIView()
            dotView.translatesAutoresizingMaskIntoConstraints = false
            dotViews.append(dotView)
            containerView.addSubview(dotView)


            let xOffset = CGFloat(index) * (viewProperties.dotSize.width * 2)
            + CGFloat(max(0, viewProperties.maxNumberOfVisiblePages - viewProperties.numberOfPages)) * viewProperties.dotSize.width
            dotView.frame = .init(origin: .init(x: xOffset, y: 0), size: viewProperties.dotSize)
            dotView.layer.cornerRadius = dotView.frame.height / 2

        }
    }
    
    private func setCurrentPage(animated: Bool = true) {
        guard viewProperties.currentPage >= 0, viewProperties.currentPage < Float(viewProperties.numberOfPages)
                && viewProperties.numberOfPages > 0 else { return }

        var integralCurrentPage = Int(viewProperties.currentPage)

        // анимированный переход при прямой смене currentPage
        guard animated,
              viewProperties.currentPage.truncatingRemainder(dividingBy: 1) != 0.0
        else {
            currentPropertyAnimator?.stopAnimation(true)
            currentPropertyAnimator = nil
            currentPropertyAnimatorPage = nil
            UIView.animate(withDuration: 1) {
                self.updateDots(integralCurrentPage)
            }
            return
        }

        // анимированный переход при смене currentPage при прокрутке коллекции
        let currentPageOffset = viewProperties.currentPage - floor(viewProperties.currentPage)
        
        integralCurrentPage = integralCurrentPage + 1

        guard currentPropertyAnimatorPage != integralCurrentPage else {
            currentPropertyAnimator?.fractionComplete = isBackward ? CGFloat(1 - currentPageOffset) : CGFloat(currentPageOffset)
            return
        }
        currentPropertyAnimator?.stopAnimation(true)
        currentPropertyAnimator = nil

        isBackward = integralCurrentPage < currentPropertyAnimatorPage ?? 0

        let propertyAnimator = UIViewPropertyAnimator(
            duration: 0.1,
            curve: .easeInOut,
            animations: { 
                self.updateDots(integralCurrentPage - (self.isBackward ? 1 : 0))
            })
        
        propertyAnimator.fractionComplete = isBackward ? CGFloat(1 - currentPageOffset) : CGFloat(currentPageOffset)

        currentPropertyAnimator = propertyAnimator
        currentPropertyAnimatorPage = integralCurrentPage
    }

    private func updateDots(_ currentPage: Int) {
        if self.viewProperties.numberOfPages > self.viewProperties.maxNumberOfVisiblePages {
            self.dotViews.enumerated().forEach { index, view in
                view.transform = .init(translationX: index > currentPage ? self.viewProperties.selectedDotWidth - self.viewProperties.dotSize.width : 0, y: 0)
                    .translatedBy(
                        x: -CGFloat(max(0, min(currentPage, self.viewProperties.numberOfPages - 3) - 2)) * (self.viewProperties.dotSize.width * 2),
                        y: 0
                    )


                let isCurrentPageIsOutside = currentPage <= 1 || currentPage >= self.viewProperties.numberOfPages - 2

                switch abs(index - currentPage) {
                case 0:
                    self.updateDotView(view, multiplier: 0, isSelected: true)
                case 1:
                    let multiplier: CGFloat = isCurrentPageIsOutside ? 0 : 1
                    self.updateDotView(view, multiplier: multiplier, isSelected: false)
                case 2:
                    let multiplier: CGFloat = isCurrentPageIsOutside ? 0 : 2
                    self.updateDotView(view, multiplier: multiplier, isSelected: false)
                case 3:
                    let multiplier: CGFloat = isCurrentPageIsOutside ? 1 : -1
                    self.updateDotView(view, multiplier: multiplier, isSelected: false)
                case 4:
                    let multiplier: CGFloat = isCurrentPageIsOutside ? 2 : -1
                    self.updateDotView(view, multiplier: multiplier, isSelected: false)
                default:
                    self.updateDotView(view, multiplier: -1, isSelected: false)
                }
            }
        } else {
            self.dotViews.enumerated().forEach { index, view in
                view.transform = .init(translationX: index > currentPage ? self.viewProperties.selectedDotWidth - self.viewProperties.dotSize.width : 0, y: 0)
                if index == currentPage {
                    self.updateDotView(view, multiplier: 0, isSelected: true)
                } else {
                    self.updateDotView(view, multiplier: 0, isSelected: false)
                }
            }
        }
    }

private func updateDotView(_ view: UIView, multiplier: CGFloat, isSelected: Bool) {
        if multiplier < 0 {
            view.frame.size = .zero
            return
        }

        let sizeDifference = viewProperties.pageItemSizeDifference * multiplier
        var newSize = CGSize(
            width: viewProperties.dotSize.width - sizeDifference,
            height: viewProperties.dotSize.height - sizeDifference
        )

        if newSize == .zero {
            newSize = CGSize(width: 1, height: 1)
        }

        if isSelected {
            newSize.width = viewProperties.selectedDotWidth
        }

        view.transform = view.transform.concatenating(.init(translationX: multiplier, y: multiplier))
        view.frame.size = newSize
        view.layer.cornerRadius = view.frame.size.height / 2

        view.backgroundColor = isSelected ? viewProperties.selectedBackgroundColor : viewProperties.notSelectedBackgroundColor
    }
}

