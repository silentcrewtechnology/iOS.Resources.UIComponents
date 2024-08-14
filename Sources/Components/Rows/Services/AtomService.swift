import UIKit

public struct AtomService {
    public func createAtom(_ atom: Atom) -> UIView {
        switch atom {
        case .title(let viewProperties):
            return createView(of: LabelView.self, with: viewProperties)
        case .subtitle(let viewProperties):
            return createView(of: LabelView.self, with: viewProperties)
        case .image40(let viewProperties):
            return createView(of: ImageView.self, with: viewProperties)
        case .card(let viewProperties):
            return createView(of: CardImageView.self, with: viewProperties)
        case .index(let viewProperties):
            return createView(of: LabelView.self, with: viewProperties)
        case .icon24(let viewProperties):
            return createView(of: ImageView.self, with: viewProperties)
        case .icon20(let viewProperties):
            return createView(of: ImageView.self, with: viewProperties)
        case .toggle(let viewProperties):
            return createView(of: ToggleView.self, with: viewProperties)
        case .amountText(let viewProperties):
            return createView(of: LabelView.self, with: viewProperties)
        case .checkbox(let viewProperties):
            return createView(of: CheckboxView.self, with: viewProperties)
        case .radio(let viewProperties):
            return createView(of: RadioView.self, with: viewProperties)
        case .button(let viewProperties):
            return createView(of: ButtonView.self, with: viewProperties)
        case .copyText(let viewProperties):
            return createView(of: LabelView.self, with: viewProperties)
        case .subindex(let viewProperties):
            return createView(of: LabelView.self, with: viewProperties)
        case .input(let viewProperties):
            return createView(of: InputTextField.self, with: viewProperties)
        case .buttonIcon(let viewProperties):
            return createView(of: ButtonIcon.self, with: viewProperties)
        case .titleView(let viewProperties):
            return createView(of: TitleView.self, with: viewProperties)
            
        // Элементы Дизайн системы
            
        case .badgeView(let viewProperties):
            return createView(of: BadgeView.self, with: viewProperties)
        case .inputView(let viewProperties):
            return createView(of: InputView.self, with: viewProperties)
        case .chipsView(let viewProperties):
            return createView(of: ChipsView.self, with: viewProperties)
        }
    }
}

private extension AtomService {
    private func createView<T: UIView & ComponentProtocol>(of type: T.Type, with properties: T.ViewProperties) -> UIView {
        let view = T()
        view.update(with: properties)
        return view
    }
}
