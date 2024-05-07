//
//  RowsService.swift
//
//
//  Created by Омельченко Юлия on 03.05.2024.
//

import UIKit

final class RowsService {
    public func createCellRowWithBloks(tableView: UITableView,
                                       indexPath: IndexPath,
                                       leading: RowBlocks? = nil,
                                       center: RowBlocks? = nil,
                                       trailing: RowBlocks? = nil) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RowCell", for: indexPath) as? RowCell
        
        let rowView = createViewRowWithBloks(leading: leading,
                                             center: center,
                                             trailing: trailing)
        
        cell?.customView = rowView
        
        return cell ?? UITableViewCell()
    }
    
    public func createViewRowWithBloks(leading: RowBlocks? = nil,
                                       center: RowBlocks? = nil,
                                       trailing: RowBlocks? = nil) -> UIView {
        let container = RowBaseContainer()
        
        let margins = RowBaseContainer.ViewProperties.Margins(
            leading: 16,
            trailing: 16,
            top: 14,
            bottom: 14,
            spacing: 16)
        
        let rowBlocksService = RowBlocksService()
        
        let leadingView = rowBlocksService.createRowBlock(leading)
        let centerView = rowBlocksService.createRowBlock(center)
        let trailingView = rowBlocksService.createRowBlock(trailing)
        
        let containerViewProperty = RowBaseContainer.ViewProperties(
            leadingView: leadingView,
            centerView: centerView,
            trailingView: trailingView,
            viewsHeight: 44,
            margins: margins)
        
        container.update(with: containerViewProperty)
        
        return container
    }
}
