//
//  MasterViewController.swift
//  Item.Scrapper
//
//  Created by geunho.khim on 2014. 9. 28..
//  Copyright (c) 2014년 com.ebay.kr.gkhim. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
    let itemViewCellIdentifier = "ItemViewCell"
    let itemFooterViewIdentifier = "ItemFooterView"
    
    weak var dynamicsDrawerViewController: MSDynamicsDrawerViewController?
    weak var menuViewController: MenuViewController?
    
    var managedObjectContext: NSManagedObjectContext? = nil
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    var filteredItems = [ItemEntity]()
    
    var domainIcons: [String: UIImage] = [String: UIImage]()
    
    var isSearch: Bool = false
    
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
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 57/255.0, green: 57/255.0, blue: 57/255.0, alpha: 1)];
        
        let leftButton = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: "openDrawer")
        self.navigationItem.leftBarButtonItem = leftButton
        
        let rightButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "reload:")
        self.navigationItem.rightBarButtonItem = rightButton
        
        var nib = UINib(nibName: itemViewCellIdentifier, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: itemViewCellIdentifier)
        searchDisplayController?.searchResultsTableView.registerNib(nib, forCellReuseIdentifier: itemViewCellIdentifier)
        
        domainIcons["auction"] = UIImage(named: "auction-icon.png")
        domainIcons["gmarket"] = UIImage(named: "gmarket-icon.png")
        domainIcons["ebay"] = UIImage(named: "ebay-icon.png")
        domainIcons["g9"] = UIImage(named: "g9-icon.png")
        domainIcons["11st"] = UIImage(named: "11st-icon.png")
        domainIcons["coupang"] = UIImage(named: "coupang-icon.png")
        domainIcons["tmon"] = UIImage(named: "tmon-icon.png")
        domainIcons["amazon"] = UIImage(named: "amazon-icon.png")
        
        self.menuViewController?.updateSummarization(self.fetchedResultsController.fetchedObjects)
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
        
        self.menuViewController?.updateSummarization(self.fetchedResultsController.fetchedObjects)
    }
    
    func isAppInstalled(scheme: String) -> Bool {
        return UIApplication.sharedApplication().canOpenURL(NSURL(string: scheme)!)
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
            let sectionInfo = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
            return sectionInfo.numberOfObjects
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(itemViewCellIdentifier, forIndexPath: indexPath) as ItemViewCell

        var item: ItemEntity
        if tableView == self.searchDisplayController!.searchResultsTableView {
            item = filteredItems[indexPath.row]
        } else {
            item = self.fetchedResultsController.objectAtIndexPath(indexPath) as ItemEntity
        }
        
        self.configureCell(cell, toItem: item)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height: CGFloat = UIDevice.currentDevice().userInterfaceIdiom == .Pad ? 120 : 90
        
        return height
    }
    
//    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(itemFooterViewIdentifier) as ItemFooterView
//        
//        if let price = SharedInstance.singleton().totalAmount?.stringValue {
//            
//        } else {
//            return nil
//        }
//        
//        return footerView
//    }
//    
//    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 30
//    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var item: ItemEntity
        if tableView == self.searchDisplayController!.searchResultsTableView {
            item = filteredItems[indexPath.row]
        } else {
            item = self.fetchedResultsController.objectAtIndexPath(indexPath) as ItemEntity
        }
        
        var linkUrl = item.linkUrl
        if linkUrl.hasPrefix("http://mitem") && isAppInstalled("gmarket:") {
            linkUrl = "gmarket://item?itemid=\(item.itemno)"
        }
        
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
        var domain: String = item.kindOf
        
        cell.mainImageView.sd_setImageWithURL(url, placeholderImage: nil)
        
        if let domainIcon: UIImage = domainIcons[domain] {
            cell.domainIcon.image = domainIcon
            cell.domainIcon.hidden = false
        } else {
            cell.domainIcon.hidden = true
        }
        
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
        filteredItems = (self.fetchedResultsController.fetchedObjects as [ItemEntity]).filter({(item: ItemEntity) -> Bool in
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
        
//        SharedInstance.singleton().fetchedItems = _fetchedResultsController?.fetchedObjects as [ItemEntity]
        
        return _fetchedResultsController!
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
//    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
//        switch type {
//        case .Insert:
//            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
//        case .Delete:
//            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
//        default:
//            return
//        }
//    }
    
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
        self.menuViewController?.updateSummarization(self.fetchedResultsController.fetchedObjects)
    }
}
