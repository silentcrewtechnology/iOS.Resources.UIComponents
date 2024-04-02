import UIKit
import SnapKit

public class TapInsetView<T: UIView>: UIView {
    
    public struct ViewProperties {
        public var inner: Inner
        public var insets: UIEdgeInsets
        public var onTap: () -> Void
        
        public struct Inner {
            public var view: T
            public var size: CGSize
            
            public init(
                view: T = .init(),
                size: CGSize = .zero
            ) {
                self.view = view
                self.size = size
            }
        }
        
        public init(
            inner: Inner = .init(),
            insets: UIEdgeInsets = .zero,
            onTap: @escaping () -> Void = { }
        ) {
            self.inner = inner
            self.insets = insets
            self.onTap = onTap
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupView() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
    }
    
    public func update(with viewProperties: ViewProperties) {
        let inner = viewProperties.inner
        addSubview(inner.view)
        inner.view.snp.remakeConstraints {
            if inner.size != .zero { // self-sized view
                $0.size.equalTo(inner.size)
            }
            $0.edges.equalToSuperview().inset(viewProperties.insets)
        }
        self.viewProperties = viewProperties
    }
    
    @objc private func tapped() {
        viewProperties.onTap()
    }
}
