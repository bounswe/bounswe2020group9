//
//  AddCreditCardViewController.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 21.01.2021.
//

import UIKit

class AddCreditCardViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var monthTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!
    @IBOutlet weak var cardNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveCardButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Alert!", message: "Message", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        
        if let firstName = firstNameTextField.text{
            if !firstName.isName {
                alertController.message = "Your First Name is invalid. Please enter a valid First Name."
                self.present(alertController, animated: true, completion: nil)
            }else {
                if let lastName = lastNameTextField.text {
                    if !lastName.isName {
                        alertController.message = "Your Last Name is invalid. Please enter a valid Last Name."
                        self.present(alertController, animated: true, completion: nil)
                    }else {
                        if let cardNumber = cardNumberTextField.text {
                            if cardNumber.count != 16 {
                                alertController.message = "Your card number is invalid. Please enter 16-digit card number."
                                self.present(alertController, animated: true, completion: nil)
                            }else{
                                if let month = monthTextField.text{
                                    if month.count != 2 || Int(month) ?? 1 < 0 || Int(month) ?? 1 > 12  {
                                        alertController.message = "Please enter the month as two numbers between 01 and 12."
                                        self.present(alertController, animated: true, completion: nil)
                                    }else {
                                        if let year = yearTextField.text{
                                            if year.count != 2 || Int(year) ?? 20 < 21{
                                                alertController.message = "Please enter the year as two numbers greater than 20"
                                                self.present(alertController, animated: true, completion: nil)
                                            }else {
                                                if let cvv = cvvTextField.text{
                                                    if cvv.count != 3{
                                                        alertController.message = "Please enter the CVV as three numbers"
                                                        self.present(alertController, animated: true, completion: nil)
                                                    }else {
                                                        
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
    }
}
