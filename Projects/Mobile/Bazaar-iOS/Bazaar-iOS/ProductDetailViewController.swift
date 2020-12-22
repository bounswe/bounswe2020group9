//
//  ProductDetailViewController.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 2.12.2020.
//

import UIKit

class ProductDetailViewController: UIViewController {
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var starRatingView: StarRatingView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var amountPickerTextField: UITextField!
    @IBOutlet weak var addToListButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addToCartBurtton: UIButton!
    @IBOutlet weak var vendorBackgroundView: UIView!
    @IBOutlet weak var vendorLabel: UILabel!
    
    var product: ProductData!
    let buyCount = [1,2,3,4,5,6,7,8,9,10]
    let imageCache = NSCache<NSString, UIImage>()
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        amountPickerTextField.tintColor = #colorLiteral(red: 1, green: 0.6431372549, blue: 0.3568627451, alpha: 1)
        amountPickerTextField.layer.borderWidth = 1
        amountPickerTextField.layer.cornerRadius = 5
        amountPickerTextField.layer.borderColor = #colorLiteral(red: 1, green: 0.6431372549, blue: 0.3568627451, alpha: 1)
        amountPickerTextField.rightViewMode = .always
        amountPickerTextField.translatesAutoresizingMaskIntoConstraints = true
        let arrow = UIImageView(image: UIImage(named: "chevron.down")?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -3, bottom: 0, right: -3)))
        //arrow.frame = CGRect(x: 0.0, y: 0.0, width: arrow.image!.size.width + 20.0, height: arrow.image!.size.height)
        arrow.translatesAutoresizingMaskIntoConstraints = true
        amountPickerTextField.setRightView(arrow, padding: 5)
        arrow.contentMode = .scaleAspectFill
        amountPickerTextField.rightView = arrow
        self.view.bringSubviewToFront(priceLabel)
        self.view.bringSubviewToFront(addToCartBurtton)
        vendorBackgroundView.layer.borderWidth = 2
        vendorBackgroundView.layer.cornerRadius = 20
        vendorBackgroundView.layer.borderColor = #colorLiteral(red: 1, green: 0.6431372549, blue: 0.3568627451, alpha: 1)
        self.navigationController?.navigationBar.backItem?.title = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addToListButton.titleLabel?.minimumScaleFactor = 0.5 // or some more adequate size
        self.addToListButton.titleLabel?.adjustsFontSizeToFitWidth = true
        pickerView.delegate = self
        amountPickerTextField.inputView = pickerView
        setProductInfo()
        dismissPickerView()
    }
    
    func setProductInfo() {
        brandLabel.text = product.brand
        productNameLabel.text = product.name
        starRatingView.rating = Float(product.rating)
        rateLabel.isUserInteractionEnabled = true
        rateLabel.textColor = #colorLiteral(red: 1, green: 0.6431372549, blue: 0.3568627451, alpha: 1)
        descriptionLabel.text = "Vendor: " + String(product.vendor) + "\n\nStock: " + String(product.stock)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.sizeToFit()
        descriptionLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        priceLabel.text = "₺" + String(product.price)
        if let url = product.picture {
            do{
                try productImageView.loadImageUsingCache(withUrl: product.picture ?? "")
            } catch let error {
                print(error)
                productImageView.image = UIImage(named:"xmark.circle")
            }
        } else {
            productImageView.image = UIImage(named:"xmark.circle")
        }
    }
    
    @IBAction func addToCart(_ sender: UIButton) {
        if let user = UserDefaults.standard.value(forKey: K.userIdKey) as? Int{
        if(amountPickerTextField.text == "Choose Amount") {
            let alertController = UIAlertController(title: "Problem", message: "You should choose the amount before adding an item to your cart.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated:true, completion: nil)
        } else {
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
        }
    }
        
    }
    
    
}

// MARK: - Amount of Purchase
extension ProductDetailViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return buyCount.filter{$0<=product.stock}.count+1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (row==0) {
            return "Choose Amount"
        } else {
            let available = buyCount.filter{$0<=product.stock}
            let str = String(available[row-1])
            return str
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(row==0) {
            amountPickerTextField.text = "Choose Amount"
        } else {
            let available = buyCount.filter{Int($0)<=product.stock}
            amountPickerTextField.text = String(available[row-1])
        }
    }
    
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
    }
    
    @objc func action() {
        view.endEditing(true)
    }
    @objc func pickerCancel() {
        amountPickerTextField.text = "Choose Amount"
        view.endEditing(true)
    }
}

extension UITextField {
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
    func loadImageUsingCache(withUrl urlString : String) throws -> String {
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
                print(error!)
                return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                    activityIndicator.removeFromSuperview()
                }
            }

        }).resume()
        return "done"
    }
}
