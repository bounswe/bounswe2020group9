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
                destinationVC.delegate = self
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
                        if let country = countryTextField.text , let city = cityTextField.text, let pk = postalCodeTextField.text , let user = UserDefaults.standard.value(forKey: K.userIdKey) as? Int{
                            if country.count == 0 && city.count == 0 && pk.count == 0 {
                                alertController.message = "Please click on the button(Get Country, City and PK from Map) above and select the location from the map"
                                self.present(alertController, animated: true, completion: nil)
                            }else{
                                APIManager().addNewAddressForCustomer(addressName: addressName, fullAddress: fullAddress, country: country, city: city, postalCode: Int(pk) ?? 0, user: user) { (result) in
                                    switch result {
                                    case .success(_):
                                        alertController.message = "Your new address has been successfully added!"
                                        self.present(alertController, animated: true, completion: nil)
                                    case .failure(_):
                                        alertController.message = "There was a problem adding the new address!"
                                        self.present(alertController, animated: true, completion: nil)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        let lon: Double = Double("\(pdblLongitude)")!
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        ceo.reverseGeocodeLocation(loc, completionHandler:{(placemarks, error) in
            if (error != nil)
            {
                let alertController = UIAlertController(title: "Alert!", message: "We could not get your address information, please try again! You have to long press when selecting your address.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
            let pm = placemarks! as [CLPlacemark]
            
            if pm.count > 0 {
                let pm = placemarks![0]
                if pm.administrativeArea != nil {
                    self.cityTextField.text = pm.administrativeArea
                }
                if pm.country != nil {
                    self.countryTextField.text = pm.country
                }
                if pm.postalCode != nil {
                    self.postalCodeTextField.text = pm.postalCode
                }
            }
        })
    }
}
//MARK: - Extension MapViewControllerDelegate
extension AddNewAddressViewController:MapViewControllerDelegate{
    func mapViewControllerDidGetLocation(latitude: Float, longitude: Float, annotation:MKPointAnnotation) {
        self.addressAnnotation = annotation
        getAddressFromLatLon(pdblLatitude: "\(latitude)", withLongitude: "\(longitude)")
    }
    
    func mapViewControllerDidFail() {
        let alertController = UIAlertController(title: "Alert!", message: "We could not get your address information, please try again! You have to long press when selecting your address.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
