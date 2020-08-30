//
//  AuthViewController.swift
//  Wallet
//
//  Created by Service Ontario on 2017-02-16.
//  Copyright © 2017 Service Ontario. All rights reserved.
//
//  ************************************
//
//   This is the first screen
//     The LAContext from "LocalAuthentication" framework is used
//     to implement the Touch ID (finger print) login
//
//  ************************************

import UIKit
import LocalAuthentication

class AuthViewController: UIViewController {
    
    var isNewUser: Bool = false
    let userDefaults: UserDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if userDefaults.string(forKey: "password") != nil {
            isNewUser = false
        } else {
            isNewUser = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        authUser()
    }
    
    func authUser() {
        let laContext: LAContext = LAContext();
        var canError: NSError?
    //    var success:Bool
        let reason: String = "Please sign-in by TouchID."
        // to check see if device has finger scanner or finger print setup with passcode
        if (laContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &canError)) {
            // evaluate against the policy - finger print
            laContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: {
                (success, error) -> Void in
                if (success) {
                //    print("success")
                    if self.isNewUser {
                        let storyB = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyB.instantiateViewController(withIdentifier: "NVLoginSB")
                        self.present(controller, animated: true, completion: nil)
                    } else {
                        let storyB = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyB.instantiateViewController(withIdentifier: "NVServiceListSB")
                        
                        self.present(controller, animated: true, completion: nil)
                    }
                } else {
                 //   print("failed")
                    switch error!._code {
                    case LAError.Code.authenticationFailed.rawValue:
                        OperationQueue.main.addOperation({ () -> Void in
                            self.presentAlert(aTitle: "Authentication Failed", withMsg: nil, confirmTitle: "Enter Password")
                        })
                    case LAError.Code.systemCancel.rawValue:
                        OperationQueue.main.addOperation({ () -> Void in
                            self.presentAlert(aTitle: "System Cancel", withMsg: nil, confirmTitle: "Enter Password")
                        })
                    case LAError.Code.userCancel.rawValue:
                        OperationQueue.main.addOperation({ () -> Void in
                          //  self.presentAlert(aTitle: "User Cancel", withMsg: nil, confirmTitle: "OK")
                            self.closeAppAlert()
                        })
                    case LAError.Code.userFallback.rawValue:
                        OperationQueue.main.addOperation({ () -> Void in
                          //  self.presentAlert(aTitle: "User Fallback", withMsg: nil, confirmTitle: "OK")
                            let storyB = UIStoryboard(name: "Main", bundle: nil)
                            let controller = storyB.instantiateViewController(withIdentifier: "NVLoginSB")
                            self.present(controller, animated: true, completion: nil)
                        })
                    default:
                        break
                        
                    }
                }
            });
            
            // device has no finger scanner or the finger print is not set up with the passcode in device setup
        } else {
          //  print("No touchID feature!" + LAError.Code.systemCancel.rawValue.description);
            
            switch canError!._code {
            case LAError.Code.touchIDNotAvailable.rawValue:
               // print("touchIDNotAvailable")
                presentAlert(aTitle: "TouchID Not Available", withMsg: nil, confirmTitle: "Enter Password")
            case LAError.Code.touchIDNotEnrolled.rawValue:
              //  print("touchIDNotEnrolled")
                presentAlert(aTitle: "TouchID Not Enrolled", withMsg: nil, confirmTitle: "Enter Password")
            case LAError.Code.touchIDLockout.rawValue:
                presentAlert(aTitle: "TouchID Lockout", withMsg: nil, confirmTitle: "Enter Password")
            case LAError.Code.passcodeNotSet.rawValue:
                presentAlert(aTitle: "Passcode Not Set", withMsg: nil, confirmTitle: "Enter Password")
            default:
                break
            }
        }
        
    }
    
/*
    func showPasswordLogin() {
        var mEmail: UITextField?
        var mPassword: UITextField?
    }
*/
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func presentAlert(aTitle: String?, withMsg: String?, confirmTitle: String?) {
        
        typealias Handler = (UIAlertAction?) -> Void
        
        let enterPWHandler: Handler = {action in
            let storyB = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyB.instantiateViewController(withIdentifier: "NVLoginSB")
            
            /*
             NSString *tagStr = [NSString stringWithFormat:@"%ld", (long)tapGestureRecognizer.view.tag];
             //    NSLog(@"uuuuuuuuTTT---%@", tagStr);
             controller.viewTag = tagStr;
             */
           // controller.chosedCountry = [[NSUserDefaults standardUserDefaults] objectForKey:myCountry];
/*
            if (self.responds(to: #selector(self.show(_:sender:)))) {
                self.show(controller, sender: self)
            } else {
                self.navigationController?.pushViewController(controller, animated: true)
            }
*/
            self.present(controller, animated: true, completion: nil)
        }
        
        let closeAppHandler: Handler = {action in
            exit(0)
        }
        
        let alert = UIAlertController(title: aTitle, message: withMsg, preferredStyle: .alert);
        let enterPWAct = UIAlertAction(title: confirmTitle, style: .default, handler: enterPWHandler)
        alert.addAction(enterPWAct);
        let closeAppAct = UIAlertAction(title: "Close App", style: .default, handler: closeAppHandler)
        alert.addAction(closeAppAct)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func closeAppAlert() {
        
        typealias Handler = (UIAlertAction?) -> Void
        
        let closeAppHandler: Handler = {action in
            exit(0)
        }
        
        let continueAppHandler: Handler = {action in
            self.authUser()
        }
        
        let alert = UIAlertController(title: "Close This App?", message: nil, preferredStyle: .alert);
        
        let closeAppAct = UIAlertAction(title: "Close App", style: .default, handler: closeAppHandler)
        alert.addAction(closeAppAct)
        let continueAppAct = UIAlertAction(title: "Continue", style: .default, handler: continueAppHandler)
        alert.addAction(continueAppAct)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
