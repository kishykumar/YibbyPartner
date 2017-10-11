//
//  UIImagePickerController.swift
//  Ello
//
//  Created by Tony DiPasquale on 4/21/15.
//  Copyright (c) 2015 Ello. All rights reserved.
//

//import Photos
//
//enum ImagePickerSheetResult {
//    case controller(UIImagePickerController)
//    case images([PHAsset])
//}
//
//extension UIImagePickerController {
//    class var elloImagePickerController: UIImagePickerController {
//        let controller = UIImagePickerController()
//        controller.mediaTypes = [kUTTypeImage as String]
//        controller.allowsEditing = false
//        controller.modalPresentationStyle = .fullScreen
//        controller.navigationBar.tintColor = .greyA()
//        return controller
//    }
//
//    class var elloPhotoLibraryPickerController: UIImagePickerController {
//        let controller = elloImagePickerController
//        controller.sourceType = .photoLibrary
//        return controller
//    }
//
//    class var elloCameraPickerController: UIImagePickerController {
//        let controller = elloImagePickerController
//        controller.sourceType = .camera
//        return controller
//    }
//
//    class func alertControllerForImagePicker(_ callback: @escaping (UIImagePickerController) -> Void) -> AlertViewController? {
//        let alertController: AlertViewController
//
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            alertController = AlertViewController(message: InterfaceString.ImagePicker.ChooseSource)
//
//            let cameraAction = AlertAction(title: InterfaceString.ImagePicker.Camera, style: .dark) { _ in
//                callback(.elloCameraPickerController)
//            }
//            alertController.addAction(cameraAction)
//
//            let libraryAction = AlertAction(title: InterfaceString.ImagePicker.Library, style: .dark) { _ in
//                callback(.elloPhotoLibraryPickerController)
//            }
//            alertController.addAction(libraryAction)
//
//            let cancelAction = AlertAction(title: InterfaceString.Cancel, style: .light) { _ in
//            }
//            alertController.addAction(cancelAction)
//        } else if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//            callback(.elloPhotoLibraryPickerController)
//            return nil
//        } else {
//            alertController = AlertViewController(message: InterfaceString.ImagePicker.NoSourceAvailable)
//
//            let cancelAction = AlertAction(title: InterfaceString.OK, style: .light, handler: .none)
//            alertController.addAction(cancelAction)
//        }
//
//        return alertController
//    }
//}
