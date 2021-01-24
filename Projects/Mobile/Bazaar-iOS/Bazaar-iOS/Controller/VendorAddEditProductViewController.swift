//
//  VendorAddEditProductViewController.swift
//  Bazaar-iOS
//
//  Created by alc on 23.01.2021.
//

import UIKit
import DropDown

class VendorAddEditProductViewController: UIViewController {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var imageURLTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var stockTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var subcategoryStackView: UIStackView!
    @IBOutlet weak var categoryStackView: UIStackView!
    @IBOutlet weak var subcategoryButton: UIButton!
    @IBOutlet weak var categoryButton: UIButton!
    
    var categoryDropdown: DropDown?
    var subcategoryDropdown: DropDown?
    var product:ProductData!
    var isEdit: Bool!
    var subcategoryList:[String] = ["Subcategory"]
    var chosenCategory = ""
    var chosenSubcategory = ""
    
    let subCategoryDict: [String: [String]] = ["Clothing":["Top", "Bottom", "Outerwear", "Shoes", "Bags", "Accesories", "Activewear"],
                                               "Home":["Home Textile", "Kitchen", "Bedroom", "Bathroom", "Furniture", "Lighting","Petshop", "Other"],
                                               "Selfcare":["Perfumes", "Makeup", "Skincare", "Hair", "Body Care", "Other"],
                                               "Electronics":["Mobile Devices", "Tablets", "Computers", "Photography", "Home Appliances", "TV", "Gaming", "Other"],
                                               "Living":["Books", "Art Supplies", "Musical Devices", "Sports", "Other"]]
    let categories = ["Clothing", "Home", "Selfcare", "Electronics", "Living", "Categories"]
    let categoryIdDict = ["Top":18, "Bottom":19, "Outerwear":20, "Shoes":21, "Bags":22, "Accesories":23, "Activewear":24, "Home Textile":25, "Kitchen":26, "Bedroom":27, "Bathroom":28, "Furniture":29, "Lighting":30, "Perfumes":38, "Makeup":39, "Skincare":40, "Hair":41, "Body Care":42, "Mobile Devices":44, "Tablets":11, "Computers":12, "Photography":13, "Home Appliances":14, "TV":15, "Gaming":16, "OtherHome":31, "OtherSelfcare":43, "OtherElectronics":17, "OtherLiving":36, "Books":8, "Art Supplies":33, "Musical Devices":34, "Sports":35, "Petshop":45]
    
   
    
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
        categoryDropdown = DropDown(anchorView: categoryStackView.plainView)
        categoryDropdown!.dataSource = categories
        categoryDropdown!.direction = .bottom
        categoryDropdown?.dismissMode = .automatic
        categoryDropdown?.cancelAction = {
            let controlStates: Array<UIControl.State> = [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved]
               for controlState in controlStates {
                    self.categoryButton.setTitle("Choose Main Category", for: controlState)
               }
        }
        categoryDropdown!.selectionAction = { (index, item) in
            let controlStates: Array<UIControl.State> = [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved]
               for controlState in controlStates {
                    self.categoryButton.setTitle(item, for: controlState)
               }
            self.subcategoryDropdown?.dataSource = self.subCategoryDict[item]!
            self.chosenCategory = item
        }
        subcategoryDropdown = DropDown(anchorView: subcategoryStackView.plainView)
        subcategoryDropdown!.dataSource = subcategoryList
        subcategoryDropdown!.direction = .bottom
        subcategoryDropdown!.dismissMode = .automatic
        subcategoryDropdown!.cancelAction = {
            let controlStates: Array<UIControl.State> = [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved]
               for controlState in controlStates {
                    self.subcategoryButton.setTitle("Choose Subcategory", for: controlState)
               }
        }
        subcategoryDropdown!.selectionAction = { (index, item) in
            let controlStates: Array<UIControl.State> = [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved]
               for controlState in controlStates {
                    self.subcategoryButton.setTitle(item, for: controlState)
               }
            self.chosenSubcategory = item
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func saveProductButtonPressed(_ sender: Any) {
        
        if (isEdit) {
            var name = product.name
            if ((self.titleTextField.text != nil) && (self.titleTextField.text != "")) {
                name = titleTextField.text!
            }
            var brand = product.brand
            if ((self.brandTextField.text != nil) && (self.brandTextField.text != "")) {
                brand = brandTextField.text!
            }
            var price = product.price
            if ((self.brandTextField.text != nil) && (self.brandTextField.text != "")) {
                price = Double(brandTextField.text!) ?? product.price
            }
            var picture = product.picture
            if ((self.imageURLTextField.text != nil) && (self.imageURLTextField.text != "")) {
                picture = imageURLTextField.text!
            }
            var detail = product.detail
            if ((self.descriptionTextView.text != nil) && (self.descriptionTextView.text != "")) {
                detail = descriptionTextView.text!
            }
            var stock = product.stock
            if ((self.stockTextField.text != nil) && (self.stockTextField.text != "")) {
                stock = Int(stockTextField.text!) ?? product.stock
            }
            var categoryId = product.category.id
            if(chosenSubcategory=="Other") {
                let categoryKey = chosenSubcategory+chosenCategory
                categoryId = categoryIdDict[categoryKey] ?? 3
            } else {
                if(chosenSubcategory != "") {
                    categoryId = categoryIdDict[chosenSubcategory] ?? 3
                } else {
                    //alert
                }
            }
            
            APIManager().vendorEditProduct(prodID: product.id, title: name, brand: brand, price: price, stock: stock, description: detail, image: picture ?? "",categoryID: categoryId , completionHandler: { result in
                switch result {
                case .success(let prod):
                    print(prod)
                    DispatchQueue.main.async {
                        AllProducts.shared.allProducts = AllProducts.shared.allProducts.filter{$0.id != self.product.id}
                        AllProducts.shared.allProducts.append(prod)
                        self.dismiss(animated: true, completion: nil)
                    }
                case .failure(let error):
                    print(error)
                    let alertController = UIAlertController(title: "Problem", message: "Message", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    alertController.message = "We couldn't process your request due to an internal problem. Please try again later."
                    self.present(alertController, animated: true, completion: nil)
                }
                //print(result)
            })
        } else {
            let alertController = UIAlertController(title: "Problem", message: "Message", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            var isEmptyFieldPresent = false
            var name = ""
            if ((self.titleTextField.text != nil) && (self.titleTextField.text != "")) {
                name = titleTextField.text!
            } else {
                alertController.message = "Please provide a title for the product."
                isEmptyFieldPresent = true
            }
            var brand = ""
            if ((self.brandTextField.text != nil) && (self.brandTextField.text != "")) {
                brand = brandTextField.text!
            } else {
                alertController.message = "Please provide a brand name for the product."
                isEmptyFieldPresent = true
            }
            var price = 0.0
            if ((self.priceTextField.text != nil) && (self.priceTextField.text != "")) {
                price = Double(priceTextField.text!) ?? product.price
            } else {
                alertController.message = "Please provide a price for the product."
                isEmptyFieldPresent = true
            }
            var picture = imageURLTextField.text ?? ""
            if ((self.imageURLTextField.text != nil) && (self.imageURLTextField.text != "")) {
                picture = imageURLTextField.text!
            }
            var detail = ""
            if ((self.descriptionTextView.text != nil) && (self.descriptionTextView.text != "Product Description")) {
                detail = descriptionTextView.text!
            }
            var stock = 0
            if ((self.stockTextField.text != nil) && (self.stockTextField.text != "")) {
                stock = Int(stockTextField.text!) ?? product.stock
            } else {
                alertController.message = "Please provide a stock information for the product."
                isEmptyFieldPresent = true
            }
            var categoryId = 3
            if(chosenSubcategory == "Other") {
                let categoryKey = chosenSubcategory+chosenCategory
                categoryId = categoryIdDict[categoryKey] ?? 3
            } else {
                if(chosenSubcategory != "") {
                    categoryId = categoryIdDict[chosenSubcategory] ?? 3
                } else {
                    alertController.message = "Please choose a category for the product."
                    isEmptyFieldPresent = true
                    
                }
            }
            
            if isEmptyFieldPresent {
                self.present(alertController, animated: true, completion: nil)
            }
            
            APIManager().vendorAddProduct(title: name, brand: brand, price: price, stock: stock, description: detail, image: picture, categoryID: categoryId) { (result) in
                switch result {
                case .success(let prod):
                    AllProducts.shared.allProducts.append(prod)
                    self.dismiss(animated: true, completion: nil)
                case .failure(let err):
                    print(err)
                    let alertController = UIAlertController(title: "Problem", message: "Message", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    alertController.message = "We couldn't process your request due to an internal problem. Please try again later."
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
        
    }
    
    @IBAction func categoryButtonPressed(_ sender: Any) {
        categoryDropdown!.show()
    }
    @IBAction func subcategoryButtonPressed(_ sender: Any) {
        subcategoryDropdown!.show()
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
