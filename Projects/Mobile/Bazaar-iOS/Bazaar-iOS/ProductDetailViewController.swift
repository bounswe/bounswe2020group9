//
//  ProductDetailViewController.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 2.12.2020.
//

import UIKit

class ProductDetailViewController: UIViewController {
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var listPickerView: UIPickerView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var starRatingView: StarRatingView!
    @IBOutlet weak var amountPickerTextField: UITextField!
    @IBOutlet weak var listPickerTextField: UITextField!
    @IBOutlet weak var addToListButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addToCartBurtton: UIButton!
    @IBOutlet weak var addToListStackView: UIStackView!
    @IBOutlet weak var seeVendorButton: UIButton!
    
    var product: ProductData!
    let buyCount = [1,2,3,4,5,6,7,8,9,10]
    let imageCache = NSCache<NSString, UIImage>()
    
    var customerListsInstance = CustomerLists.shared
    var selectedList: Int?
    
    /*
     function that is automatically called every time the view is going to appear.
     used for doing the initializations necessary for the view.
     */
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        amountPickerTextField.tintColor = UIColor.clear
        amountPickerTextField.layer.borderWidth = 1
        amountPickerTextField.layer.cornerRadius = 5
        amountPickerTextField.layer.borderColor = #colorLiteral(red: 1, green: 0.6431372549, blue: 0.3568627451, alpha: 1)
        amountPickerTextField.rightViewMode = .always
        amountPickerTextField.translatesAutoresizingMaskIntoConstraints = true
        
        listPickerTextField.tintColor = UIColor.clear
        listPickerTextField.layer.borderWidth = 1
        listPickerTextField.layer.cornerRadius = 5
        listPickerTextField.layer.borderColor = #colorLiteral(red: 1, green: 0.6431372549, blue: 0.3568627451, alpha: 1)
        
