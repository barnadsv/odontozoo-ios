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
    var ref: DatabaseReference!
    var usuario: Usuario!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.signIn()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if Auth.auth().currentUser != nil {
//            self.performSegue(withIdentifier: "signIn", sender: nil)
//        }
        if let _ = Auth.auth().currentUser {
            self.signIn()
        }
        ref = Database.database().reference()
        
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
                        let encodedEmail = Utils.encodeEmail(email: email)
                        self.ref.child("usuarios").child(encodedEmail!).observeSingleEvent(of: .value, with: { (snapshot) in
                            // Check if user already exists
                            guard !snapshot.exists() else {
                                self.ref.child("usuarios/"+encodedEmail!+"/logouComSenha").setValue(true)
                                let value = snapshot.value as? NSDictionary
                                let nome = value?["nome"] as? String ?? ""
                                //let dataCadastro = value?["dataCadastro"] as? ["String":"Double"]
                                
                                //self.usuario = Usuario(email: email, nome: nome, dataCadastro: dataCadastro, logouComSenha: true)
                                self.signIn()
                                return
                            }
                            
                            // Otherwise, create the new user account
//                            self.showTextInputPrompt(withMessage: "Email:") { (userPressedOK, username) in
//                                
//                                guard let username = username else {
//                                    self.showMessagePrompt("Email não pode ser vazio.")
//                                    return
//                                }
//                                
//                                self.saveUserInfo(user, withEmail: encodedEmail)
//                            }
                        }) // End of observeSingleEvent
//                        self.signIn()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "signInFromLogin" {
            if let toViewController = segue.destination as? OdontogramaListViewController {
                //toViewController.logouComSenha = true
                toViewController.usuario = self.usuario
            }
        }
    }
    
    @IBAction func didTapResetPassword(_ sender: Any) {
        
        let prompt = UIAlertController(title: "Odontozoo", message: "Email:", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            let userInput = prompt.textFields![0].text
            if (userInput!.isEmpty) {
                return
            }
            self.showSpinner {
                // [START password_reset]
                Auth.auth().sendPasswordReset(withEmail: userInput!, completion: { (error) in
                    // [START_EXCLUDE]
                    self.hideSpinner {
                        if let error = error {
                            if let errCode = AuthErrorCode(rawValue: error._code) {
                                switch errCode {
                                case .userNotFound:
                                    DispatchQueue.main.async {
                                        self.showAlert("Conta de usuário não encontrada.")
                                    }
                                default:
                                    DispatchQueue.main.async {
                                        self.showAlert("Erro: \(error.localizedDescription)")
                                    }
                                }
                            }
                            return
                        } else {
                            DispatchQueue.main.async {
                                self.showAlert("Você receberá um e-mail em breve para redefinir sua senha.")
                            }
                        }
                    }
                    // [END_EXCLUDE]
                })
                // [END password_reset]
            }
        }
        prompt.addTextField(configurationHandler: nil)
        prompt.addAction(okAction)
        present(prompt, animated: true, completion: nil)
    }
    
//    // Saves user profile information to user database
//    func saveUserInfo(_ user: Firebase.User, withUsername username: String) {
//        
//        // Create a change request
//        self.showSpinner {}
//        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
//        changeRequest?.displayName = username
//        
//        // Commit profile changes to server
//        changeRequest?.commitChanges() { (error) in
//            
//        
//            if let error = error {
//                self.showMessagePrompt(error.localizedDescription)
//                return
//            }
//            
//            // [START basic_write]
//            self.ref.child("users").child(user.uid).setValue(["username": username])
//            // [END basic_write]
//            self.performSegue(withIdentifier: "signIn", sender: nil)
//        }
//        self.hideSpinner {}
//        
//    }
    
    
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "Odontozoo", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func signIn() {
        performSegue(withIdentifier: "signInFromLogin", sender: nil)
    }

}

