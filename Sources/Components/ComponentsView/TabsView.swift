import UIKit
import SnapKit

public class TabsView: UIView, ComponentProtocol {
    
    public struct ViewProperties {
        public var height: CGFloat
        public var items: [TabItemView.ViewProperties]
        public var divider: DividerView.ViewProperties
        public var selectedTabIndex: Int
        public var animationDuration: TimeInterval
        
        public init(
            height: CGFloat = 0,
            items: [TabItemView.ViewProperties] = [],
            divider: DividerView.ViewProperties = .init(),
            selectedTabIndex: Int = -1,
            animationDuration: TimeInterval = 0
        ) {
            self.height = height
            self.items = items
            self.divider = divider
            self.selectedTabIndex = selectedTabIndex
            self.animationDuration = animationDuration
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    private let tabsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 0
        stack.distribution = .fill
        return stack
    }()
    
    private let dividerView: DividerView = .init()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private var dividerLeadingConstraint: Constraint?
    private var dividerWidthConstraint: Constraint?
    private var heightConstraint: Constraint?
    
    private func setupView() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        scrollView.addSubview(tabsStack)
        tabsStack.snp.makeConstraints {
            $0.edges.height.equalToSuperview()
        }
        addSubview(dividerView)
        dividerView.snp.makeConstraints {
            self.dividerLeadingConstraint = $0.leading.equalTo(tabsStack).constraint
            self.dividerWidthConstraint = $0.width.equalTo(0).constraint
            $0.bottom.equalTo(tabsStack)
        }
        snp.makeConstraints {
            self.heightConstraint = $0.height.equalTo(0).constraint
        }
        clipsToBounds = true
    }
    
    public func update(with viewProperties: ViewProperties) {
        updateHeight(height: viewProperties.height)
        createTabs(count: viewProperties.items.count)
        updateTabs(using: viewProperties)
        updateDivider(using: viewProperties)
        updateContentOffset(with: viewProperties)
        self.viewProperties = viewProperties
    }
    
    private func createTabs(count: Int) {
        guard tabsStack.arrangedSubviews.count != count else { return }
        tabsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for _ in 0..<count {
            tabsStack.addArrangedSubview(TabItemView())
        }
    }
    
    private func updateTabs(using viewProperties: ViewProperties) {
        UIView.transition(
            with: tabsStack,
            duration: viewProperties.animationDuration,
            options: [.transitionCrossDissolve]
        ) { [self] in
            for (viewProperty, itemView) in zip(viewProperties.items, tabsStack.arrangedSubviews) {
                (itemView as? TabItemView)?.update(with: viewProperty)
            }
        }
    }
    
    private func updateHeight(height: CGFloat) {
        guard self.viewProperties.height != height else { return }
        heightConstraint?.update(offset: height)
        layoutIfNeeded()
    }
    
    private func updateDivider(using viewProperties: ViewProperties) {
        // для divider нужны корректные bounds
        setNeedsLayout()
        layoutIfNeeded()
        updateDividerLeading(with: viewProperties)
        updateDividerWidth(with: viewProperties)
        dividerView.update(with: viewProperties.divider)
    }
    
    private func updateDividerLeading(with viewProperties: ViewProperties) {
        UIView.animate(withDuration: viewProperties.animationDuration) { [self] in
            let selectedTab = tabsStack.arrangedSubviews[viewProperties.selectedTabIndex]
            dividerLeadingConstraint?.update(inset: selectedTab.frame.origin.x)
            layoutIfNeeded()
        }
    }
    
    private func updateDividerWidth(with viewProperties: ViewProperties) {
        UIView.animate(withDuration: viewProperties.animationDuration) { [self] in
            let selectedTab = tabsStack.arrangedSubviews[viewProperties.selectedTabIndex]
            dividerWidthConstraint?.update(offset: selectedTab.bounds.width)
            layoutIfNeeded()
        }
    }
    
    private var positionWasInitiated = false
    
    private func forceInitialPosition() {
        guard
            !positionWasInitiated,
            !viewProperties.items.isEmpty,
            // update вызывается до того, как известны bounds, поэтому костыль
            bounds != .zero
        else { return }
        updateContentOffset(with: viewProperties, animated: false)
        positionWasInitiated = true
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.contentSize = tabsStack.bounds.size
        forceInitialPosition()
    }
    
    private func updateContentOffset(
        with viewProperties: ViewProperties,
        animated: Bool = true
    ) {
        guard !viewProperties.items.isEmpty else { return }
        let selectedTab = tabsStack.arrangedSubviews[viewProperties.selectedTabIndex]
        // В идеале проскроллить к центру
        let desiredOffset = selectedTab.frame.midX - scrollView.frame.midX
        // Ограничиваем скролл, чтобы не выходить за границы
        let maxOffset = scrollView.contentSize.width - scrollView.bounds.width
        let resultOffset = max(0, min(desiredOffset, maxOffset))
        let resultRect = CGRect(
            origin: .init(x: resultOffset, y: 0),
            size: scrollView.bounds.size)
        scrollView.scrollRectToVisible(resultRect, animated: animated)
    }
}
