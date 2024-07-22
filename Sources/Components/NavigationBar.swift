//
//  File.swift
//  
//
//  Created by user on 22.07.2024.
//

import UIKit

public class NavigationBar: UINavigationController {
    
    // MARK: - Properties
    
    public struct ViewProperties {
        public var leftBarButtonItems: [UIBarButtonItem]?
        public var rightBarButtonItems: [UIBarButtonItem]?
        public var titleView: UIView?
        public var title: String?
        public var largeTitleDisplayMode: UINavigationItem.LargeTitleDisplayMode
        public var prefersLargeTitles: Bool
        public var standartAppearance: UINavigationBarAppearance
        public var compactAppearance: UINavigationBarAppearance?
        public var scrollEdgeAppearance: UINavigationBarAppearance?
        public var searchController: UISearchController?
        public var hidesSearchBarWhenScrolling: Bool
        public var isNavigationBarHidden: Bool
        
        public init(
            leftBarButtonItems: [UIBarButtonItem]? = nil,
            rightBarButtonItems: [UIBarButtonItem]? = nil,
            titleView: UIView? = nil, 
            title: String? = nil,
            largeTitleDisplayMode: UINavigationItem.LargeTitleDisplayMode = .automatic,
            prefersLargeTitles: Bool = false,
            standartAppearance: UINavigationBarAppearance = .init(),
            compactAppearance: UINavigationBarAppearance? = nil,
            scrollEdgeAppearance: UINavigationBarAppearance? = nil,
            searchController: UISearchController? = nil,
            hidesSearchBarWhenScrolling: Bool = true,
            isNavigationBarHidden: Bool = false
        ) {
            self.leftBarButtonItems = leftBarButtonItems
            self.rightBarButtonItems = rightBarButtonItems
            self.titleView = titleView
            self.title = title
            self.largeTitleDisplayMode = largeTitleDisplayMode
            self.prefersLargeTitles = prefersLargeTitles
            self.standartAppearance = standartAppearance
            self.compactAppearance = compactAppearance
            self.scrollEdgeAppearance = scrollEdgeAppearance
            self.searchController = searchController
            self.hidesSearchBarWhenScrolling = hidesSearchBarWhenScrolling
            self.isNavigationBarHidden = isNavigationBarHidden
        }
    }
    
    // MARK: - Private properties
    
    private var viewProperties: ViewProperties = .init()
    
    // MARK: - Methods
    
    public func update(with viewProperties: ViewProperties) {
        self.viewProperties = viewProperties
        
        isNavigationBarHidden = viewProperties.isNavigationBarHidden
        updateNavigationBar(with: viewProperties)
        updateNavigationItem(with: viewProperties)
    }
    
    // MARK: - Private methods
    
    private func updateNavigationBar(with viewProperties: ViewProperties) {
        navigationBar.prefersLargeTitles = viewProperties.prefersLargeTitles
        navigationBar.standardAppearance = viewProperties.standartAppearance
        navigationBar.scrollEdgeAppearance = viewProperties.scrollEdgeAppearance
        navigationBar.compactAppearance = viewProperties.compactAppearance
    }
    
    private func updateNavigationItem(with viewProperties: ViewProperties) {
        visibleViewController?.navigationItem.leftBarButtonItems = viewProperties.leftBarButtonItems
        visibleViewController?.navigationItem.rightBarButtonItems = viewProperties.rightBarButtonItems
        visibleViewController?.navigationItem.titleView = viewProperties.titleView
        visibleViewController?.navigationItem.title = viewProperties.title
        visibleViewController?.navigationItem.largeTitleDisplayMode = viewProperties.largeTitleDisplayMode
        visibleViewController?.navigationItem.searchController = viewProperties.searchController
        visibleViewController?.navigationItem.hidesSearchBarWhenScrolling = viewProperties.hidesSearchBarWhenScrolling
    }
}
