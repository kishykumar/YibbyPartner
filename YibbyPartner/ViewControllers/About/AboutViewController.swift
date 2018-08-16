//
//  AboutViewController.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 4/5/16.
//  Copyright © 2016 YibbyPartner. All rights reserved.
//

import UIKit
import CocoaLumberjack
import Instabug
import StoreKit

public class AboutViewController: BaseYibbyViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var rateUsButtonOutlet: UIButton!
    @IBOutlet weak var likeUsButtonOutlet: UIButton!
    @IBOutlet weak var tweetUsButtonOutlet: UIButton!
    @IBOutlet weak var reportBugButtonOutlet: UIButton!
    
    // MARK: - Actions
    
    @IBAction func onAppStoreRateClick(_ sender: UIButton) {
        if #available( iOS 10.3,*){
            SKStoreReviewController.requestReview()
        } else {
            let url = URL(string: "https://itunes.apple.com/us/app/yibby-partner/id1196624652?ls=1&mt=8")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func onFBLikeUsClick(_ sender: UIButton) {
        let url = URL(string: "http://www.facebook.com/yibbyapp")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func onTweetUsClick(_ sender: UIButton) {
        let url = URL(string: "http://twitter.com/yibbyapp")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func onReportBugClick(_ sender: UIButton) {
        Instabug.invoke()
    }
    
    // MARK: - Setup Functions

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    private func setupUI() {
        setupBackButton()
        
        tweetUsButtonOutlet.layer.borderColor = UIColor.borderColor().cgColor
        tweetUsButtonOutlet.layer.borderWidth = 1.0
        tweetUsButtonOutlet.layer.cornerRadius = 7
        
        likeUsButtonOutlet.layer.borderColor = UIColor.borderColor().cgColor
        likeUsButtonOutlet.layer.borderWidth = 1.0
        likeUsButtonOutlet.layer.cornerRadius = 7
        
        rateUsButtonOutlet.layer.borderColor = UIColor.borderColor().cgColor
        rateUsButtonOutlet.layer.borderWidth = 1.0
        rateUsButtonOutlet.layer.cornerRadius = 7
        
        reportBugButtonOutlet.layer.borderColor = UIColor.borderColor().cgColor
        reportBugButtonOutlet.layer.borderWidth = 1.0
        reportBugButtonOutlet.layer.cornerRadius = 7
    }
    
    // MARK: - Helpers
    
    
}
