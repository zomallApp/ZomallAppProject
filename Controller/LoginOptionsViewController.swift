//
//  LoginOptionsViewController.swift
//  ZomallApp
//
//  Created by Baskt QA on 21/07/2020.
//  Copyright © 2020 Usman. All rights reserved.
//

import UIKit

class LoginOptionsViewController: UIViewController {

    @IBOutlet weak var loginWithFacebook: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupButton()
        self.navigationController?.navigationBar.isHidden = true

        
    }
   func setupButton(){
    self.loginWithFacebook.layer.borderColor = UIColor.white.cgColor
    self.loginWithFacebook.layer.borderWidth = 0.5
    self.loginWithFacebook.layer.cornerRadius = 20
    }
    
    @IBAction func loginWithEmailButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginSignupContainerViewController") as! LoginSignupContainerViewController
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
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
