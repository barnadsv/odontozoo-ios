//
//  ViewController.swift
//  odontozoo-ios
//
//  Created by Leonardo de Araujo Barnabe on 25/09/17.
//  Copyright © 2017 Leonardo de Araujo Barnabe. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // ...
        //}
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //if let _ = Auth.auth()?.currentUser {
        //    //self.signIn()
        //}

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Auth.auth().removeStateDidChangeListener(handle!)
    }

    
    @IBAction func didTapSignIn(_ sender: Any) {
        if let email = self.emailTextField.text, let password = self.passwordTextField.text {
            showSpinner {
                // [START headless_email_auth]
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    // [START_EXCLUDE]
                    self.hideSpinner {
                        guard let _ = user else {
                            if let error = error {
                                if let errCode = AuthErrorCode(rawValue: error._code) {
                                    switch errCode {
                                    case .userNotFound:
                                        //self.showAlert("Conta de usuário não encontrada. Registre-se.")
                                        self.showAlert("Combinação usuário/senha incorreta.")
                                    case .wrongPassword:
                                        self.showAlert("Combinação usuário/senha incorreta.")
                                    default:
                                        self.showAlert("Erro: \(error.localizedDescription)")
                                    }
                                }
                            }
                            //assertionFailure("user and error are nil")
                            return
                        }
                        self.signIn()
                    }
                    // [END_EXCLUDE]
                }
                // [END headless_email_auth]
            }
        } else {
            self.showAlert("email/senha não podem ser vazios.")
            //self.showMessagePrompt("email/senha não podem ser vazios.")
        }
        
    }
    
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "Odontozoo", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func signIn() {
        //performSegue(withIdentifier: "SignInFromLogin", sender: nil)
    }

}

