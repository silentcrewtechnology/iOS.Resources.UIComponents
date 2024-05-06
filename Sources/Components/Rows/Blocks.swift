//
//  Blocks.swift
//  
//
//  Created by Омельченко Юлия on 18.04.2024.
//

import UIKit

public enum Atom {
    case title(NSAttributedString)
    case subtitle(NSAttributedString)
    case image(UIImage)
    case index(NSAttributedString)
    case icon24(UIImage)
    case icon20(UIImage)
    case `switch`(() -> Bool)
    case chips(() -> Void)
    case amountText(NSAttributedString)
    case checkbox(() -> Bool)
    case radio(() -> Bool)
    case textButton(NSAttributedString, () -> Void)
    case coloredPrefix(NSAttributedString)
    case copyText(NSAttributedString)
}

public enum Molecule {
    case titleWithSubtitle(NSAttributedString, NSAttributedString)
    case subtitleWithTitle(NSAttributedString, NSAttributedString)
    case icons20([UIImage])
    case indexWithcIcon24(NSAttributedString, UIImage)
    case indexWithIcons20(NSAttributedString, [UIImage])
    case indexWithSwitch(NSAttributedString, () -> Bool)
    case amountTextWithColoredPrefix(NSAttributedString, NSAttributedString)
    case amountTextWithTextButton(NSAttributedString, NSAttributedString, () -> Void)
}

public enum RowBlocks {
    case atom(Atom)
    case molecule(Molecule)
}
