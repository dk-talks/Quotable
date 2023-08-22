//
//  RegisterViewController.swift
//  Quotable
//
//  Created by Dinesh Sharma on 21/08/23.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var textEmail: UITextField!
    
    @IBOutlet weak var btnNext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if let _ = user {
                self.performSegue(withIdentifier: "toHomeVC", sender: self)
            }
        }
        
        
        textEmail.delegate = self
        textPassword.delegate = self

        // Do any additional setup after loading the view.
        checkFields()
    }
    
    
    

    override func viewWillAppear(_ animated: Bool) {
        
    }

    @IBAction func btnNextTapped(_ sender: Any) {
        
        if let email = textEmail.text, let password = textPassword.text {
            if(isValidEmail(email)) {
                
                Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                  guard let strongSelf = self else { return }
                    
                    if let _ = authResult {
                        print("sign in successfull")
                        strongSelf.performSegue(withIdentifier: "toHomeVC", sender: self)
                    }
                }
                
                let signUpThread = Thread {
                    sleep(1)
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        if let error = error {
                            print("some error occured in creating user: \(error)")
                            self.showAlert(error.localizedDescription)
                            return;
                        }
                        
                        // but before, we want to verify email of the user
                        
                        Auth.auth().currentUser?.sendEmailVerification { error in
                            if let error = error {
                                self.showAlert(error.localizedDescription)
                                return;
                            }
                        }
                        
                        self.showAlert("Verification Email has been successfully sent!\n Verify & Login")
                    }
                }
                
                signUpThread.start()
                
                
                
                
                
            } else {
                showAlert("Please Enter a Valid Email")
                return;
            }
        }
        
        
    }
    
    private func checkFields() {
        if let email = textEmail.text, let pass = textPassword.text {
            btnNext.isEnabled = !email.isEmpty && !pass.isEmpty
        } else {
            btnNext.isEnabled = false
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Quotable", message: message, preferredStyle: .actionSheet)
        let okBtn = UIAlertAction(title: "OK", style: .default) { action in
            alert.dismiss(animated: true)
        }
        alert.addAction(okBtn)
        alert.preferredAction = okBtn
        present(alert, animated: true)
    }
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        checkFields()
        
        return true;
    }
    
}