        let arrow = UIImageView(image: UIImage(named: "chevron.down")?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -3, bottom: 0, right: -3)))
        
        amountPickerTextField.setRightView(arrow, padding: 0)
        arrow.contentMode = .scaleAspectFill
        amountPickerTextField.rightView = arrow
        
        
        self.view.bringSubviewToFront(priceLabel)
        self.view.bringSubviewToFront(addToCartBurtton)

        self.navigationController?.navigationBar.backItem?.title = ""
        
        if let isLoggedIn = UserDefaults.standard.value(forKey: K.isLoggedinKey) as? Bool{
            if isLoggedIn {
                addToListStackView.isHidden = false
                self.customerListsInstance.fetchCustomerLists()
            }
        }
        
        
    }
    
    /*
     function that is automatically called every time the view is going to disappear.
     */
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)

    }
    
    /*
     function that is automatically called every time after the view appeared.
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let isLoggedIn = UserDefaults.standard.value(forKey: K.isLoggedinKey) as? Bool{
            if isLoggedIn {
                addToListStackView.isHidden = false
                self.customerListsInstance.fetchCustomerLists()
            }else {
                self.addToListStackView.isHidden = true
            }
        }else {
            self.addToListStackView.isHidden = true
        }
    }
    
    /*
     function that is automatically called when the view is first loaded.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        listPickerView.delegate = self
        amountPickerTextField.inputView = pickerView
        listPickerTextField.inputView = listPickerView
        setProductInfo()
        dismissPickerView()
        
        if let isLoggedIn = UserDefaults.standard.value(forKey: K.isLoggedinKey) as? Bool{
            if !isLoggedIn {
                self.addToListStackView.isHidden = true
                return
            }else {
                self.addToListStackView.isHidden = false
                self.customerListsInstance.fetchCustomerLists()
                if !(customerListsInstance.dataFetched) {
                    self.customerListsInstance.fetchCustomerLists()
                }
            }
        }else {
            self.addToListStackView.isHidden = true
            return
        }
        seeVendorButton.titleLabel?.adjustsFontSizeToFitWidth = true
        seeVendorButton.titleLabel?.numberOfLines = 0
        seeVendorButton.titleLabel?.lineBreakMode = .byWordWrapping 
        seeVendorButton.sizeToFit()
    }
    
    /*
     function for filling the labes and imageviews in the viewcontroller with product's information.
     */
    func setProductInfo() {
        brandLabel.text = product.brand
        productNameLabel.text = product.name
        starRatingView.rating = Float(product.rating)
        let description = "No description provided for this product."
        descriptionLabel.text = description
        if product.detail != "" {
            descriptionLabel.text = product.detail
        }
        descriptionLabel.numberOfLines = 0
        descriptionLabel.sizeToFit()
        descriptionLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        let vendor = AllVendors.shared.allVendors.filter{$0.id == product.vendor}[0]
        seeVendorButton.setTitle("See more about "+vendor.company, for: .normal)
        priceLabel.text = "₺" + String(product.price)
        if product.picture != nil {
            if let img = AllProducts.shared.allImages[product.id] {
                productImageView.image = img
                return
            }
            do{
                try productImageView.loadImageUsingCache(withUrl: product.picture ?? "", forProduct: product)
            } catch let error {
                print(error)
                productImageView.image = UIImage(named:"xmark.circle")
            }
        } else {
            productImageView.image = UIImage(named:"xmark.circle")
        }
    }
    
    /*
     function that is called when Add to Cart button is pressed
     */
    @IBAction func addToCart(_ sender: UIButton) {
        if let user = UserDefaults.standard.value(forKey: K.userIdKey) as? Int {
            let amount:Int? = Int(amountPickerTextField.text!)
            print("add to cart pushed")
            APIManager().addToCart(user: user, productID: product.id, amount: amount!, completionHandler: { result in
                switch result{
                case .success(let cart):
                    let alertController = UIAlertController(title: "Success", message: "Item successfully added to your cart.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alertController, animated:true, completion: nil)
                case .failure(let error):
                    let alertController = UIAlertController(title: "Problem", message: "The item cannot be added to your cart due to a network problem. Please try again later.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alertController, animated:true, completion: nil)
                    print("error while adding product to cart: ",error)
                }
            })
        } else {
            let alertController = UIAlertController(title: "Problem", message: "You should be logged in to use your cart.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alertController, animated:true, completion: nil)
        }
    }
    
    /*
     function that is called when See the Vendor's profile button is pressed.
     used for directing the user to the product's vendor's profile.
     */
    @IBAction func seeVendorButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "productDetailToVendorProfileForUserSegue", sender: nil)
    }
    
    /*
     function that is called when Add to List button is pressed.
     used for adding the product to the customer list that was chosen.
     */
    @IBAction func addToList(_ sender: UIButton) {
        if let user = UserDefaults.standard.value(forKey: K.userIdKey) as? Int {
            if(listPickerTextField.text == "Choose List") {
                let alertController = UIAlertController(title: "Alert", message: "No list has been chosen.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alertController, animated:true, completion: nil)
            } else {
                let list_id:Int? = self.selectedList
                
                for p in customerListsInstance.customerLists.filter({$0.id==list_id})[0].products {
                    if p.id == product.id {
                        let alertController = UIAlertController(title: "Problem", message: "The Item is already in the list \"\(listPickerTextField.text!)\"", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alertController, animated:true, completion: nil)
                        return
                    }
                }
                
                APIManager().addToList(userId: user, list_id: list_id!, product_id: product.id, completionHandler: { result in
                    switch result{
                    case .success(_):
                        let alertController = UIAlertController(title: "Success", message: "The Item is added to the list \"\(self.listPickerTextField.text!)\"", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alertController, animated:true, completion: nil)
                        return
                    case .failure(let error):
                        let alertController = UIAlertController(title: "Problem", message: "The item cannot be added to the list specified.", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alertController, animated:true, completion: nil)
                    }
                })
            }
        }
        
    }
    
    /*
     function that navigates the user to the previous viewcontroller when the back button is pressed.
     */
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
     function that sends the necessary information to the next view controller before a segue is performed.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let reviewsVC = segue.destination as? ReviewsViewController {
            reviewsVC.productId = product.id
        } else if let vendorProfileVC = segue.destination as? VendorProfileForUserViewController {
            vendorProfileVC.vendor = AllVendors.shared.allVendors.filter{$0.id == product.vendor}[0]
        }
    }
}

