//
//  LeftNavDrawerViewController.swift
//  Example
//
//  Created by Kishy Kumar on 2/18/16.
//  Copyright © 2016 MyComp. All rights reserved.
//

import UIKit

class LeftNavDrawerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var menuItems: [String] = ["Settings", "Payment"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let mycell = tableView.dequeueReusableCellWithIdentifier("LeftNavDrawerCellIdentifier", forIndexPath: indexPath) as! LeftNavDrawerTableViewCell
        mycell.menuItemLabel.text = menuItems[indexPath.row]
        return mycell
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
