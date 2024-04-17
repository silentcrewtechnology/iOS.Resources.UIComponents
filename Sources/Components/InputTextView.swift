import UIKit
import SnapKit

public class InputTextView: UIView {
    
    public struct ViewProperties {
        public var header: LabelView.ViewProperties?
        public var textField: InputTextField.ViewProperties
        public var rightViews: [UIView]
        public var hint: HintView.ViewProperties
        public var isEnabled: Bool
        public var fieldBackgroundColor: UIColor
        public var cornerRadius: CGFloat
        public var borderColor: UIColor
        public var borderWidth: CGFloat
        
        public init(
            header: LabelView.ViewProperties? = nil,
            textField: InputTextField.ViewProperties = .init(),
            rightViews: [UIView] = [],
            hint: HintView.ViewProperties = .init(),
            isEnabled: Bool = true,
            fieldBackgroundColor: UIColor = .clear,
            cornerRadius: CGFloat = 0,
            borderColor: UIColor = .clear,
            borderWidth: CGFloat = 0
        ) {
            self.header = header
            self.textField = textField
            self.rightViews = rightViews
            self.hint = hint
            self.isEnabled = isEnabled
            self.fieldBackgroundColor = fieldBackgroundColor
            self.cornerRadius = cornerRadius
            self.borderColor = borderColor
            self.borderWidth = borderWidth
        }
    }
    
    private var viewProperties: ViewProperties = .init()
    
    private let headerView = LabelView()
    
    private lazy var fieldContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.addSubview(hStack)
        hStack.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        view.snp.makeConstraints { $0.height.equalTo(56) }
        return view
    }()
    
    private lazy var hStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [textField])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .top
        return stack
    }()
    
    private let textField = InputTextField()
    
    private let hintView = HintView()
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            headerView,
            fieldContainer,
            hintView
        ])
        stack.axis = .vertical
        stack.spacing = .zero
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupView() {
        addSubview(vStack)
        vStack.snp.makeConstraints { $0.edges.equalToSuperview() }
        textField.isUserInteractionEnabled = false
        fieldContainer.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(tapped)))
    }
    
    // MARK: - public methods
    
    public func update(with viewProperties: ViewProperties) {
        updateHeader(with: viewProperties.header)
        updateFieldContainer(with: viewProperties)
        textField.update(with: viewProperties.textField)
        hintView.update(with: viewProperties.hint)
        self.viewProperties = viewProperties
    }
    
    private func updateHeader(with header: LabelView.ViewProperties?) {
        if let header {
            headerView.update(with: header)
            headerView.isHidden = false
        } else {
            headerView.isHidden = true
        }
    }
    
    private func updateFieldContainer(with viewProperties: ViewProperties) {
        fieldContainer.backgroundColor = viewProperties.fieldBackgroundColor
        fieldContainer.layer.borderColor = viewProperties.borderColor.cgColor
        fieldContainer.layer.borderWidth = viewProperties.borderWidth
        fieldContainer.layer.cornerRadius = viewProperties.cornerRadius
        fieldContainer.isUserInteractionEnabled = viewProperties.isEnabled
        textField.update(with: viewProperties.textField)
        updateRightStack(rightViews: viewProperties.rightViews)
    }
    
    private func updateRightStack(rightViews: [UIView]) {
        hStack.arrangedSubviews.forEach {
            guard $0 !== textField else { return }
            $0.removeFromSuperview()
        }
        for rightView in rightViews {
            hStack.addArrangedSubview(rightView)
        }
    }
    
    @objc
    private func tapped() {
        guard fieldContainer.isUserInteractionEnabled else { return }
        textField.becomeFirstResponder()
    }
}
