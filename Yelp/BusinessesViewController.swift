//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Archit Rathi
//  Copyright (c) 2016 Archit Rathi. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate,UIScrollViewDelegate {
    
    
    var businesses: [Business]!
    var filteredData: [Business]!
    var searchBar: UISearchBar!
    @IBOutlet weak var mainNavigationItem: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    var searchActive : Bool = false
    var tap : UITapGestureRecognizer!
    var isMoreDataLoading = false
    var refreshControl: UIRefreshControl!
    var lastSearched: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        searchBar.delegate = self;
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let storedSearch = defaults.objectForKey("storedSearch") as? String {
            lastSearched = storedSearch
        }
        else {
            lastSearched = "Indian"
        }
        
        Business.searchWithTerm(lastSearched, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.filteredData = businesses
            self.tableView.reloadData()
        })
        defaults.setObject(lastSearched, forKey: "storedSearch")
        defaults.synchronize()
        
        searchBar.text = lastSearched
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses!.count
        }
        else{
            return 0
        }
    }
    
    
    
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar){
        self.tap = UITapGestureRecognizer(target: self, action: "endEditing")
        view.addGestureRecognizer(tap)
        
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar){
        view.removeGestureRecognizer(tap)
    }
    
    
    func endEditing(){
        searchBar.resignFirstResponder()
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
        delay(2, closure: {
            self.refreshControl.endRefreshing()
        })
        
        Business.searchWithTerm(lastSearched, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.filteredData = businesses
            self.tableView.reloadData()
        })
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(lastSearched, forKey: "storedSearch")
        defaults.synchronize()
        
        self.refreshControl?.endRefreshing()
    }
    

    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        Business.searchWithTerm(searchBar.text!, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.filteredData = businesses
            self.tableView.reloadData()
        })
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(searchBar.text!, forKey: "storedSearch")
        defaults.synchronize()
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        filteredData = businesses
        self.tableView.reloadData()
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                
                // ... Code to load more results ...
                
            }
        }
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let business = filteredData![(indexPath?.row)!]
        let detailBusinessViewController = segue.destinationViewController as! DetailBusinessViewController
        detailBusinessViewController.business = business
    }

}
