//
//  MasterViewController.swift
//  Item.Scrapper
//
//  Created by geunho.khim on 2014. 9. 28..
//  Copyright (c) 2014년 com.ebay.kr.gkhim. All rights reserved.
//

import UIKit
import CoreData


class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
    let itemViewCellIdentifier = "ItemViewCell"
    
    weak var dynamicsDrawerViewController: MSDynamicsDrawerViewController?
    var managedObjectContext: NSManagedObjectContext? = nil
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    var fetchedItems = [ItemEntity]()
    var filteredItems = [ItemEntity]()
    
    // MARK: - UIViewController life cyle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.refetch()
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let leftButton = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: "openDrawer")
        self.navigationItem.leftBarButtonItem = leftButton
        
        let rightButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "reload:")
        self.navigationItem.rightBarButtonItem = rightButton
        
        var nib = UINib(nibName: itemViewCellIdentifier, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: itemViewCellIdentifier)
        searchDisplayController?.searchResultsTableView.registerNib(nib, forCellReuseIdentifier: itemViewCellIdentifier)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func openDrawer() {
        self.dynamicsDrawerViewController?.setPaneState(.Open, animated: true, allowUserInterruption: true, completion: nil)
    }
    
    func reload(sender: AnyObject) {
        self.refetch()
        self.tableView.reloadData()
    }
    
    func refetch() {
        _fetchedResultsController = nil
        _fetchedResultsController = self.fetchedResultsController
    }
    
    // MARK: - UITableViewController Delegate/DataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var numberOfSections = self.fetchedResultsController.sections?.count ?? 0
        return numberOfSections
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return filteredItems.count
        } else {
            return fetchedItems.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(itemViewCellIdentifier, forIndexPath: indexPath) as ItemViewCell

        var item: ItemEntity
        if tableView == self.searchDisplayController!.searchResultsTableView {
            item = filteredItems[indexPath.row]
        } else {
            item = fetchedItems[indexPath.row]
        }
        
        self.configureCell(cell, toItem: item)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height: CGFloat = UIDevice.currentDevice().userInterfaceIdiom == .Pad ? 120 : 90
        
        return height
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var item: ItemEntity
        if tableView == self.searchDisplayController!.searchResultsTableView {
            item = filteredItems[indexPath.row]
        } else {
            item = fetchedItems[indexPath.row]
        }
        
        var linkUrl = item.linkUrl
        var url: NSURL = NSURL(string: linkUrl.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
        UIApplication.sharedApplication().openURL(url)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let context = self.fetchedResultsController.managedObjectContext
            context.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject)
            
            var error: NSError? = nil
            if !context.save(&error) {
                println("Unresolved error \(error), \(error?.description)")
            }
        }
    }
    
    func formatPriceFromNumber(number: NSNumber) -> String {
        var formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = NSLocale.currentLocale()

        var formatPrice:String = formatter.stringFromNumber(number)!
        
        return formatPrice
    }
    
    func configureCell(cell: ItemViewCell, toItem item: ItemEntity) {
        var imageUrl: String = item.imageUrl
        var url: NSURL = NSURL(string: imageUrl)!
        
        cell.mainImageView.sd_setImageWithURL(url, placeholderImage: nil)
        cell.titleLabel.text = item.title
        cell.priceLabel.text = formatPriceFromNumber(item.price)
        cell.linkUrl = item.linkUrl
    }
    
    // MARK: - UISearchDisplayController delegate
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    
    func filterContentForSearchText(searchText: String) {
        filteredItems = fetchedItems.filter({(item: ItemEntity) -> Bool in
            let stringMatch = item.title.lowercaseString.rangeOfString(searchText.lowercaseString)
            return stringMatch != nil
        })
    }
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("ItemEntity", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        
        fetchRequest.fetchBatchSize = 100
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        let sortDescriptors = [sortDescriptor]
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        _fetchedResultsController = fetchedResultsController
        
        var error: NSError? = nil
        if !_fetchedResultsController!.performFetch(&error) {
            println("Unresolved error \(error), \(error?.description)")
        }
        
        fetchedItems = _fetchedResultsController?.fetchedObjects as [ItemEntity]
        SharedInstance.singleton().fetchedItems = fetchedItems
        
        return _fetchedResultsController!
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            // TODO: update cell title and price label
//        case .Update:
//            self.configureCell(tableView.cellForRowAtIndexPath(indexPath!)!, atIndexPath: indexPath!)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
}
