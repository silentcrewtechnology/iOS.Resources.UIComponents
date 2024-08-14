import UIKit

public struct AtomService {
    public func createAtom(_ atom: Atom) -> UIView {
        switch atom {
        case .title(let viewProperties):
            return createLabel(viewProperties)
        case .subtitle(let viewProperties):
            return createLabel(viewProperties)
        case .image40(let viewProperties):
            return createImage(viewProperties)
        case .card(let viewProperties):
            return createCard(viewProperties)
        case .index(let viewProperties):
            return createLabel(viewProperties)
        case .icon24(let viewProperties):
            return createImage(viewProperties)
        case .icon20(let viewProperties):
            return createImage(viewProperties)
        case .toggle(let viewProperties):
            return createToggle(viewProperties)
        case .amountText(let viewProperties):
            return createLabel(viewProperties)
        case .checkbox(let viewProperties):
            return createCheckbox(viewProperties)
        case .radio(let viewProperties):
            return createRadio(viewProperties)
        case .button(let viewProperties):
            return createButton(viewProperties)
        case .label(let viewProperties):
            return createLabel(viewProperties)
        case .input(let viewProperties):
            return createInput(viewProperties)
        case .buttonIcon(let viewProperties):
            return createButtonIcon(viewProperties)
        case .titleView(let viewProperties):
            return createTitleView(viewProperties)
        }
    }
}

private extension AtomService {
    private func createLabel(_ viewProperties: LabelView.ViewProperties) -> UIView {
        let label = LabelView()
        label.update(with: viewProperties)
        return label
    }
    
    private func createImage(_ viewProperties: ImageView.ViewProperties) -> UIView {
        let imageView = ImageView()
        imageView.update(with: viewProperties)
        return imageView
    }
    
    private func createCard(_ viewProperties: CardView.ViewProperties) -> UIView {
        let cardView = CardView()
        cardView.update(with: viewProperties)
        return cardView
    }
    
    private func createToggle(_ viewProperties: ToggleView.ViewProperties) -> UIView {
        let toggle = ToggleView()
        toggle.update(with: viewProperties)
        return toggle
    }
    
    private func createCheckbox(_ viewProperties: CheckboxView.ViewProperties) -> UIView {
        let checkbox = CheckboxView()
        checkbox.update(with: viewProperties)
        return checkbox
    }
    
    private func createRadio(_ viewProperties: RadioView.ViewProperties) -> UIView {
        let radio = RadioView()
        radio.update(with: viewProperties)
        return radio
    }
    
    private func createButton(_ viewProperties: ButtonView.ViewProperties) -> UIView {
        let button = ButtonView()
        button.update(with: viewProperties)
        return button
    }
    
    private func createInput(_ viewProperties: InputTextField.ViewProperties) -> UIView {
        let input = InputTextField()
        input.update(with: viewProperties)
        return input
    }
    
    private func createButtonIcon(_ viewProperties: ButtonIcon.ViewProperties) -> UIView {
        let buttonIcon = ButtonIcon()
        buttonIcon.update(with: viewProperties)
        return buttonIcon
    }
    
    private func createTitleView(_ viewProperties: TitleView.ViewProperties) -> UIView {
        let titleView = TitleView()
        titleView.update(with: viewProperties)
        return titleView
    }
}
