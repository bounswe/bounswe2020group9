//
//  AddNewAddressViewController.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 23.01.2021.
//

import UIKit
import MapKit

class AddNewAddressViewController: UIViewController {
    
    @IBOutlet weak var addressNameTextField: UITextField!
    @IBOutlet weak var fullAddressTextView: UITextView!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var postalCodeTextField: UITextField!
    
    var mapViewController = MapViewController()
    var latitude:Float?
    var longitude:Float?
    var addressAnnotation: MKPointAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fullAddressTextView.layer.borderColor = #colorLiteral(red: 0.9214980006, green: 0.9216085076, blue: 0.9214602709, alpha: 1)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openMapButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "AddAddressToMap", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddAddressToMap" {
            if let destinationVC = segue.destination as? MapViewController {
                //destinationVC.delegate = self
                if let annotation = self.addressAnnotation{
                    destinationVC.annotations.append(annotation)
                }
            }
        }
    }
    @IBAction func saveAddressButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Alert!", message: "Message", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        
        if let addressName = addressNameTextField.text{
            if addressName.count < 3{
                alertController.message = "Please enter an address name at least 3 characters long."
                self.present(alertController, animated: true, completion: nil)
            }else {
                if let fullAddress = fullAddressTextView.text {
                    if fullAddress.count == 0 {
                        alertController.message = "Please enter a valid full address."
                        self.present(alertController, animated: true, completion: nil)
                    }else {
                        if let country = countryTextField.text , let city = cityTextField.text, let pk = postalCodeTextField.text {
                            if country.count == 0 && city.count == 0 && pk.count == 0 {
                                alertController.message = "Please click on the button(Get Country, City and PK from Map) above and select the location from the map"
                                self.present(alertController, animated: true, completion: nil)
                            }else{
                                //TODO: backend
                            }
                        }
                    }
                }
            }
        }
    }
}

