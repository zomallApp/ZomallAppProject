//
//  LoginSignupContainerViewController.swift
//  ZomallApp
//
//  Created by Baskt QA on 21/07/2020.
//  Copyright © 2020 Usman. All rights reserved.
//

import UIKit

class LoginSignupContainerViewController: UIViewController {

   
    @IBOutlet weak var signupBottomView: UIView!
    @IBOutlet weak var signInBottomView: UIView!
    @IBOutlet weak var loginContainerView: UIView!
    @IBOutlet weak var signupContainerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoginView()
    
        // Do any additional setup after loading the view.
    }
    
    //MARK:- // ContainerViews
    func showLoginView() {
        self.loginContainerView.alpha = 1
        self.signupContainerView.alpha = 0
        self.signInBottomView.backgroundColor = .blue
        self.signupBottomView.backgroundColor = .systemGray5
    }
    func showSignupView() {
        self.loginContainerView.alpha = 0
        self.signupContainerView.alpha = 1
        self.signInBottomView.backgroundColor = .systemGray5
        self.signupBottomView.backgroundColor = .blue
    }
    
    //MARK:- Buttons Actions

    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func signInButtonPressed(_ sender: Any) {
        self.showLoginView()
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        self.showSignupView()
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
