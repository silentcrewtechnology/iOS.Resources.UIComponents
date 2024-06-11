import UIKit

public struct CreationRowsViewService {
    public init() { }
    
    public func createCellRowWithBlocks(
        tableView: UITableView,
        indexPath: IndexPath,
        leading: RowBlocks? = nil,
        center: RowBlocks? = nil,
        trailing: RowBlocks? = nil,
        cellIdentifier: String = "RowCell"
    ) -> UITableViewCell {
        // Проверяем, зарегистрирована ли ячейка
        if tableView.dequeueReusableCell(withIdentifier: cellIdentifier) == nil {
            tableView.register(RowCell.self, forCellReuseIdentifier: cellIdentifier)
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RowCell
        
        let rowView = createViewRowWithBlocks(leading: leading,
                                              center: center,
                                              trailing: trailing)
        
        cell?.customView = rowView
        
        return cell ?? UITableViewCell()
    }
    
    public func createViewRowWithBlocks(
        leading: RowBlocks? = nil,
        center: RowBlocks? = nil,
        trailing: RowBlocks? = nil,
        margins: RowBaseContainer.ViewProperties.Margins? = nil
    ) -> UIView {
        let container = RowBaseContainer()
        
        let newMargins = margins ?? RowBaseContainer.ViewProperties.Margins(
            leading: 16,
            trailing: 16,
            top: 14,
            bottom: 14,
            spacing: 16
        )
        
        let leadingView = RowBlocksService().createRowBlock(leading)
        let centerView = RowBlocksService().createRowBlock(center)
        let trailingView = RowBlocksService().createRowBlock(trailing)
        
        let containerViewProperty = RowBaseContainer.ViewProperties(
            leadingView: leadingView,
            centerView: centerView,
            trailingView: trailingView,
            margins: newMargins)
        
        container.update(with: containerViewProperty)
        
        return container
    }
}
