import UIKit
import SnapKit

public final class PageControl: UIView, ComponentProtocol {
    public struct ViewProperties {
        public var numberOfPages: Int
        public var currentPage: Float
        public var dotView: DotView.ViewProperties
        public var maxNumberOfVisiblePages: Int

        public init(
            numberOfPages: Int = 0,
            currentPage: Float = 0,
            dotView: DotView.ViewProperties = .init(),
            maxNumberOfVisiblePages: Int = 5
        ) {
            self.numberOfPages = numberOfPages
            self.currentPage = currentPage
            self.dotView = dotView
            self.maxNumberOfVisiblePages = maxNumberOfVisiblePages
        }
    }

    // MARK: - Private properties
    private var viewProperties: ViewProperties = .init()

    private var dotViews: [DotView] = []

    private let containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()

    private var currentPropertyAnimator: UIViewPropertyAnimator?
    private var currentPropertyAnimatorPage: Int?
    private var isBackward = true
    
    fileprivate enum DotPosition: Int {
        case zero
        case one
        case two
        case three
        case fore
        case other

        var isSelected: Bool {
            return self == .zero
        }

        func multiplier(edgeOffset: Int) -> CGFloat {
            switch self {
            case .zero:
                return 0
            case .one:
                return edgeOffset <= 1 ? 0 : 1
            case .two:
                return edgeOffset <= 1 ? 0 : 2
            case .three:
                return edgeOffset <= 1 ? 1 : -1
            case .fore:
                return edgeOffset <= 1 ? (edgeOffset == 0 ? 2 : -1) : -1
            default:
                return -1
            }
        }
    }

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
            width: viewProperties.dotView.selectedDotWidth + (viewProperties.dotView.dotSize.width * 2) * CGFloat(
                max(viewProperties.maxNumberOfVisiblePages - 1, self.viewProperties.numberOfPages - 1)
            ),
            height: viewProperties.dotView.dotSize.height
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
            let dotView = DotView()
            dotView.update(with: viewProperties.dotView)
            dotViews.append(dotView)
            containerView.addSubview(dotView)

            let xOffset = CGFloat(index) * (viewProperties.dotView.dotSize.width * 2) + CGFloat(
                max(0, viewProperties.maxNumberOfVisiblePages - viewProperties.numberOfPages)
            ) * viewProperties.dotView.dotSize.width
            dotView.frame.origin = .init(x: xOffset, y: 0)

        }
    }

    private func setCurrentPage(animated: Bool = true) {
        guard viewProperties.currentPage >= 0,
              viewProperties.currentPage < Float(viewProperties.numberOfPages)
                && viewProperties.numberOfPages > 0 else { return }

        let integralCurrentPage = Int(viewProperties.currentPage)

        // анимированный переход при прямой смене currentPage
        guard animated,
              viewProperties.currentPage.truncatingRemainder(dividingBy: 1) != 0.0
        else {
            usualTransition(integralCurrentPage, animated: animated)
            return
        }

        // анимированный переход при смене currentPage при прокрутке коллекции
        animatedTransition(integralCurrentPage + 1)
    }
    
    private func usualTransition(_ integralCurrentPage: Int, animated: Bool) {
        currentPropertyAnimator?.stopAnimation(true)
        currentPropertyAnimator = nil
        currentPropertyAnimatorPage = nil
        if !animated {
            self.updateDots(integralCurrentPage)
        } else {
            UIView.animate(withDuration: 1) {
                self.updateDots(integralCurrentPage)
            }
        }
    }
    
    private func animatedTransition(_ integralCurrentPage: Int) {
        let currentPageOffset = viewProperties.currentPage - floor(viewProperties.currentPage)

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
            animations: { [weak self] in
                guard let self else { return }
                self.updateDots(integralCurrentPage - (self.isBackward ? 1 : 0))
            })
        propertyAnimator.fractionComplete = isBackward ? CGFloat(1 - currentPageOffset) : CGFloat(currentPageOffset)

        currentPropertyAnimator = propertyAnimator
        currentPropertyAnimatorPage = integralCurrentPage
    }

    private func updateDots(_ currentPage: Int) {
        if viewProperties.numberOfPages > viewProperties.maxNumberOfVisiblePages {
            dotViews.enumerated().forEach { index, view in
                setViewTransform(index: index, view: view, currentPage: currentPage)
                
                guard let state = abs(index - currentPage).state else { return }
           
                let edgeOffset = min(currentPage, viewProperties.numberOfPages - currentPage - 1)
                viewProperties.dotView.multiplier = state.multiplier(edgeOffset: edgeOffset)
                viewProperties.dotView.isSelected = state.isSelected
                
                view.update(with: viewProperties.dotView)
            }
        } else {
            dotViews.enumerated().forEach { index, view in
                setViewTransform(index: index, view: view, currentPage: currentPage)
                
                viewProperties.dotView.multiplier = 0
                viewProperties.dotView.isSelected = index == currentPage
                
                view.update(with: viewProperties.dotView)
            }
        }
    }
    
    private func setViewTransform(index: Int, view: DotView, currentPage: Int) {
        view.transform = .init(
            translationX: index > currentPage ? viewProperties.dotView.selectedDotWidth - viewProperties.dotView.dotSize.width : 0,
            y: 0
        )
            .translatedBy(
                x: -CGFloat(max(0, min(currentPage, viewProperties.numberOfPages - 3) - 2)) * (viewProperties.dotView.dotSize.width * 2),
                y: 0
            )
    }
}

private extension Int {
    var state: PageControl.DotPosition? {
        PageControl.DotPosition(rawValue: self) ?? .other
    }
}
