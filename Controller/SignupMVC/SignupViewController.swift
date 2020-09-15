//
//  SignupViewController.swift
//  ZomallApp
//
//  Created by Baskt QA on 21/07/2020.
//  Copyright © 2020 Usman. All rights reserved.
//

import UIKit
import MaterialComponents.MDCTextInput

class SignupViewController: UIViewController {

    @IBOutlet weak var nameTextField: MDCTextField!
    @IBOutlet weak var emailTextField: MDCTextField!
    @IBOutlet weak var passwordTextField: MDCTextField!
    @IBOutlet weak var dateOfBirthTextField: MDCTextField!
    @IBOutlet weak var femaleCheckBoxButton: UIButton!
    @IBOutlet weak var maleCheckBoxButton: UIButton!
    
     var signupModel = SignupAPICallModel()
    weak var delegate: SignupAPIResultDelegate?
    var isMaleCheckBoxClicked: Bool = false
    var isFemaleCheckBoxClicked: Bool = false
    var floatingTextField = [MDCTextInputControllerUnderline]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTextFields()
        self.signupModel.delegate = self
      
        
    }
    
    func setUpTextFields() {
        self.floatingTextField.append(MDCTextInputControllerUnderline(textInput: self.nameTextField))
        self.floatingTextField.append(MDCTextInputControllerUnderline(textInput: self.emailTextField))
        self.floatingTextField.append(MDCTextInputControllerUnderline(textInput: self.passwordTextField))
        self.floatingTextField.append(MDCTextInputControllerUnderline(textInput: self.dateOfBirthTextField))
    }
    
    @IBAction func maleCheckBox(_ sender: Any) {
        self.femaleCheckBoxButton.setImage(#imageLiteral(resourceName: "uncheckBox"), for: .normal)
        self.maleCheckBoxButton.setImage(#imageLiteral(resourceName: "tick"), for: .normal)
        self.isFemaleCheckBoxClicked = false
        self.isMaleCheckBoxClicked = true
        self.showSnackBarMessage(backgroundColor: HelpingClass.greenSuccessBackgroundColor, message: "Male Checkbox Selected.", action: nil)
    }
    @IBAction func femaleCheckBox(_ sender: Any) {
      self.maleCheckBoxButton.setImage(#imageLiteral(resourceName: "uncheckBox"), for: .normal)
        self.femaleCheckBoxButton.setImage(#imageLiteral(resourceName: "tick"), for: .normal)
        isMaleCheckBoxClicked = false
        isFemaleCheckBoxClicked = true
    }
    func SignupSuccessfulCase() {
         // push to next screen
         DispatchQueue.main.async {
             let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarController") as! HomeTabBarController
             self.setLoginStatus(isLoggedIn: true)
             vc.modalPresentationStyle = .fullScreen
             self.present(vc, animated: true, completion: nil)
         }
     }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        var gender = ""
        if self.isFemaleCheckBoxClicked {
            gender = "female"
        }
        else {
            gender = "male"
        }
        self.signupModel.signupApiCall(credential: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", name: self.nameTextField.text ?? "", gender: gender, dob: self.dateOfBirthTextField.text ?? "", country: " Pakistan", age: 20, info: "Info updated", image: "None", interests: "None")
    }
    
    

}

extension SignupViewController: SignupAPIResultDelegate {
    func signUpAPIResult(status: String, result: SignupResponseModel) {
        if status == "true" {
               self.SignupSuccessfulCase()
           }
           else {
               self.showSnackBarMessage(backgroundColor: HelpingClass.redAlertBackgroundColor, message: "Some Server Error", action: nil)
           }
    }
    
    
}
