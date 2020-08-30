//
//  FacePictureVC.swift
//  Wallet
//
//  Created by Service Ontario on 2017-02-22.
//  Copyright © 2017 Service Ontario. All rights reserved.
//
//  ************************************
//
//   This viewcontroller includes:
//
//   1) face recognization from live video
//   2) barcodescanner, which presents another viewcontroller when button is tapped
//
//  ************************************

import UIKit
import MobileCoreServices
import BarcodeScanner
import AVFoundation

class FacePictureVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var photoImgView: CircularImageView!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var barcodeReaderBtn: UIButton!
    
    var photoAlbum: UIImagePickerController?
    var camera: UIImagePickerController?
    
    var pickedLargeImg: UIImage?
    var imgData: Data?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
  //      let imgTap = UITapGestureRecognizer(target: self, action: #selector(FacePictureVC.choosePhoto(regognizer:)))
        
        let imgTapFaceDetect = UITapGestureRecognizer(target: self, action: #selector(FacePictureVC.faceDetectionAction(regognizer:)))
        self.photoImgView.addGestureRecognizer(imgTapFaceDetect)
        self.photoImgView.isUserInteractionEnabled = true
        
        let barcodeReaderTap = UITapGestureRecognizer(target: self, action: #selector(FacePictureVC.barcodeReaderAction(regognizer:)))
        self.barcodeReaderBtn.addGestureRecognizer(barcodeReaderTap)
        
        let uploadTap = UITapGestureRecognizer(target: self, action: #selector(FacePictureVC.uploadAction(regognizer:)))
        self.uploadBtn.addGestureRecognizer(uploadTap)
        
        self.barcodeReaderBtn.layer.cornerRadius = 10;
        self.barcodeReaderBtn.layer.borderWidth = 1;
        self.barcodeReaderBtn.layer.borderColor = UIColor.gray.cgColor;
        self.barcodeReaderBtn.layer.masksToBounds = true;
        
        self.uploadBtn.layer.cornerRadius = 10;
        self.uploadBtn.layer.borderWidth = 1;
        self.uploadBtn.layer.borderColor = UIColor.gray.cgColor;
        self.uploadBtn.clipsToBounds = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func faceDetectionAction(regognizer: UITapGestureRecognizer) {
        
        let controller = FaceDetectVC()
        
        if self.responds(to: #selector(self.navigationController?.show(_:sender:))) {
            self.navigationController?.show(controller, sender: self)
        } else {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
// the following codes are not used anymore,
// it is used for taking a photo or choosing a photo from gallery
//  by using UIImagePickerController
    
    func choosePhoto(regognizer: UITapGestureRecognizer) {
        
        typealias Handler = (UIAlertAction?) -> Void
        
        let handlerAlbums: Handler = {action in
            if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum)) {
                self.photoAlbum = UIImagePickerController()
                self.photoAlbum!.allowsEditing = true
                self.photoAlbum!.mediaTypes = [kUTTypeImage as String]
                self.photoAlbum!.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
                self.photoAlbum!.delegate = self
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone) {
                    self.present(self.photoAlbum!, animated: true, completion: nil)
                } else {
                    self.photoAlbum!.modalPresentationStyle = UIModalPresentationStyle.popover
                    self.present(self.photoAlbum!, animated: true, completion: nil)
                    
                    let popController = self.photoAlbum!.popoverPresentationController
                    popController!.permittedArrowDirections = UIPopoverArrowDirection.any
                    popController!.sourceView = self.view
                    popController!.sourceRect = CGRect(x: 10, y: 10, width: 10, height: 10)
                    popController!.delegate = self
                    
                }
            }
        }
        
        let handlerCamera: Handler = {action in
            if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
                self.camera = UIImagePickerController()
                self.camera!.allowsEditing = true
                self.camera!.mediaTypes = [kUTTypeImage as String]
                self.camera!.sourceType = UIImagePickerControllerSourceType.camera
                self.camera!.delegate = self
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone) {
                    self.present(self.camera!, animated: true, completion: nil)
                } else {
                    self.camera!.modalPresentationStyle = UIModalPresentationStyle.popover
                    self.present(self.camera!, animated: true, completion: nil)
                    
                    let popController = self.camera!.popoverPresentationController
                    popController!.permittedArrowDirections = UIPopoverArrowDirection.any
                    popController!.sourceView = self.view
                    popController!.sourceRect = CGRect(x: 10, y: 10, width: 10, height: 10)
                    popController!.delegate = self
                    
                }
            }
        }

        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet);
        let albumAct = UIAlertAction(title: "Choose from Albums", style: .default, handler: handlerAlbums)
        let cameraAct = UIAlertAction(title: "Take Photo", style: .default, handler: handlerCamera)
        let cancelAct = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(albumAct);
        alert.addAction(cameraAct)
        alert.addAction(cancelAct)
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone) {
            self.present(alert, animated: true, completion: nil)
        } else {
            alert.modalPresentationStyle = UIModalPresentationStyle.popover
            let popPresenter = alert.popoverPresentationController
            popPresenter!.permittedArrowDirections = UIPopoverArrowDirection.any
            popPresenter!.sourceView = self.photoImgView
            popPresenter!.sourceRect = self.photoImgView!.bounds
            
            self.present(alert, animated: true, completion: nil)
        }
    }
  
