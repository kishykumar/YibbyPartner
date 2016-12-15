//
//  OfferSentViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 3/13/16.
//  Copyright © 2016 MyComp. All rights reserved.
//

import UIKit
import CocoaLumberjack
import NVActivityIndicatorView

class OfferSentViewController: UIViewController {

    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    func setupUI () {
        
        // hide the nav bar
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        activityIndicator.startAnimating();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
