//
//  AddListViewController.swift
//  Bazaar-iOS
//
//  Created by Beste Goger on 10.12.2020.
//

import UIKit


class AddListViewController: UIViewController {
    
    @IBOutlet var addListButton: UIButton!
    @IBOutlet var listNameTextField: UITextField!
    @IBOutlet var isPrivateRadioButton: RadioButton!
    @IBOutlet var isPublicRadioButton: RadioButton!
    @IBOutlet var frameView: UIView!
    var isPrivate: Bool?
    
    override func viewDidLoad() {
        frameView.layer.borderColor = #colorLiteral(red: 1, green: 0.6431372549, blue: 0.3568627451, alpha: 1)
        frameView.layer.shadowColor = UIColor.black.cgColor
        self.view.bringSubviewToFront(frameView)
    }
    
    
    @IBAction func addListButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Alert!", message: "Message", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        
        if let listName = listNameTextField.text{
            if !(listName.count > 0) {
                alertController.message = "Please enter a List Name"
                self.present(alertController, animated: true, completion: nil)
            } else {
                if let isPriv = self.isPrivate {
                    APIManager().addList(name: listName, customer: UserDefaults.standard.value(forKey: K.user_id) as! String, isPrivate: isPriv) { (result) in
                        switch result {
                        case .success(_):
                            self.dismiss(animated: false, completion: nil)
                        case .failure(_):
                            alertController.message = "The list cannot be added"
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                } else {
                    alertController.message = "Choose one, Private or Public"
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func isPrivateButtonPressed(_ sender: RadioButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            if (self.isPrivate != nil) {
                self.isPrivateRadioButton.sendActions(for: .touchUpInside)
            }
            self.isPrivate = true
        } else{
            self.isPrivate = nil
        }
    }
    
    @IBAction func isPublicButtonPressed(_ sender: RadioButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            if (self.isPrivate != nil) {
                self.isPublicRadioButton.sendActions(for: .touchUpInside)
            }
            self.isPrivate = false
        } else{
            self.isPrivate = nil
        }
    }
    
    
}
