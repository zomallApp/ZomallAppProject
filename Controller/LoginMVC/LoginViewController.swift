//
//  LoginViewController.swift
//  ZomallApp
//
//  Created by Baskt QA on 21/07/2020.
//  Copyright © 2020 Usman. All rights reserved.
//

import UIKit
import MaterialComponents.MDCTextInput

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: MDCTextField!
    @IBOutlet weak var passwordTextfield: MDCTextField!
    var loginModel = LoginAPICallModel()
    weak var delegate: loginAPIResultDelegate?
   var floatingTextField = [MDCTextInputControllerUnderline]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.passwordTextfield.delegate = self
        self.delegate = self
        self.loginModel.delegate = self
        self.floatingTextField.append(MDCTextInputControllerUnderline(textInput: self.emailTextField))
        self.floatingTextField.append(MDCTextInputControllerUnderline(textInput: self.passwordTextfield))

    }
    
    @IBAction func loginPressed(_ sender: Any) {
        if ((self.emailTextField.text?.isEmpty == true)
            || (self.passwordTextfield.text?.isEmpty == true)) {
            self.showSnackBarMessage(backgroundColor: HelpingClass.redAlertBackgroundColor, message: "Email or Password Field cant be empty.", action: nil)
        }
        else {
        self.loginModel.loginApiCall(credential: self.emailTextField.text ?? "", password: self.passwordTextfield.text  ?? "")
        }
    }
    
    func loginSuccessfulCase() {
        // push to next screen
        DispatchQueue.main.async {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarController") as! HomeTabBarController
            self.setLoginStatus(isLoggedIn: true)
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension LoginViewController: loginAPIResultDelegate {
    func loginAPIResult(status: String, result: LoginResponseModel) {
        if status == "true" {
            self.loginSuccessfulCase()
        }
        else {
            self.showSnackBarMessage(backgroundColor: HelpingClass.redAlertBackgroundColor, message: "Email or Password is Wrong.", action: nil)
        }
    }
    
   
}
