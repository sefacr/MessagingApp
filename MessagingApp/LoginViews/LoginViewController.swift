//
//  LoginViewController.swift
//  MessagingApp
//
//  Created by Sefa Acar on 30.04.2024.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    @IBAction func loginBtnClicked(_ sender: Any) {
        if isValid(email: emailTextField.text!) && passwordTextField.text! != "" {
            performLogin()
        } else {
            showAlert(title: "Login Credentials Invalid", message: "Please enter registered account info.", in: self)
            return
        }
    }
    
    func performLogin() {
        FUser.loginUserWithEmail(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
            if error != nil {
                showAlert(title: "Error Signing In", message: "Please try again.", in: self)
            }else {
                self.goToTabBar()
            }
        }
    }
    
    func goToTabBar(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: USER_DID_LOGIN_NOTIFICATION), object: nil, userInfo: [kUSERID : FUser.currentId()])
        instantiateViewController(identifier: "tabBarController", animated: true, by: self, completion: nil)
    }
    
    
    @IBAction func registerBtnClicked(_ sender: Any) {
        instantiateViewController(identifier: "registerViewController", animated: true, by: self, completion: nil)
    }
    
    private func configureUI() {
        cornerRadius(for: loginBtn)
        cornerRadius(for: registerBtn)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }// bu method ekranda bir yere tıklanıldığında klavyenin kapanmasını sağlıyor.
}
