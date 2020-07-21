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
    
    var isMaleCheckBoxClicked: Bool = false
    var isFemaleCheckBoxClicked: Bool = false
    var floatingTextField = [MDCTextInputControllerUnderline]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTextFields()
      
        
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
    }
    @IBAction func femaleCheckBox(_ sender: Any) {
      self.maleCheckBoxButton.setImage(#imageLiteral(resourceName: "uncheckBox"), for: .normal)
        self.femaleCheckBoxButton.setImage(#imageLiteral(resourceName: "tick"), for: .normal)
        isMaleCheckBoxClicked = false
        isFemaleCheckBoxClicked = true
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
