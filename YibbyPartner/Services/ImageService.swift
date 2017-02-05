//
//  ImageService.swift
//  YibbyPartner
//
//  Created by Kishy Kumar on 1/15/17.
//  Copyright © 2017 MyComp. All rights reserved.
//

import UIKit
import SwiftyJSON
import BaasBoxSDK
import CocoaLumberjack

public typealias ImageUploadSuccessCompletion = (_ url: URL, _ fileId: String) -> Void
public typealias ImageUploadFailureCompletion = (_ error: NSError) -> Void

public class ImageService: NSObject, UIImagePickerControllerDelegate {
    
    fileprivate static let myInstance = ImageService()

    override init() {
        
    }
    
    static func sharedInstance () -> ImageService {
        return myInstance
    }
    
    public func uploadImage(_ image: UIImage, cacheKey: CacheKey, success: @escaping ImageUploadSuccessCompletion, failure: @escaping ImageUploadFailureCompletion) {
        
        uploadImageInt(image, success: { (url, fileId) in
            TemporaryCache.save(cacheKey, image: image)
            success(url, fileId)
        }, failure: failure)
        
    }

    fileprivate func uploadImageInt(_ image: UIImage, success: @escaping ImageUploadSuccessCompletion, failure: @escaping ImageUploadFailureCompletion) {
        
        if let data = UIImageJPEGRepresentation(image, 0.8) {
            
            let myLocalFile: BAAFile = BAAFile(data: data)
            myLocalFile.uploadFile(withPermissions: nil, completion: { (file, error) -> Void in
                if error == nil {
                    DDLogVerbose("File uploaded to Baasbox + \(file) + \((file as! BAAFile).fileURL())")
                    
                    let uploadFile = file as! BAAFile
                    success(uploadFile.fileURL(), uploadFile.fileId)
                }
                else {
                    DDLogVerbose("error in uploading file \(error)")
                    failure(error as! NSError)
                }
            })
        }
    }
}
