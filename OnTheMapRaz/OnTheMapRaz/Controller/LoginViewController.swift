//
//  LoginViewController.swift
//  OnTheMapRaz
//
//  Created by pc on 02/05/2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var usernameTextField: LoginTextField!
    @IBOutlet weak var passwordTextField: LoginTextField!
    
    
    
    // MARK: - View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        usernameTextField.text = ""
        passwordTextField.text = ""
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    }
    
    
    
    // MARK: - Actions
    
    @IBAction func loginTapped(_ sender: Any) {
        OnTheMapClient.createSessionId(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "", completion: handleSessionResponse(success:error:))
    }
    
    
    @IBAction func signUp(_ sender: Any) {
        UIApplication.shared.open(OnTheMapClient.Endpoins.signUp.url, options: [:], completionHandler: nil)
    }
    
    
    
    // MARK: - Helper Methods
    
    func handleSessionResponse(success: Bool, error: Error?) {
        if success {
            print("successfully logged in")
            print(Auth.sessionId)
            performSegue(withIdentifier: "completeLogin", sender: nil)
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }

    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
}

