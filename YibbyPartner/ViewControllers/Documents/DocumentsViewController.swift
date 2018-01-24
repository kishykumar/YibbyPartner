//
//  DocumentsViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 10/15/17.
//  Copyright © 2017 MyComp. All rights reserved.
//

import UIKit

class DocumentsViewController: BaseYibbyViewController {

    // MARK: - Properties
    
    
    
    // MARK: - Actions
    
    
    
    // MARK: - Setup
    
    
    func setupUI() {
        setupBackButton()
        
        // override the default background color
        self.view.backgroundColor = UIColor.white
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
    
    // MARK: - Helpers
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
