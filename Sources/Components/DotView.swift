import UIKit
import SnapKit

public final class DotView: UIView {
    
    public struct ViewProperties {
        public var dotSize: CGSize
        public var selectedBackgroundColor: UIColor
        public var notSelectedBackgroundColor: UIColor
        public var selectedDotWidth: CGFloat
        // разница уменьшения при скролле
        public var pageItemSizeDifference: CGFloat
        public var multiplier: CGFloat
        public var isSelected: Bool

        public init(
            dotSize: CGSize = CGSize(width: 8, height: 8),
            selectedBackgroundColor: UIColor = .darkGray,
            notSelectedBackgroundColor: UIColor = .lightGray,
            selectedDotWidth: CGFloat = 24,
            pageItemSizeDifference: CGFloat = 2,
            multiplier: CGFloat = 0,
            isSelected: Bool = false
        ) {
            self.dotSize = dotSize
            self.selectedBackgroundColor = selectedBackgroundColor
            self.notSelectedBackgroundColor = notSelectedBackgroundColor
            self.selectedDotWidth = selectedDotWidth
            self.pageItemSizeDifference = pageItemSizeDifference
            self.multiplier = multiplier
            self.isSelected = isSelected
        }
    }
    
    // MARK: - Private properties
    private var viewProperties: ViewProperties = .init()

    // MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    
    // MARK: - Public methods
    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
        updateView()
    }
    
    // MARK: - Private methods
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        frame = .init(origin: .zero, size: viewProperties.dotSize)
        layer.cornerRadius = self.frame.height / 2
    }

    private func updateView() {
        if viewProperties.multiplier < 0 {
            frame.size = .zero
            return
        }

        let sizeDifference = viewProperties.pageItemSizeDifference * viewProperties.multiplier
        var newSize = CGSize(
            width: viewProperties.dotSize.width - sizeDifference,
            height: viewProperties.dotSize.height - sizeDifference
        )

        if newSize == .zero {
            newSize = CGSize(width: 1, height: 1)
        }

        if viewProperties.isSelected {
            newSize.width = viewProperties.selectedDotWidth
        }

        transform = transform.translatedBy(x: sizeDifference / 2, y: sizeDifference / 2)
        frame.size = newSize
        layer.cornerRadius = frame.size.height / 2

        backgroundColor = viewProperties.isSelected
            ? viewProperties.selectedBackgroundColor
            : viewProperties.notSelectedBackgroundColor
    }
}


