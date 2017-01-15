//
//  YBUploadPictureView.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 1/14/17.
//  Copyright © 2017 MyComp. All rights reserved.
//

import Foundation
@IBDesignable
public class YBUploadPictureView: UIView {
    
    // MARK: - Properties

    @IBOutlet weak var cameraLabelOutlet: UILabel!
    @IBOutlet weak var uploadLabelOutlet: UILabel!
    
    /**
     Changes to this parameter draw the border of `self` in the given width.
     */
    @IBInspectable
    var borderWidth: CGFloat = 1.0 {
        didSet {
            if borderWidth >= 0 {
                self.layer.borderWidth = CGFloat(borderWidth)
            } else {
                self.layer.borderWidth = 0
            }
        }
    }
    
    /**
     If `borderWidth` has been set, changes to this parameter round the corners of `self` in the given corner radius.
     */
    @IBInspectable
    var cornerRadius: CGFloat = 8.0 {
        didSet {
            if cornerRadius >= 0 {
                self.layer.cornerRadius = cornerRadius
            }
        }
    }
    
    /**
     If `borderWidth` has been set, changes to this parameter change the color of the border of `self`.
     */
    @IBInspectable
    var borderColor: UIColor = UIColor.black {
        didSet {
            self.layer.borderColor = self.borderColor.cgColor
        }
    }
    
    // MARK: - Initializers & view setup
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        #if !TARGET_INTERFACE_BUILDER
            setupView()
        #endif
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        #if !TARGET_INTERFACE_BUILDER
            setupView()
        #endif
    }
    
    deinit {
    }
    
    /**
     Sets up the view by loading subviews from the given Nib in the specified bundle.
     */
    private func setupView() {
        guard let nib = getNibBundle().loadNibNamed(getNibName(), owner: self, options: nil), let firstObjectInNib = nib.first as? UIView else {
            fatalError("The nib is expected to contain a UIView as root element.")
        }
        
//        numberInputTextField.contentMode = UIViewContentMode.redraw
        
        clipsToBounds = true
        
        firstObjectInNib.autoresizesSubviews = true
        firstObjectInNib.translatesAutoresizingMaskIntoConstraints = true
        firstObjectInNib.frame = self.bounds
        
        // the autoresizingMask will be converted to constraints, the frame will match the parent view frame
        firstObjectInNib.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(firstObjectInNib)
        
        // Outerview defaults
        self.layer.cornerRadius = 8.0
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
    }
    
    // MARK: - View customization
    
    /**
     You can override this function to provide your own Nib. If you do so, please override 'getNibBundle' as well to provide the right NSBundle to load the nib file.
     */
    public func getNibName() -> String {
        return "YBUploadPictureView"
    }
    
    /**
     You can override this function to provide the NSBundle for your own Nib. If you do so, please override 'getNibName' as well to provide the right Nib to load the nib file.
     */
    public func getNibBundle() -> Bundle {
        return Bundle(for: YBUploadPictureView.self)
    }
}
