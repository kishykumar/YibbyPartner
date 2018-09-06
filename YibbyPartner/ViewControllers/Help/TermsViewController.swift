//
//  TermsViewController.swift
//  Yibby
//
//  Created by Prabhdeep Singh on 8/16/18.
//  Copyright © 2018 Yibby. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController {
    
    
    @IBOutlet weak var termsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI(){
        setupBackButton()
        
        termsTextView.layer.borderColor = UIColor.borderColor().cgColor
        termsTextView.layer.borderWidth = 1.0
        termsTextView.layer.cornerRadius = 7.0
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
