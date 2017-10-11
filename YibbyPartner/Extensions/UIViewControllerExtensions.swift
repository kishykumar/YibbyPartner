//
//  UIViewControllerExtensions.swift
//  Yibby
//
//  Created by Rahul Mehndiratta on 12/03/17.
//  Copyright © 2017 Yibby. All rights reserved.
//

import UIKit

extension UIViewController {

    var displayed: Bool {
        get {
            return true
        }
        
        set {
            
        }
    }
    
    func setupMenuButton() {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        let menuButton: YBMenuButton = YBMenuButton()
        menuButton.myViewController = self
        self.view.addSubview(menuButton)
    }
    
    func setupBackButton() {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

        let backButton: YBMenuButton = YBMenuButton()
        backButton.myButtonType = .back
        backButton.myViewController = self
        self.view.addSubview(backButton)
    }
    
//    private func setupButtonOnNavigationBarInternal(barButton: UIBarButtonItem) {
//        let app: UIApplication = UIApplication.shared
//        let negativeSpacer: UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
//        negativeSpacer.width = -16
//        self.navigationItem.setLeftBarButtonItems([negativeSpacer, barButton], animated: false)
//        
////        self.navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsetsMake(app.statusBarFrame.size.height-4, -8, -(app.statusBarFrame.size.height-4), 8)
//        
//        // Make nav bar transparent
////        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
////        self.navigationController?.navigationBar.shadowImage = UIImage()
//    }
}


// ROUGH CODE TO BE DELETED ONCE EVERYTHING WORKS
//func setupBackButton() {
//    
//    self.navigationController?.navigationBar.isHidden = true
//    
//    let backImage = UIImage.init(named: "back_button_green")!
//    let backButton = UIButton(type: .custom)
//    backButton.setImage(backImage, for: .normal)
//    
//    // get the image size and apply it to the button frame
//    var backButtonFrame = backButton.frame
//    backButtonFrame.size = backImage.size
//    backButton.frame = backButtonFrame
//    
//    backButton.backgroundColor = UIColor.clear
//    backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
//    backButton.tag = 200
//    self.view.addSubview(backButton)
//    
//    // NOTE: The following code adds the back button to the navigation view
//    
//    //        let app: UIApplication = UIApplication.shared
//    //        self.navigationController?.navigationBar.isHidden = true
//    //        let backButton = UIButton(frame: CGRect(x: 0, y: app.statusBarFrame.size.height, width: 50, height: 59))
//    //        backButton.setImage(UIImage(named: "back_button_green"), for: UIControlState.normal)
//    //        backButton.backgroundColor = UIColor.clear
//    //        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
//    //        self.navigationController?.view.addSubview(backButton)
//    
//    // NOTE: The following code adds the back button to the navbar
//    //        self.navigationController?.isNavigationBarHidden = false
//    //        let image : UIImage? = UIImage.init(named: "back_button_green")!.withRenderingMode(.alwaysOriginal)
//    //        let barButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backButtonClicked))
//    //        setupButtonOnNavigationBarInternal(barButton: barButton)
//    
//    
//    // NOTE: The following code adds the back button in the view with constraints
//    
//    //        self.navigationController?.navigationBar.isHidden = true
//    
//    //        let image = UIImage.init(named: "back_button_green")!
//    //        let button = UIButton(type: .custom)
//    //        button.setImage(image, for: .normal)
//    //        button.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
//    //        button.translatesAutoresizingMaskIntoConstraints = false
//    
//    //        button.frame = CGRect(x: 0.0, y: 20.0)
//    
//    //        self.view.addSubview(button)
//    //        button.tag = 200
//    
//    //        let topGuide = self.topLayoutGuide
//    //        let topConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: topGuide, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
//    
//    //        let leftConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
//    
//    //        self.view.addConstraints([topConstraint, leftConstraint])
//}
