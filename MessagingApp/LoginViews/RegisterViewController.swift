//
//  RegisterViewController.swift
//  MessagingApp
//
//  Created by Sefa Acar on 30.04.2024.
//

import UIKit

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var finishBtn: UIButton!
    
    @IBOutlet var profileImageGestureRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        profileImageGestureRecognizer.addTarget(self, action: #selector(self.profileImageClicked))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(profileImageGestureRecognizer)
        
    }
    
    @IBAction func finishBtnClicked(_ sender: Any) {
    }
    
    private func configureUI(){
        cornerRadius(for: finishBtn)
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
    }
    
    private func validateFields(name: String, email: String, password: String, phone: String, countryCode: String) -> Bool {
        if isValid(email: email) && name != "" && isValid(phone: phone) && password.count >= 6 && countryCode != "" {
            return true
        } else {
            return false
        }
    }
    
    @objc func profileImageClicked() {
        
    }
    
    
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
