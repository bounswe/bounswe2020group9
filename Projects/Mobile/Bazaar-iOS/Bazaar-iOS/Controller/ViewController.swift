//
//  ViewController.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 8.11.2020.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var productTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productTableView.dataSource = self
        productTableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ReusableProdcutCell")
    }


}

extension ViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productTableView.dequeueReusableCell(withIdentifier: "ReusableProdcutCell", for: indexPath) as! ProductCell
        cell.productNameLabel.text = "Iphone12"
        cell.productPriceLabel.text = "99.99$"
        cell.productImageView.image = UIImage(named: "iphone12")
        return cell
    }
    
    
}
