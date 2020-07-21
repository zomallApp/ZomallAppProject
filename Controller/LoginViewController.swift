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
    
   var floatingTextField = [MDCTextInputControllerUnderline]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.delegate = self
        self.passwordTextfield.delegate = self
        self.floatingTextField.append(MDCTextInputControllerUnderline(textInput: self.emailTextField))
        self.floatingTextField.append(MDCTextInputControllerUnderline(textInput: self.passwordTextfield))

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
