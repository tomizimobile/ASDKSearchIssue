//
//  ViewController.swift
//  asdk.searchTest
//
//  Created by Tom King on 11/19/15.
//  Copyright © 2015 iZi Mobile. All rights reserved.
//

import UIKit
import AsyncDisplayKit

let sectionTitles = [UITableViewIndexSearch, "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
let data = ["Victoria Graden", "Cheree Sherk", "Jorge Darcy", "Nedra Noles", "Lan Proctor", "Forrest Strain", "Erlinda Worthy", "Jimmy Slezak", "Fe Norling", "Tinisha Pichardo", "Bethanie Larochelle", "Natasha Mccloskey", "Shanti Perkinson", "Valencia Palmisano", "Erin Sorg", "Brad Minger", "Akilah Verde", "Eda Takacs", "Yee Roby", "Christoper Galligan"]

class ViewController: UIViewController, ASTableViewDataSource, ASTableViewDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var searchBar: UISearchBar!
#if USE_UIKIT
    var tableView: UITableView!
#else
    var tableView: ASTableView!
#endif
    
    // section title, [name]
    private var sections = [String : [String]]() {
        didSet {
            sortedKeys = sections.keys.sort { left, right -> Bool in
                return left.compare(right, options: [], range: nil, locale: nil) == NSComparisonResult.OrderedAscending
            }
        }
    }
    var sortedKeys: [String]!
    var predicate: NSPredicate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        view.addSubview(searchBar)
        
#if USE_UIKIT
        tableView = UITableView(frame: self.view.bounds, style: .Plain)
        tableView.dataSource = self
        tableView.delegate = self
#else
        tableView = ASTableView(frame: self.view.bounds, style: .Plain, asyncDataFetching: true)
        tableView.asyncDataSource = self
        tableView.asyncDelegate = self
#endif
        tableView.keyboardDismissMode = .OnDrag
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[searchBar]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["searchBar" : searchBar]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["tableView" : tableView]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[topLayoutGuide][searchBar][tableView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["topLayoutGuide" : topLayoutGuide, "searchBar" : searchBar, "tableView" : tableView]))
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        applyPredicate()
    }
    
    private func applyPredicate()
    {
        let filteredNames: [String]
        if let pred = predicate
        {
            filteredNames = (data as NSArray).filteredArrayUsingPredicate(pred) as! [String]
        }
        else
        {
            filteredNames = data
        }
        
        var sections = [String : [String]]()
        
        for name in filteredNames
        {
            let firstLetter = (name as NSString).substringToIndex(1).stringByFoldingWithOptions(NSStringCompareOptions.DiacriticInsensitiveSearch, locale: NSLocale.currentLocale()).uppercaseString
            if var data = sections[firstLetter]
            {
                data.append(name)
                sections[firstLetter] = data
            }
            else
            {
                sections[firstLetter] = [name]
            }
        }
        
        let oldSections = self.sections
        let oldSortedKeys = sortedKeys
        self.sections = sections
        
        if tableView.numberOfSections == 0
        {
            tableView.reloadData()
        }
        else
        {
            let sectionsToInsert = NSMutableIndexSet()
            let sectionsToDelete = NSMutableIndexSet()
            var indexPathsToInsert = [NSIndexPath]()
            var indexPathsToDelete = [NSIndexPath]()
            for sectionObject in oldSections
            {
                let key = sectionObject.0
                let section = oldSortedKeys.indexOf(key)!
                if let currentSection = self.sections[key]
                {
                    let oldFriends = sectionObject.1
                    for (index, friend) in oldFriends.enumerate()
                    {
                        if currentSection.indexOf(friend) == nil
                        {
                            indexPathsToDelete.append(NSIndexPath(forRow: index, inSection: section))
                        }
                    }
                }
                else
                {
                    sectionsToDelete.addIndex(section)
                }
            }
            for sectionObject in self.sections
            {
                let key = sectionObject.0
                let section = self.sortedKeys.indexOf(key)!
                if let oldSection = oldSections[key]
                {
                    let friends = sectionObject.1
                    for (index, friend) in friends.enumerate()
                    {
                        if oldSection.indexOf(friend) == nil
                        {
                            indexPathsToInsert.append(NSIndexPath(forRow: index, inSection: section))
                        }
                    }
                }
                else
                {
                    sectionsToInsert.addIndex(section)
                    let friends = sectionObject.1
                    for i in 0..<friends.count
                    {
                        indexPathsToInsert.append(NSIndexPath(forRow: i, inSection: section))
                    }
                }
            }
//            NSLog("indexPathsToDelete: \(indexPathsToDelete)")
//            NSLog("sectionsToDelete: \(sectionsToDelete)")
//            NSLog("sectionsToInsert: \(sectionsToInsert)")
//            NSLog("indexPathsToInsert: \(indexPathsToInsert)")
            UIView.setAnimationsEnabled(false)
            tableView.beginUpdates()
            if indexPathsToDelete.count > 0
            {
                tableView.deleteRowsAtIndexPaths(indexPathsToDelete, withRowAnimation: .None)
            }
            if sectionsToDelete.count > 0
            {
                tableView.deleteSections(sectionsToDelete, withRowAnimation: .None)
            }
            if sectionsToInsert.count > 0
            {
                tableView.insertSections(sectionsToInsert, withRowAnimation: .None)
            }
            if indexPathsToInsert.count > 0
            {
                tableView.insertRowsAtIndexPaths(indexPathsToInsert, withRowAnimation: .None)
            }
            tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return sections[sortedKeys[section]]!.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return sortedKeys[section]
    }
    
    func tableView(tableView: ASTableView!, nodeForRowAtIndexPath indexPath: NSIndexPath!) -> ASCellNode!
    {
        let node = ASTextCellNode()
        node.text = sections[sortedKeys[indexPath.section]]![indexPath.row]
        return node
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell.textLabel?.text = sections[sortedKeys[indexPath.section]]![indexPath.row]
        return cell
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        let words = searchText.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        var subpredicates = [NSPredicate]()
        for word in words
        {
            if word.characters.count == 0
            {
                continue
            }
            subpredicates.append(NSPredicate(format: "SELF contains[cd] %@", word))
        }
        predicate = NSCompoundPredicate(andPredicateWithSubpredicates: subpredicates)
        applyPredicate()
    }
}

