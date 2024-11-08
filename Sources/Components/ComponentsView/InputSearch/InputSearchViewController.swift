//
//  InputSearchViewController.swift
//  iOS.Resources.UiComponents
//
//  Created by user on 08.11.2024.
//

import UIKit

public final class InputSearchViewController: UISearchController, ComponentProtocol {
    
    // MARK: - Properties
    
    public struct ViewProperties {
        public var inputSearch: InputSearchView
        
        public init(
            inputSearch: InputSearchView = .init()
        ) {
            self.inputSearch = inputSearch
        }
    }
    
    public override var searchBar: UISearchBar { inputSearch }
    
    // MARK: - Private properties
    
    private var inputSearch = InputSearchView()
    
    // MARK: - Life cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    // MARK: - Methods
    
    public func update(with viewProperties: ViewProperties) {
        inputSearch = viewProperties.inputSearch
    }
}
