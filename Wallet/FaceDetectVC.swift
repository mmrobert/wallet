//
//  FaceDetectVC.swift
//  Wallet
//
//  Created by Service Ontario on 2017-03-06.
//  Copyright © 2017 Service Ontario. All rights reserved.
//
//  ************************************
//
//   This viewcontroller creates a "Visage" object,
//
//   then uses its notification pattern to get the live video face recognization
//
//  ************************************

import UIKit

class FaceDetectVC: UIViewController {

    fileprivate var visage : Visage?
    fileprivate let notificationCenter : NotificationCenter = NotificationCenter.default
    
    let emojiLabel : UILabel = UILabel(frame: UIScreen.main.bounds)
    
    var imgPreview: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup "Visage" with a camera-position (iSight-Camera (Back), FaceTime-Camera (Front)) and an optimization mode for either better feature-recognition performance (HighPerformance) or better battery-life (BatteryLife)
        visage = Visage(cameraPosition: Visage.CameraDevice.faceTimeCamera, optimizeFor: Visage.DetectorAccuracy.higherPerformance)
        
        //If you enable "onlyFireNotificationOnStatusChange" you won't get a continuous "stream" of notifications, but only one notification once the status changes.
        visage!.onlyFireNotificatonOnStatusChange = false
        
        
        //You need to call "beginFaceDetection" to start the detection, but also if you want to use the cameraView.
        visage!.beginFaceDetection()
        
        //This is a very simple cameraView you can use to preview the image that is seen by the camera.
        let cameraView = visage!.visageCameraView
        self.view.addSubview(cameraView)
        
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffectView.frame = self.view.bounds
     //   self.view.addSubview(visualEffectView)
        
      //  emojiLabel.text = "😐"
        emojiLabel.text = "Normal"
        emojiLabel.font = UIFont.systemFont(ofSize: 30)
        emojiLabel.textAlignment = .center
        self.view.addSubview(emojiLabel)
        
        let widthImg: CGFloat = UIScreen.main.bounds.size.width / 3
        let heightImg: CGFloat = UIScreen.main.bounds.size.height / 3
        
        imgPreview = UIImageView(frame: CGRect(x: 0.0, y: 60.0, width: heightImg, height: widthImg))
        
        imgPreview?.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
        
        self.view.addSubview(imgPreview!)
        
        //Subscribing to the "visageFaceDetectedNotification" (for a list of all available notifications check out the "ReadMe" or switch to "Visage.swift") and reacting to it with a completionHandler. You can also use the other .addObserver-Methods to react to notifications.
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "visageFaceDetectedNotification"), object: nil, queue: OperationQueue.main, using: { notification in
            
            UIView.animate(withDuration: 0.5, animations: {
                self.emojiLabel.alpha = 1
            })
            
            if ((self.visage!.hasSmile == true && self.visage!.isWinking == true)) {
              //  self.emojiLabel.text = "😜"
                self.emojiLabel.text = "Smiling and Winking"
                
                let originalImg: CIImage = self.visage!.imageReturned!
                
              //  let rotatedImg: UIImage = UIImage(ciImage: originalImg, scale: 1.0, orientation: UIImageOrientation.right)
                
                 //   let rotatedImg: UIImage = UIImage(cgImage: originalImg.cgImage!, scale: 1.0, orientation: UIImageOrientation.right)
                    
                self.imgPreview?.image = UIImage(ciImage: originalImg)

            } else if ((self.visage!.isWinking == true && self.visage!.hasSmile == false)) {
             //   self.emojiLabel.text = "😉"
                self.emojiLabel.text = "Winking"
            } else if ((self.visage!.hasSmile == true && self.visage!.isWinking == false)) {
              //  self.emojiLabel.text = "😃"
                self.emojiLabel.text = "Smiling"
            } else {
             //   self.emojiLabel.text = "😐"
                self.emojiLabel.text = "Normal"
            }
        })
        
        //The same thing for the opposite, when no face is detected things are reset.
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "visageNoFaceDetectedNotification"), object: nil, queue: OperationQueue.main, using: { notification in
            
            UIView.animate(withDuration: 0.5, animations: {
                self.emojiLabel.alpha = 0.25
            })
            
            self.emojiLabel.text = "No Face Detected"
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        visage!.endFaceDetection()
    }
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

