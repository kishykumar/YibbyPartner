//
//  YBMenuButton.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 8/2/17.
//  Copyright © 2017 YibbyPartner. All rights reserved.
//

import UIKit
import BButton
import MMDrawerController

class YBMenuButton: UIButton {
    
    var myViewController: UIViewController!
    
    enum YBMenuButtonType: Int {
        case menu = 0
        case back
    }
    
    var myButtonType: YBMenuButtonType = .menu {
        didSet {
            self.setNeedsDisplay()
            sharedSetup(type: myButtonType)
        }
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        sharedSetup(type: .menu)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedSetup(type: .menu)
    }
    
    func sharedSetup(type: YBMenuButtonType) {
        
        var buttonName = "menu_icon_green"
        
        self.removeTarget(nil, action: nil, for: .touchUpInside)
        if (type == .menu) {
            self.addTarget(self, action: #selector(menuButtonClicked), for: .touchUpInside)
        } else if (type == .back) {
            buttonName = "back_button_green"
            self.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        }
        
        let image = UIImage.init(named: buttonName)!
        self.setImage(image, for: .normal)
        
        // get the image size and apply it to the button frame
        let frame = CGRect(x: 0.0, y: 20.0, width: image.size.width, height: image.size.height)
        self.frame = frame
        
        self.backgroundColor = UIColor.clear
    }
    
    @objc private func backButtonClicked() {
        _ = myViewController.navigationController?.popViewController(animated: true)
    }
    
    @objc private func menuButtonClicked() {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
}
