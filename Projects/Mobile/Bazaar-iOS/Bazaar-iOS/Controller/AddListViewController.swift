//
//  AddListViewController.swift
//  Bazaar-iOS
//
//  Created by Beste Goger on 10.12.2020.
//

import UIKit


class AddListViewController: UIViewController {
    
    @IBOutlet var addListTitle: UILabel!
    @IBOutlet var addListButton: UIButton!
    @IBOutlet var listNameTextField: UITextField!
    @IBOutlet var isPrivateRadioButton: RadioButton!
    @IBOutlet var isPublicRadioButton: RadioButton!
    @IBOutlet var frameView: UIView!
    
    var isPrivate: Bool?
    var delegate: WishlistViewController?
    
    var listToEdit: CustomerListData?
    var addedList: CustomerListData?
    
    override func viewDidLoad() {
        frameView.layer.shadowColor = UIColor.black.cgColor
        self.view.bringSubviewToFront(frameView)
        if let list = listToEdit {
            addListButton.setTitle("Edit", for: .normal)
            addListTitle.text = "Edit List"
            listNameTextField.placeholder = list.name
            isPrivateRadioButton.isSelected = list.is_private
            self.isPrivate = list.is_private
            isPublicRadioButton.isSelected = !list.is_private
        }
    }
    
    @IBAction func addListButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Alert!", message: "Message", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        
        
        if let list = listToEdit {
            if let listName = listNameTextField.text{
                let newListName = ((listName.count) > 0) ? listName : list.name
                if let isPriv = self.isPrivate ,let  userId = UserDefaults.standard.value(forKey: K.userIdKey) as? Int{
                    APIManager().editList(userId: userId, list: String(list.id), newName: newListName, newIsPrivate: String(isPriv)) { (result) in
                        switch result {
                        case .success(let listData):
                            self.dismiss(animated: false, completion: nil)
                            self.delegate?.addedList = listData
                            self.delegate?.performSegue(withIdentifier: "listsToListDetailSegue", sender: nil)
                        case .failure(_):
                            alertController.message = "The list cannot be edited"
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                }
            }
        } else if let listName = listNameTextField.text{
            if !(listName.count > 0) {
                alertController.message = "Please enter a List Name"
                self.present(alertController, animated: true, completion: nil)
            } else {
                if let isPriv = self.isPrivate ,let userId=UserDefaults.standard.value(forKey: K.userIdKey) as? Int{
                    APIManager().addList(name: listName, userId: userId, isPrivate: isPriv) { (result) in
                        switch result {
                        case .success(let listData):
                            self.dismiss(animated: false, completion: nil)
                            self.delegate?.addedList = listData
                            self.delegate?.performSegue(withIdentifier: "listsToListDetailSegue", sender: nil)
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
                self.isPublicRadioButton.sendActions(for: .touchUpInside)
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
                self.isPrivateRadioButton.sendActions(for: .touchUpInside )
            }
            self.isPrivate = false
        } else{
            self.isPrivate = nil
        }
    }
}
