import Foundation
import UIKit

class ThingsTableViewControler: UITableViewController, Transition {
    
    struct TableViewConstants {
        static let cellIdentifier = "Cell"
        static let rowHeight: CGFloat = 60
        static let estimatedRowHeight: CGFloat = 180
    }
    
    var viewModel = ThingsTableViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeTableView()
    }
    
    private func initializeTableView() {
        tableView.estimatedRowHeight = TableViewConstants.estimatedRowHeight
        tableView.rowHeight = TableViewConstants.rowHeight
        tableView.separatorColor = UIColor.black
        tableView.separatorStyle = .singleLine
        tableView.register(ThingCell.self, forCellReuseIdentifier: TableViewConstants.cellIdentifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.datasourceCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewConstants.cellIdentifier) as? ThingCell else {
            fatalError("Cell not registered")
        }
        
        viewModel.bindModelWithView(cell: cell, at: indexPath)
        
        let thingModel = viewModel.thing(for: indexPath)
        cell.update(withText: thingModel.name)
        cell.update(withLikeValue: thingModel.like)
        
        if let urlString = thingModel.image {
            viewModel.imageProvider.imageAsync(from: urlString, completion: { (image, imageUrl) in
                cell.updateThingImage(image)
            })
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let thingModel = viewModel.thing(for: indexPath)
        pushDetailsViewController(thingModel)
    }
    
    func pushDetailsViewController(_ thingModel: ThingModel) {
        let detailsViewController = ThingDetailsViewController()
        detailsViewController.thingModel = thingModel
        detailsViewController.imageProvider = viewModel.imageProvider
        detailsViewController.delegate = self
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

// MARK: - ThingDetailsDelegate Extension
extension ThingsTableViewControler: ThingDetailsDelegate {
    func thingDetails(viewController: ThingDetailsViewController, didLike thingModel: inout ThingModel) {
        thingModel.setLike(value: true)
        viewController.navigationController?.popViewController(animated: true)
    }
    
    func thingDetails(viewController: ThingDetailsViewController, didDislike thingModel: inout ThingModel) {
        thingModel.setLike(value: false)
        viewController.navigationController?.popViewController(animated: true)
    }
}






































































