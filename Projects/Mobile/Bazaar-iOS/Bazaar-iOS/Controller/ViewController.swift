//
//  ViewController.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 8.11.2020.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
   //@IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var categoriesScrollView: UIScrollView!
    @IBOutlet var categoryButtons: [UIButton]!

    
    var selectedCategoryName: String?

    var selectedCategoryButton: UIButton? {
        didSet{
            selectedCategoryName = selectedCategoryButton?.titleLabel?.text
            categorySelected()
        }
    }
        
    let CLOTHING = "Clothing"
    let HOME = "Home&Living"
    let BEAUTY = "Beauty"
    let ELECTRONICS = "Electronics"
    
    let categories = ["Clothing", "Home&Living", "Beauty", "Electronics"]
    var products: [Product] = []
    let categoriesReuseIdentifier = "CategoriesCollectionViewCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productTableView.dataSource = self
        categoriesScrollView.delegate = self
        //categoriesCollectionView.delegate = self
        //categoriesCollectionView.dataSource = self
        generateProducts()
        let padding: CGFloat = 50
        var currentWidth: CGFloat = padding
        for button in categoryButtons {
            let buttonWidth = button.frame.size.width
            currentWidth = currentWidth + buttonWidth + padding
        }
        categoriesScrollView.contentSize = CGSize(width:1000,height:categoriesScrollView!.frame.size.height)

        productTableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ReusableProdcutCell")
        //categoriesCollectionView.register(UINib.init(nibName: "CategoriesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoriesCollectionViewCell")
        //categoriesCollectionView.contentInsetAdjustmentBehavior = .never
        categoriesScrollView.translatesAutoresizingMaskIntoConstraints = false
        categoryButtons[0].isSelected = true
        selectedCategoryButton = categoryButtons[0]
    }
    

    @IBAction func buttonAction(_ sender: UIButton) {
        self.categoryButtons.forEach { (button) in
            //Reset all attibutes of button to default state
            if sender == button {
                //highlight sender
                sender.isHighlighted = true
                sender.isSelected = true
                sender.isEnabled = false
                selectedCategoryButton = sender
            } else {
                button.isHighlighted = false
                button.isSelected = false
                button.isEnabled = true
            }
        }
       
    }
    
    func categorySelected () {
        self.productTableView.reloadData()
    }
    
    
    func generateProducts() {
        
        products.append(Product(title: "Made in France Crewneck Organic Cotton Sweathsirt", brand: "Lacoste", category: CLOTHING, price: "$175.00", photo: "2"))
        products.append(Product(title: "12.12 Chronograph Watch with Black Silicone Strap", brand: "Lacoste", category: CLOTHING, price: "$160.00", photo: "1"))
        products.append(Product(title: "Court Slam Tonal Leather Trainers", brand: "Lacoste", category: CLOTHING, price: "$115.00", photo: "3"))
        products.append(Product(title: "Brushed Checkered Scarf", brand: "Urban Outfitters", category: CLOTHING, price: "$34.00", photo: "4"))
        products.append(Product(title: "Hand Painted Denim Trucker Jacket", brand: "Veni Vidi Vici", category: CLOTHING, price: "$299.00", photo: "5"))
        products.append(Product(title: "Back 2 Back Crewneck Sweatshirt", brand: "Chinatown Market", category: CLOTHING, price: "$89.00", photo: "6"))
        products.append(Product(title: "Vintage Spliced Graphic Tee", brand: "Urban Renewal", category: CLOTHING, price: "$49.00", photo: "7"))
        products.append(Product(title: "Long Sleeve Football Tee", brand: "Champion", category: CLOTHING, price: "$49.00", photo: "8"))
        products.append(Product(title: "2976 Bex Chelsea Boots", brand: "Dr. Martens", category: CLOTHING, price: "$160.00", photo: "9"))
        products.append(Product(title: "Player Bucket Hat", brand: "Polo Ralph Lauren", category: CLOTHING, price: "$59.50", photo: "10"))
        products.append(Product(title: "Celestial Tie-Dye Placement", brand: "Urban Outfitters", category: HOME, price: "$12.00", photo: "11"))
        products.append(Product(title: "Standing Mixer", brand: "SMEG", category: HOME, price: "$529.50", photo: "12"))
        products.append(Product(title: "Matin Table Lamp", brand: "HAY", category: HOME, price: "$146.00", photo: "13"))
        products.append(Product(title: "Runa Pouf", brand: "Urban Outfitters", category: HOME, price: "$99.00", photo: "14"))
        products.append(Product(title: "Small White Ceramic Vase Set", brand: "Sullivans", category: HOME, price: "$24.99", photo: "15"))
        products.append(Product(title: "Modern Ashlar Accent Chair", brand: "Studio Designs", category: HOME, price: "$259.99", photo: "16"))
        products.append(Product(title: "3-Shelf Bookcase", brand: "Mainstay", category: HOME, price: "$99.50", photo: "17"))
        products.append(Product(title: "Office Desktop Bookshelf", brand: "Ticktecklab", category: HOME, price: "$26.59", photo: "18"))
        products.append(Product(title: "Tamarack Folding Wooden Outdoor Chair", brand: "CleverMade", category: HOME, price: "$159.99", photo: "19"))
        products.append(Product(title: "Reading Frog Family", brand: "SPI", category: HOME, price: "$187.00", photo: "20"))
        products.append(Product(title: "Win-Win Good Genes Duo Gift Set", brand: "Sunday Riley", category: BEAUTY, price: "$122.00", photo: "21"))
        products.append(Product(title: "Le Mini Macaron Gel Manicure Set", brand: "Urban Outfitters", category: BEAUTY, price: "$30.00", photo: "22"))
        products.append(Product(title: "Highlighting Duo Pencil", brand: "Anastasia Beverly Hills", category: BEAUTY, price: "$23.00", photo: "23"))
        products.append(Product(title: "Stimulating Scalp Scrub", brand: "Frank Body", category: BEAUTY, price: "$19.00", photo: "24"))
        products.append(Product(title: "Hoola Matte Bronzer", brand: "Benefit Cosmetics", category: BEAUTY, price: "$44.00", photo: "25"))
        products.append(Product(title: "Drying Lotion", brand: "Mario Badescu", category: BEAUTY, price: "$17.00", photo: "26"))
        products.append(Product(title: "Matte Softwear Brush", brand: "Lime Crime", category: BEAUTY, price: "$22.00", photo: "27"))
        products.append(Product(title: "Facial Spray With Aloe, Cucumber and Green Tea", brand: "Mario Badescu", category: BEAUTY, price: "$7.00", photo: "28"))
        products.append(Product(title: "Dew It For The Glow Gift Set", brand: "Mario Badescu", category: BEAUTY, price: "$28.00", photo: "29"))
        products.append(Product(title: "Roller Lash Curling Mascara", brand: "Benefit", category: BEAUTY, price: "$25.00", photo: "30"))
        products.append(Product(title: "Allure Voice-Activated Home Speaker with Alexa", brand: "Harman Kardon", category: ELECTRONICS, price: "$119.00", photo: "32"))
        products.append(Product(title: "Stanmore II Wireless Smart Speaker", brand: "Marshall", category: ELECTRONICS, price: "$395.99", photo: "31"))
        products.append(Product(title: "Nintendo Switch Lite", brand: "Nintendo", category: ELECTRONICS, price: "249.00", photo: "33"))
        products.append(Product(title: "Wireless Charger", brand: "Anker", category: ELECTRONICS, price: "$12.99", photo: "34"))
        products.append(Product(title: "USB-C Charge Cable (2m)", brand: "Apple", category: ELECTRONICS, price: "$19.00", photo: "39"))
        products.append(Product(title: "Laptop Stand", brand: "Soundance", category: ELECTRONICS, price: "$29.90", photo: "35"))
        products.append(Product(title: "DualShock 4 Wireless Controller for PS4", brand: "Playstation", category: ELECTRONICS, price: "$64.99", photo: "36"))
        products.append(Product(title: "USB-C to HDMI Adapter", brand: "QGeeM", category: ELECTRONICS, price: "$10.99", photo: "37"))
        products.append(Product(title: "Wireless Bluetooth Karaoke Microphone", brand: "Bonaok", category: ELECTRONICS, price: "$30.99", photo: "38"))
        products.append(Product(title: "iPhone 12 64 GB", brand: "Apple", category: ELECTRONICS, price: "$829.00", photo: "iphone12"))
        
        

        

    }


}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y != 0 {
            scrollView.contentOffset.y = 0
        }
    }
    

}

extension ViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productTableView.dequeueReusableCell(withIdentifier: "ReusableProdcutCell", for: indexPath) as! ProductCell
        let filteredProducts:[Product] = products.filter { $0.category == selectedCategoryName }
        let product = filteredProducts[indexPath.row]
        cell.productNameLabel.text = product.title
        cell.productNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .black)
        cell.productDescriptionLabel.text = product.brand
        cell.productDescriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        cell.productPriceLabel.text = product.price
        cell.productPriceLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        cell.productImageView.image = UIImage(named: product.photo)
        return cell
    }
}

/*
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoriesReuseIdentifier, for: indexPath as IndexPath) as! CategoriesCollectionViewCell
        cell.configure(with: categories[indexPath.row])
        
        return cell
    }
    
    
}*/

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
