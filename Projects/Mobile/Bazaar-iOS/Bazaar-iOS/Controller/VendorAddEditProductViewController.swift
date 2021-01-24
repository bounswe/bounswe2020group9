//
//  VendorAddEditProductViewController.swift
//  Bazaar-iOS
//
//  Created by alc on 23.01.2021.
//

import UIKit

class VendorAddEditProductViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var imageURLTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var stockTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var product:ProductData!
    var isEdit: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.descriptionTextView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor
        self.descriptionTextView.layer.borderWidth = 1.0
        self.descriptionTextView.layer.cornerRadius = 8
        if(isEdit) {
            headerLabel.text = "Edit " + product.name
            titleTextField.placeholder = product.name
            brandTextField.placeholder = product.brand
            priceTextField.placeholder = String(product.price)
            imageURLTextField.placeholder = product.picture ?? "URL of the product's image"
            descriptionTextField.placeholder = product.detail
            descriptionTextView.text = product.detail
            descriptionTextView.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            stockTextField.placeholder = String(product.stock)
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
