//
//  ConsentViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 1/8/17.
//  Copyright © 2017 MyComp. All rights reserved.
//

import UIKit
import CocoaLumberjack
import AIFlatSwitch

class ConsentViewController: BaseYibbyViewController {

    // MARK: - Properties
    
    @IBOutlet weak var consentSwitchOutlet: AIFlatSwitch!
    
    // MARK: - Actions
    @IBAction func onNextBarButtonClick(_ sender: UIBarButtonItem) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // conduct error checks
        
        let registerStoryboard: UIStoryboard = UIStoryboard(name: InterfaceString.StoryboardName.Register, bundle: nil)
        
        let duViewController = registerStoryboard.instantiateViewController(withIdentifier: "DocumentUploadViewControllerIdentifier") as! DocumentUploadViewController
        
        // get the navigation VC and push the new VC
        self.navigationController!.pushViewController(duViewController, animated: true)
        
//        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    @IBAction func onConsentClick(_ sender: AIFlatSwitch) {
        
    }
    
    // MARK: - Setup
    
    func setupUI () {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
