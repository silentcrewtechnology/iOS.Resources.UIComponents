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
        case .card(let image):
            //TODO: ждем элемент ДС - PCABO3-10607
            return createCard(image)
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
        case .copyText(let viewProperties):
            return createLabel(viewProperties)
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
    
    // TODO: заменить на элемент ДС - PCABO3-10607
    private func createCard(_ image: UIImage) -> UIView {
        let imageView = UIImageView()
        imageView.image = image
        return imageView
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
}
