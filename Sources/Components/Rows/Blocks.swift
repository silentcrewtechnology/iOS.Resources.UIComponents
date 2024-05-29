import UIKit

public enum Atom {
    case title(LabelView.ViewProperties)
    case subtitle(LabelView.ViewProperties)
    case copyText(LabelView.ViewProperties)
    case index(LabelView.ViewProperties)
    case amountText(LabelView.ViewProperties)
    case subindex(LabelView.ViewProperties)
    case image40(ImageView.ViewProperties)
    case icon24(ImageView.ViewProperties)
    case icon20(ImageView.ViewProperties)
    case card(CardImageView.ViewProperties)
    case toggle(ToggleView.ViewProperties)
    case checkbox(CheckboxView.ViewProperties)
    case radio(RadioView.ViewProperties)
    case button(ButtonView.ViewProperties)
}

public enum Molecule {
    case titleWithSubtitle(LabelView.ViewProperties, LabelView.ViewProperties)
    case titleWithSubtitles(LabelView.ViewProperties, [LabelView.ViewProperties])
    case subtitleWithTitle(LabelView.ViewProperties, LabelView.ViewProperties)
    case icons20([ImageView.ViewProperties])
    case indexWithIcon24(LabelView.ViewProperties, ImageView.ViewProperties)
    case indexWithIcons20(LabelView.ViewProperties, [ImageView.ViewProperties])
    case indexWithToggle(LabelView.ViewProperties, ToggleView.ViewProperties)
    case buttonWithSubindex(ButtonView.ViewProperties, LabelView.ViewProperties)
}

public enum RowBlocks {
    case atom(Atom)
    case molecule(Molecule)
}
