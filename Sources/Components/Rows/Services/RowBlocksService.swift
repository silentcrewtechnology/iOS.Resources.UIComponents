//
//  RowBlocksService.swift
//
//
//  Created by Омельченко Юлия on 18.04.2024.
//

import UIKit

final class RowBlocksService {
    public func createRowBlock(_ block: RowBlocks?) -> UIView? {
        guard let block else { return nil }
        switch block {
        case .atom(let atom):
            return createAtom(atom)
        case .molecule(let molecule):
            return createMolecule(molecule)
        }
    }
}

private extension RowBlocksService {
    private func createAtom(_ atom: Atom) -> UIView {
        let atomService = AtomService()
        return atomService.createAtom(atom)
    }
    
    private func createMolecule(_ molecule: Molecule) -> UIView {
        let moleculeService = MoleculeService()
        return moleculeService.createMolecule(molecule)
    }
}
