//
//  HelpCenterVC.swift
//  sr
//
//  Created by Rahul Mehndiratta on 10/03/17.
//  Copyright © 2017 Rahul Mehndiratta. All rights reserved.
//

import UIKit

class HelpCenterVC: BaseYibbyViewController {

    @IBOutlet var useYibbyBtn: UIButton!
    @IBOutlet var lostStolenItemBtn: UIButton!
    @IBOutlet var questionsBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        // Do any additional setup after loading the view.
    }

    private func setupUI() {
        setupBackButton()
        
        useYibbyBtn.layer.borderColor = UIColor.borderColor().cgColor
        useYibbyBtn.layer.borderWidth = 1.0
        useYibbyBtn.layer.cornerRadius = 7
        
        lostStolenItemBtn.layer.borderColor = UIColor.borderColor().cgColor
        lostStolenItemBtn.layer.borderWidth = 1.0
        lostStolenItemBtn.layer.cornerRadius = 7
        
        questionsBtn.layer.borderColor = UIColor.borderColor().cgColor
        questionsBtn.layer.borderWidth = 1.0
        questionsBtn.layer.cornerRadius = 7
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func useYibbyBtnAction(_ sender: Any) {
    }
    
    @IBAction func lostStolenItemBtnAction(_ sender: Any) {
        let reportIssuesVC = self.storyboard?.instantiateViewController(withIdentifier: "ReportIssuesViewControllerIdentifier") as! ReportIssuesViewController
        _ = self.navigationController?.pushViewController(reportIssuesVC, animated: true)
    }
    
    @IBAction func questionsBtnAction(_ sender: Any) {
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
