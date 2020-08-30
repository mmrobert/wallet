//
//  LoginVC.swift
//  Wallet
//
//  Created by Service Ontario on 2017-02-21.
//  Copyright © 2017 Service Ontario. All rights reserved.
//
//  ************************************
//
//   This is the backup screen for password login 
//       (including the first time password setup)
//
//  ************************************

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var remindL: UILabel!
    @IBOutlet weak var passwordTX: UITextField!
    @IBOutlet weak var okBtn: UIButton!
    
    var initConstant: CGFloat = 0
    var kbHeight: CGFloat! = 0
    
    var isNewUser: Bool = false
    let userDefaults: UserDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.passwordTX.layer.cornerRadius = 8;
        self.passwordTX.layer.borderWidth = 1;
        self.passwordTX.layer.borderColor = UIColor.gray.cgColor;
        
        let dismiss = UITapGestureRecognizer(target: self, action: #selector(LoginVC.dismissKeyboard))
        self.view.addGestureRecognizer(dismiss)
        
        self.passwordTX.delegate = self
        
        let noteCenter = NotificationCenter.default
        
        noteCenter.addObserver(self, selector: #selector(LoginVC.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        noteCenter.addObserver(self, selector: #selector(LoginVC.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let okAction = UITapGestureRecognizer(target: self, action: #selector(LoginVC.okAction))
        self.okBtn.addGestureRecognizer(okAction)
        
        // comment out for official release
        userDefaults.removeObject(forKey: "password")
        
        if userDefaults.string(forKey: "password") != nil {
            isNewUser = false
        } else {
            isNewUser = true
        }
        
        if isNewUser {
            self.navigationItem.title = "Set Password"
            self.remindL.text = "Set Password"
        } else {
            self.navigationItem.title = "Log In"
            self.remindL.text = "Enter Password to Log In"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func okAction() {
        if isNewUser {
            
            let pwTX = self.passwordTX!.text!
            
       //     print(pwTX + "---")
        // save password to userDefaults
            userDefaults.set(pwTX, forKey: "password")
            
            let storyB = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyB.instantiateViewController(withIdentifier: "NVFacePictureSB")
            
            self.present(controller, animated: true, completion: nil)
        } else {
            let storyB = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyB.instantiateViewController(withIdentifier: "NVServiceListSB")
            
            self.present(controller, animated: true, completion: nil)
        }
    }
    
// pragma mark - Textfield delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == self.passwordTX) {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // workaround for jumping text bug
        textField.resignFirstResponder()
        textField.layoutIfNeeded()
    }
    
    func keyboardWillShow(notification: NSNotification){
        
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let kbHeight = keyboardSize.size.height - initConstant
            //    self.bottomConstraint.constant = kbHeight
                self.view.layoutIfNeeded()
                
                self.kbHeight = kbHeight
             //   self.scrollToLastCell()
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
/*
        if self.bottomConstraint.constant == self.kbHeight {
            self.bottomConstraint.constant = 0 - initConstant
            self.view.layoutIfNeeded()
        }
*/
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
