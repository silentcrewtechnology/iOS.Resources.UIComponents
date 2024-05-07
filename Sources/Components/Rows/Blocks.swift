//
//  Blocks.swift
//  
//
//  Created by Омельченко Юлия on 18.04.2024.
//

import UIKit

public enum Atom {
    case title(LabelView.ViewProperties)
    case subtitle(LabelView.ViewProperties)
    case image40(UIImage)
    case image40x48(UIImage)
    case index(LabelView.ViewProperties)
    case icon24(UIImage)
    case icon20(UIImage)
    case `switch`
    case amountText(LabelView.ViewProperties)
    case checkbox(CheckboxView.ViewProperties)
    case radio(RadioView.ViewProperties)
    case button(ButtonView.ViewProperties)
    case copyText(LabelView.ViewProperties)
}

public enum Molecule {
    case titleWithSubtitle(LabelView.ViewProperties, LabelView.ViewProperties)
    case subtitleWithTitle(LabelView.ViewProperties, LabelView.ViewProperties)
    case icons20([UIImage])
    case indexWithcIcon24(LabelView.ViewProperties, UIImage)
    case indexWithIcons20(LabelView.ViewProperties, [UIImage])
    case indexWithSwitch(LabelView.ViewProperties)
}

public enum RowBlocks {
    case atom(Atom)
    case molecule(Molecule)
}
