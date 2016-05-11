//
//  ViewController.swift
//  Homepwner
//
//  Created by Alexio Mota on 5/10/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {

    var firstSectionItemStore: ItemStore!
    var secondSectionItemStore: ItemStore!
    
    @IBAction func addNewItem(sender: AnyObject) {
        // Create a new item and add it to the store
        let newItem = firstSectionItemStore.createItem()
        // Figure out where that item is in the array
        if let index = firstSectionItemStore.allItems.indexOf(newItem) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            // Insert this new row into the table
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    @IBAction func toggleEditingMode(sender: AnyObject) {
        // If you are currently in editing mode...
        if editing {
            // Change text of button to inform user of state
            sender.setTitle("Edit", forState: .Normal)
            // Turn off editing mode
            setEditing(false, animated: true)
        }
        else {
            // Change text of button to inform user of state
            sender.setTitle("Done", forState: .Normal)
            // Enter editing mode
            setEditing(true, animated: true)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Get the height of the status bar
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if ( section == 0) {
            return "First Section"
        } else {
            return "Second Section"
        }
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section != 1 {
            return nil
        }
        
        let view = UIView()
        
        let version = UILabel(frame: CGRectMake(8, 15, tableView.frame.width, 30))
        version.font = version.font.fontWithSize(14)
        version.text = "No More Items!"
        version.textColor = UIColor.lightGrayColor()
        version.textAlignment = .Center;
        
        view.addSubview(version)
        
        return view
    }
    
    private func getSectionStore(sectionIndex: Int) -> ItemStore {
        return sectionIndex == 0 ? firstSectionItemStore : secondSectionItemStore;
    }
    
    override func tableView(tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return getSectionStore(section).allItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Get a new or recycled cell
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath)
        // Set the text on the cell with the description of the item
        // that is at the nth index of items, where n = row this cell
        // will appear in on the tableview
        print("SectionIndex: " + indexPath.section.description)
        print("RowIndex: " + indexPath.row.description)
        let item = getSectionStore(indexPath.section).allItems[indexPath.row]
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = "$\(item.valueInDollars)"
        return cell
    }
    
    override func tableView(tableView: UITableView,commitEditingStyle editingStyle: UITableViewCellEditingStyle,
                            forRowAtIndexPath indexPath: NSIndexPath) {
        // If the table view is asking to commit a delete command...
        let itemStore: ItemStore = getSectionStore(indexPath.section)
        
        if editingStyle == .Delete {
            let item = itemStore.allItems[indexPath.row]
            
            let title = "Remove \(item.name)?"
            let message = "Are you sure you want to delete this item?"
            let ac = UIAlertController(title: title,
                                       message: message,
                                       preferredStyle: .ActionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            ac.addAction(cancelAction)
            let deleteAction = UIAlertAction(title: "Delete", style: .Destructive,
                                             handler: { (action) -> Void in
                                                // Remove the item from the store 
                                                itemStore.removeItem(item)
                                                // Also remove that row from the table view with an animation
                                                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic) })
            ac.addAction(deleteAction)
            
            // Present the alert controller
            presentViewController(ac, animated: true, completion: nil)
        }
    }
    
    override func tableView(tableView: UITableView,
                            moveRowAtIndexPath sourceIndexPath: NSIndexPath,
                                               toIndexPath destinationIndexPath: NSIndexPath) {
        let sourceStore = getSectionStore(sourceIndexPath.section);
        let destinationStore = getSectionStore(destinationIndexPath.section)
            
        let item: Item = sourceStore.allItems.removeAtIndex(sourceIndexPath.row)
        destinationStore.allItems.insert(item, atIndex: destinationIndexPath.row)
    }
}

