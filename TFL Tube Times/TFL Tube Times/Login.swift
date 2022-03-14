//
//  Login.swift
//  TFL Tube Times
//
//  Created by Christian Grinling on 10/03/2021.
//


import UIKit
import Firebase

class Login: UIViewController,UITextFieldDelegate {
    
    var logoColour = UIColor.white//UIColor(red: 0.32, green: 0.42, blue: 0.93, alpha: 1.00)
    var logoImageColour = UIColor(red: 0.32, green: 0.42, blue: 0.93, alpha: 1.00)
    let borderwidth = CGFloat(3)
    let cornervalue = CGFloat(20)
    let grayColour = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
    
    lazy var LogoImage: UIImageView = {
         let image = UIImageView()
         image.translatesAutoresizingMaskIntoConstraints = false
         image.image = UIImage(named: "underground")
        image.contentMode = .scaleAspectFit
         return image
     }()
    
    lazy var LoginTitle: UILabel = {
        let label = UILabel()
        label.layout(colour: .black, size: 45, text: "TubeTap")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var namefield: UITextField = {
        let textfield = UITextField()
        textfield.layout(placeholder: "First Name", backgroundcolour: grayColour, bordercolour: logoColour, borderWidth: borderwidth, cornerRadius: cornervalue)
        textfield.addPadding()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.returnKeyType = .continue
        textfield.delegate = self
        textfield.tag = 0
        return textfield
    }()
    
    lazy var emailfield: UITextField = {
        let textfield = UITextField()
        textfield.layout(placeholder: "Email", backgroundcolour: grayColour, bordercolour: logoColour, borderWidth: borderwidth, cornerRadius: cornervalue)
        textfield.addPadding()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.returnKeyType = .continue
        textfield.delegate = self
        textfield.tag = 1
        return textfield
    }()
    
    lazy var passwordfield: UITextField = {
        let textfield = UITextField()
        textfield.layout(placeholder: "Password", backgroundcolour: grayColour, bordercolour: logoColour, borderWidth: borderwidth, cornerRadius: cornervalue)
        textfield.isSecureTextEntry = true
        textfield.addPadding()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.returnKeyType = .done
        textfield.delegate = self
        textfield.tag = 2
        return textfield
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.layout(textcolour: .white, backgroundColour: .black, size: 20, text: "Sign Up", image: nil, cornerRadius: 20)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        navigationController?.isNavigationBarHidden = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismisskeyboard)))
        
    }
    
    @objc func dismisskeyboard() {
        namefield.resignFirstResponder()
        emailfield.resignFirstResponder()
        passwordfield.resignFirstResponder()
    }
    
    @objc func login() {
        self.showSpinner(onView: view)
        guard let email = emailfield.text else {return}
        guard let password = passwordfield.text else {return}
        guard let name = namefield.text else {return}
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongself = self else {return}
            if let error = error as NSError? {
            switch AuthErrorCode(rawValue: error.code) {
            case .operationNotAllowed:
              // Error: The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section.
                strongself.AlertofError("Please try again", "Our server isn't having the best time right now.")
                strongself.removeSpinner()
                return
            case .emailAlreadyInUse:
              // Error: The email address is already in use by another account.
                strongself.AlertofError("Please try again", "Email Already In Use")
                strongself.removeSpinner()
                return
            case .invalidEmail:
              // Error: The email address is badly formatted.
                strongself.AlertofError("Please try again", "Email address is badly formatted")
                strongself.removeSpinner()
                return
            case .weakPassword:
              // Error: The password must be 6 characters long or more.
                strongself.AlertofError("Please try again", "Password must be 6 characters long or more")
                strongself.removeSpinner()
                return
            default:
                print("Error: \(error.localizedDescription)")
                strongself.removeSpinner()
                return
            }
          } else {
                guard let uid = Auth.auth().currentUser?.uid else {return}
                guard let user = Auth.auth().currentUser else {return}  
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = name
                changeRequest.commitChanges { error in
                 if let error = error {
                    print(error.localizedDescription)
                 } else {
                   print("Added Display Name and email")
                }
            }
                let userDoc = Firestore.firestore().collection("users").document(uid)
                userDoc.setData(["name":name], merge:true)
                strongself.removeSpinner()
                strongself.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func setupView() {
        view.addSubview(LogoImage)
        view.addSubview(LoginTitle)
        view.addSubview(namefield)
        view.addSubview(emailfield)
        view.addSubview(passwordfield)
        view.addSubview(loginButton)
        
            
        LoginTitle.anchor(top: nil, paddingTop: 0, bottom: namefield.topAnchor, paddingBottom: 50, left: nil, paddingLeft: 0, right: nil, paddingRight: 0, width: 0, height: 0)
        LoginTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: -30).isActive = true
            
        LogoImage.anchor(top: nil, paddingTop: 0, bottom: namefield.topAnchor, paddingBottom: 50, left: LoginTitle.rightAnchor, paddingLeft: 5, right: nil, paddingRight: 0, width: 60, height: 60)



        namefield.anchor(top: nil, paddingTop: 0, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 20, right: view.rightAnchor, paddingRight: 20, width: 0, height: 45)
        namefield.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        namefield.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant:-40).isActive = true
        
        emailfield.anchor(top: namefield.bottomAnchor, paddingTop: 30, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 20, right: view.rightAnchor, paddingRight: 20, width: 0, height: 45)
        emailfield.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
 
        
        passwordfield.anchor(top: emailfield.bottomAnchor, paddingTop: 30, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 20, right: view.rightAnchor, paddingRight: 20, width: 0, height: 45)
            passwordfield.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        loginButton.anchor(top: passwordfield.bottomAnchor, paddingTop: 50, bottom: nil, paddingBottom: 0, left: view.leftAnchor, paddingLeft: 20, right: view.rightAnchor, paddingRight: 20, width: 0, height: 50)
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
            
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       // Try to find next responder
       if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
          nextField.becomeFirstResponder()
       } else {
          // Not found, so remove keyboard.
          textField.resignFirstResponder()
       }
       // Do not add a line break
       return false
    }
 }