// pragma mark - imagepickercontroller delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        if mediaType == (kUTTypeImage as String) {
          //  self.pickedLargeImg = info[UIImagePickerControllerEditedImage] as! UIImage?
            self.pickedLargeImg = info[UIImagePickerControllerOriginalImage] as! UIImage?
            self.photoImgView.image = UtilityFuncs.compressAndResizeImage(imageIn: self.pickedLargeImg!, maxWidth: 380.0, maxHeight: 380.0, compressionQuality: 0.5)
         //   self.imgData = UIImageJPEGRepresentation(self.photoImgView.image!, 1.0)
            self.imgData = UIImageJPEGRepresentation(self.pickedLargeImg!, 1.0)
        } else if mediaType == (kUTTypeMovie as String) {
            self.presentAlert(aTitle: "Video not Supported", withMsg: nil, confirmTitle: "OK")
        }
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone {
            picker.dismiss(animated: true, completion: nil)
        } else {
            picker.dismiss(animated: true, completion: nil)
        }
    }
 
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone {
            picker.dismiss(animated: true, completion: nil)
        } else {
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.title = "Photos"
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }
    
    func popoverPresentationController(_ popoverPresentationController: UIPopoverPresentationController, willRepositionPopoverTo rect: UnsafeMutablePointer<CGRect>, in view: AutoreleasingUnsafeMutablePointer<UIView>) {
        
    }

// the above codes are not used anymore,
// it is used for taking a photo or choosing a photo from gallery
//  by using UIImagePickerController
    
 // barcode reader action selector function
    
    func barcodeReaderAction(regognizer: UITapGestureRecognizer) {
        let controller = BarcodeScannerController()
        controller.codeDelegate = self
        controller.errorDelegate = self
        controller.dismissalDelegate = self
        
        if self.responds(to: #selector(self.navigationController?.show(_:sender:))) {
            self.navigationController?.show(controller, sender: self)
        } else {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
//  upload action selector function
    
    func uploadAction(regognizer: UITapGestureRecognizer) {
        let storyB = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyB.instantiateViewController(withIdentifier: "NVServiceListSB")
        
        self.present(controller, animated: true, completion: nil)
    }
    
// pragma mark - Popover Presentation Controller Delegate

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func presentAlert(aTitle: String?, withMsg: String?, confirmTitle: String?) {
        
        let alert = UIAlertController(title: aTitle, message: withMsg, preferredStyle: .alert);
        let okAction = UIAlertAction(title: confirmTitle, style: .default, handler: nil)
        alert.addAction(okAction);
        self.present(alert, animated: true, completion: nil)
        
    }

}

extension FacePictureVC: BarcodeScannerCodeDelegate {
    func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
        self.presentAlert(aTitle: code, withMsg: nil, confirmTitle: "OK")
    }
}

extension FacePictureVC: BarcodeScannerErrorDelegate {
    func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
        self.presentAlert(aTitle: error.localizedDescription, withMsg: nil, confirmTitle: "OK")
    }
}

extension FacePictureVC: BarcodeScannerDismissalDelegate {
    func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
       _ = self.navigationController?.popViewController(animated: true)
    }
}


