//
//  BaseYibbyViewController.swift
//  Yibby
//
//  Created by Kishy Kumar on 8/20/16.
//  Copyright © 2016 Yibby. All rights reserved.
//

import UIKit

open class BaseYibbyViewController: UIViewController {

    // MARK: - Properties
    
    // MARK: - Setup functions
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.appBackgroundColor1();
    }

    override open func didReceiveMemoryWarning() {
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

public extension BaseYibbyViewController {

}
