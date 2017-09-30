//
//  RegisterViewController.swift
//  odontozoo-ios
//
//  Created by Leonardo de Araujo Barnabe on 30/09/17.
//  Copyright © 2017 Leonardo de Araujo Barnabe. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
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
    
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "Odontozoo", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func register() {
        //performSegue(withIdentifier: "SignInFromLogin", sender: nil)
    }


}
