import UIKit
import SnapKit

public class SegmentView: UIView {
    
    public struct ViewProperties {
        public var backgroundColor: UIColor
        public var slider: SegmentSliderView.ViewProperties
        public var items: [SegmentItemView.ViewProperties]
        public var selectedSegmentIndex: Int
        public var onSelect: (Int) -> Void
        public var height: CGFloat
        public var cornerRadius: CGFloat
        public var animationDuration: TimeInterval
        
        public init(
            backgroundColor: UIColor = .clear,
            slider: SegmentSliderView.ViewProperties = .init(),
            items: [SegmentItemView.ViewProperties] = [],
            selectedSegmentIndex: Int = -1,
            onSelect: @escaping (Int) -> Void = { _ in },
            height: CGFloat = .zero,
            cornerRadius: CGFloat = .zero,
            animationDuration: TimeInterval = .zero
        ) {
            self.backgroundColor = backgroundColor
            self.slider = slider
            self.items = items
            self.selectedSegmentIndex = selectedSegmentIndex
            self.onSelect = onSelect
            self.height = height
            self.cornerRadius = cornerRadius
            self.animationDuration = animationDuration
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    private let segmentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = .zero
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let tappableAreaView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let sliderView: SegmentSliderView = {
        let view = SegmentSliderView()
        return view
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private var sliderLeadingConstraint: Constraint?
    /// Для обновления constraint multiplier
    private var sliderWidthWithMultiplier: Constraint?
    
    private func setupView() {
        addSubview(sliderView)
        addSubview(segmentStack)
        segmentStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4)
        }
        sliderView.snp.makeConstraints {
            $0.height.equalTo(segmentStack)
            self.sliderLeadingConstraint = $0.leading.equalTo(segmentStack).constraint
            $0.centerY.equalTo(segmentStack)
        }
        addSubview(tappableAreaView)
        tappableAreaView.snp.makeConstraints {
            $0.edges.equalTo(segmentStack)
        }
        snp.makeConstraints { $0.height.equalTo(0) }
    }
    
    public func update(with viewProperties: ViewProperties) {
        backgroundColor = viewProperties.backgroundColor
        layer.cornerRadius = viewProperties.cornerRadius
        updateHeight(using: viewProperties)
        createSegments(using: viewProperties)
        updateSlider(using: viewProperties)
        updateSegments(using: viewProperties)
        self.viewProperties = viewProperties
    }
    
    private func createSegments(using viewProperties: ViewProperties) {
        guard segmentStack.arrangedSubviews.count != viewProperties.items.count else { return } 
        segmentStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for _ in 0..<viewProperties.items.count {
            segmentStack.addArrangedSubview(SegmentItemView())
        }
    }
    
    private func updateHeight(using viewProperties: ViewProperties) {
        guard self.viewProperties.height != viewProperties.height else { return }
        snp.updateConstraints {
            $0.height.equalTo(viewProperties.height)
        }
        layoutIfNeeded()
    }
    
    private func updateSlider(using viewProperties: ViewProperties) {
        
        func updateSliderWidth(with viewProperties: ViewProperties) {
            guard
                !viewProperties.items.isEmpty,
                self.viewProperties.items.count != viewProperties.items.count
            else { return }
            sliderWidthWithMultiplier?.deactivate()
            sliderView.snp.makeConstraints {
                self.sliderWidthWithMultiplier = $0.width.equalTo(segmentStack).dividedBy(viewProperties.items.count).constraint
            }
        }
        
        func updateSliderInset(with viewProperties: ViewProperties) {
            guard self.viewProperties.selectedSegmentIndex != viewProperties.selectedSegmentIndex else { return }
            UIView.animate(withDuration: viewProperties.animationDuration) { [self] in
                let inset = CGFloat(viewProperties.selectedSegmentIndex) * sliderView.bounds.width
                sliderLeadingConstraint?.update(inset: inset)
                layoutIfNeeded()
            }
        }
        
        sliderView.update(with: viewProperties.slider)
        updateSliderWidth(with: viewProperties)
        updateSliderInset(with: viewProperties)
    }
    
    private func updateSegments(using viewProperties: ViewProperties) {
        UIView.transition(
            with: segmentStack,
            duration: viewProperties.animationDuration,
            options: [.transitionCrossDissolve]
        ) { [self] in
            for (viewProperty, item) in zip(viewProperties.items, segmentStack.arrangedSubviews) {
                (item as? SegmentItemView)?.update(with: viewProperty)
            }
        }
    }
    
    private var sliderWasInitiated = false
    
    private func forceInitialSliderPosition() {
        guard
            !sliderWasInitiated,
            // update вызывается до того, как известны bounds, поэтому костыль
            sliderView.bounds.width != .zero
        else { return }
        let inset = CGFloat(viewProperties.selectedSegmentIndex) * sliderView.bounds.width
        sliderLeadingConstraint?.update(inset: inset)
        layoutIfNeeded()
        sliderWasInitiated = true
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        forceInitialSliderPosition()
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: segmentStack)
        let itemWidth = Int(segmentStack.bounds.width) / segmentStack.arrangedSubviews.count
        let index = Int(location.x) / itemWidth
        guard index != viewProperties.selectedSegmentIndex else { return }
        viewProperties.onSelect(index)
    }
}
