//
//  AboutViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 4/5/16.
//  Copyright © 2016 YibbyPartner. All rights reserved.
//

import UIKit
import CocoaLumberjack

public class AboutViewController: BaseYibbyViewController {
    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profilePictureOutlet: UIImageView!
    @IBOutlet weak var userRealNameLabelOutlet: UILabel!
    @IBOutlet weak var aboutButtonOutlet: UIButton!
    @IBOutlet weak var signOutButtonOutlet: UIButton!
    
    @IBOutlet weak var rateUsButtonOutlet: UIButton!
    @IBOutlet weak var likeUsButtonOutlet: UIButton!
    
    var photoSaveCallback: ((UIImage) -> Void)?
    
    let menuItems: [String] = ["TRIPS",   "PAYMENT",  "SETTINGS", "NOTIFICATIONS",    "SUPPORT",      "PROMOTIONS",   "DRIVE"]
    let menuItemsIconFAFormat: [Int] =  [0xf1ba,    0xf283,     0xf085,     0xf0f3,             0xf1cd,         0xf0a3,         0xf0e4]
    
    let PROFILE_PICTURE_URL_KEY: String = "PROFILE_PICTURE_URL_KEY"
    
    enum TableIndex: Int {
        case Trips = 0
        case Payment
        case Settings
        case Notifications
        case Support
        case Promotions
        case Drive
    }
    
    // MARK: - Actions
    
    
    
    // MARK: - Setup Functions
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        setupViews()
        setupDefaultValues()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupUI() {
        setupBackButton()
        
        rateUsButtonOutlet.layer.borderColor = UIColor.borderColor().cgColor
        rateUsButtonOutlet.layer.borderWidth = 1.0
        rateUsButtonOutlet.layer.cornerRadius = 7
        
        likeUsButtonOutlet.layer.borderColor = UIColor.borderColor().cgColor
        likeUsButtonOutlet.layer.borderWidth = 1.0
        likeUsButtonOutlet.layer.cornerRadius = 7
    }
    
    private func setupViews() {
        
    }
    
    private func setupDefaultValues() {
        
    }
    
    // MARK: Tableview Delegate/DataSource
    
    open func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let mycell = tableView.dequeueReusableCell(withIdentifier: "LeftNavDrawerCellIdentifier", for: indexPath) as! LeftNavDrawerTableViewCell
        
        
        // set the label
        mycell.menuItemLabel.text = menuItems[indexPath.row]
        
        // set the icon
        mycell.menuItemIconLabelOutlet.font = UIFont(name: "FontAwesome", size: 20)
        mycell.menuItemIconLabelOutlet.text = String(format: "%C", menuItemsIconFAFormat[indexPath.row])
        
        return mycell
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let tHeight = tableView.bounds.height
        let height = tHeight/CGFloat(menuItems.count)
        
        return height
    }
    
    public func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
    }
    
    // MARK: - rateUsOnGooglePlayBtnAction
    
    @IBAction func rateUsOnGooglePlayBtnAction(sender: AnyObject) {
    }
    
    // MARK: - likeUsOnGooglePlayBtnAction
    @IBAction func likeUsOnGooglePlayBtnAction(sender: AnyObject) {
    }
    
    // MARK: - legalBtnAction
    @IBAction func legalBtnAction(sender: AnyObject) {
    }
    
    // MARK: - Helpers
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
