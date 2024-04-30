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
    }
    
    
    @IBAction func registerBtnClicked(_ sender: Any) {
    }
    
    private func configureUI() {
        cornerRadius(for: loginBtn)
        cornerRadius(for: registerBtn)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }// bu method ekranda bir yere tıklanıldığında klavyenin kapanmasını sağlıyor.
}
