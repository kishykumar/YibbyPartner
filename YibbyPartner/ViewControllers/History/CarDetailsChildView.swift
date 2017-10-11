//
//  CarDetailsChildView.swift
//  FoldingCell
//
//  Created by Rahul Mehndiratta on 26/02/17.
//  Copyright © 2017 Alex K. All rights reserved.
//

import UIKit

class CarDetailsChildView: UIViewController {

    @IBOutlet var carIV: UIImageView!
    @IBOutlet weak var carModel: YibbyPaddingLabel!
    @IBOutlet weak var carNumber: YibbyPaddingLabel!
    
    var carModelStr: String!
    var carNumberStr: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        configure()
        
        // Do any additional setup after loading the view.
    }

    private func setupUI() {
        //self.customBackButton()
        
        /*carModel.layer.borderColor = UIColor.lightGray.cgColor
        carModel.layer.borderWidth = 1.0
        carModel.layer.cornerRadius = 5
        
        carNumber.layer.borderColor = UIColor.lightGray.cgColor
        carNumber.layer.borderWidth = 1.0
        carNumber.layer.cornerRadius = 5*/
        
        carIV.layer.borderColor = UIColor.appDarkGreen1().cgColor
        carIV.layer.borderWidth = 1.0
        carIV.layer.cornerRadius = carIV.frame.size.height/2-5
    }

    private func configure() {
        carModel.text = carModelStr.capitalized
        carNumber.text = carNumberStr.uppercased()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func closeBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