// MARK: - Amount of Purchase
extension ProductDetailViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    /*
     default function for UIPickerView.
     */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /*
     default function that returns the number of options that will be shown in the UIPickerView.
     */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == listPickerView {
            return self.customerListsInstance.customerLists.count+1
        } else {
            return buyCount.filter{$0<=product.stock}.count
        }
    }
    
    /*
     function that sets the names of the options in the UIPickerView
     */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == listPickerView {
            if row == 0 {
                return "Choose List"
            } else {
                return self.customerListsInstance.customerLists[row-1].name
            }
        } else {
            let available = buyCount.filter{$0<=product.stock}
            let str = String(available[row])
            return str
        }
    }
    
    /*
     function that decides what will happen after an option from the UIPickerView is selected.
     */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.pickerView {
            let available = buyCount.filter{Int($0)<=product.stock}
            amountPickerTextField.text = String(available[row])
            
        } else if pickerView == listPickerView {
            if(row==0) {
                listPickerTextField.text = "Choose List"
            } else {
                listPickerTextField.text = customerListsInstance.customerLists[row-1].name
                self.selectedList = customerListsInstance.customerLists[row-1].id
            }
        }
    }

    /*
     function that is called to reset the values of the UIPickerView before it's dismissed.
     */
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        doneButton.tintColor = #colorLiteral(red: 1, green: 0.6431372549, blue: 0.3568627451, alpha: 1)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.pickerCancel))
        cancelButton.tintColor = #colorLiteral(red: 1, green: 0.6431372549, blue: 0.3568627451, alpha: 1)
        toolBar.setItems([doneButton,cancelButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        amountPickerTextField.inputAccessoryView = toolBar
        listPickerTextField.inputAccessoryView = toolBar
    }
    
    @objc func action() {
        view.endEditing(true)
    }
    
    @objc func pickerCancel() {
        if pickerView == listPickerView {
            listPickerTextField.text = "Choose List"
        }
        view.endEditing(true)
    }
}

extension UITextField {
    /*
     function that sets an arrow image for the UITextField for choosing the amount of the product.
     */
    func setRightView(_ view: UIView, padding: CGFloat) {
        view.translatesAutoresizingMaskIntoConstraints = true

        let outerView = UIView()
        outerView.translatesAutoresizingMaskIntoConstraints = false
        outerView.addSubview(view)

        outerView.frame = CGRect(
            origin: .zero,
            size: CGSize(
                width: view.frame.size.width + padding,
                height: view.frame.size.height
            )
        )

        view.center = CGPoint(
            x: outerView.bounds.size.width / 2,
            y: outerView.bounds.size.height / 2
        )

        rightView = outerView
    }
}

let imageCache = NSCache<NSString, UIImage>()


extension UIImageView {
    
    /*
     an extension function for cache support while downloading images via Alamofire.
     loads from cache if the url is previously used, downloads via Alamofire if the url is not previously used.
     */
    func loadImageUsingCache(withUrl urlString : String, forProduct prod: ProductData?) throws -> String {
        let url = URL(string: urlString)
        if url == nil { return "url nil" }
        self.image = nil

        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
            self.image = cachedImage
            return "image found in cache"
        }

        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .gray)
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.center = self.center

        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error ?? "errr")
                return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                    if let product = prod {
                        AllProducts.shared.allImages[product.id] = image
                    }
                    activityIndicator.removeFromSuperview()
                }
            }

        }).resume()
        return "done"
    }
}




