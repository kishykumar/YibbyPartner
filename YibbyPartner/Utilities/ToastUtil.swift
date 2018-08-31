//
//  ToastUtil.swift
//  Yibby
//
//  Created by Kishy Kumar on 3/26/18.
//  Copyright © 2018 Yibby. All rights reserved.
//

import Foundation
import SwiftMessages
import CocoaLumberjack

class ToastUtil {

    static func displayToastOnVC(_ vc: UIViewController,
                                 title: String,
                                 body: String,
                                 theme: Theme,
                                 presentationStyle: SwiftMessages.PresentationStyle,
                                 duration: SwiftMessages.Duration,
                                 windowLevel: UIWindowLevel) {
        
        let success = MessageView.viewFromNib(layout: .tabView)
        success.configureTheme(theme)
        //success.configureDropShadow()
        success.configureContent(title: title, body: body)
        success.button?.isHidden = true
        
        var successConfig = SwiftMessages.defaultConfig
        successConfig.presentationStyle = presentationStyle
        successConfig.dimMode = .gray(interactive: true)
        successConfig.duration = duration
        successConfig.presentationContext = .window(windowLevel: windowLevel)
        
        SwiftMessages.show(config: successConfig, view: success)
    }
}
