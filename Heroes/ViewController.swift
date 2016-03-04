//
//  ViewController.swift
//  Heroes
//
//  Created by Lui de la parra on 3/2/16.
//  Copyright © 2016 Lui de la parra. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var updateButton: UIButton!

    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    var jsonArray:NSMutableArray?
    var newArray: Array<String> = []
    var IDArray: Array<String> = []
    
    override func viewDidLoad() {
        
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
        
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "downloadAndUpdate", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView?.addSubview(refreshControl)
        self.downloadAndUpdate()
        
    }
    
    func downloadAndUpdate() {
        self.newArray.removeAll()
        self.IDArray.removeAll()
        print("Calling...")
        Alamofire.request(.GET, "http://localhost:3000/api/heroes") .responseJSON { response in
            if let JSON = response.result.value {
                self.jsonArray = JSON as? NSMutableArray
                for item in self.jsonArray! {
                    let string = item["heroName"]!
                    let ID = item["_id"]!
                    
                    self.newArray.append(string! as! String)
                    self.IDArray.append(ID! as! String)
                    
                }
                
                print("New array is \(self.newArray)")
                
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = self.newArray[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            print("ID is \(self.IDArray[indexPath.row])")
            
            Alamofire.request(.DELETE, "https://rocky-meadow-1164.herokuapp.com/todo/\(self.IDArray[indexPath.row])")
            
            self.downloadAndUpdate()
            // Delete the row from the data source
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    @IBAction func updateButton(sender: UIButton){
        print("button pressed")
        self.downloadAndUpdate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

