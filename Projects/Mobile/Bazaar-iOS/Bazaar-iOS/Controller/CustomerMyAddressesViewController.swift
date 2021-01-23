//
//  CustomerMyAddressesViewController.swift
//  Bazaar-iOS
//
//  Created by Muhsin Etki on 23.01.2021.
//

import UIKit

class CustomerMyAddressesViewController: UIViewController {
    
    @IBOutlet weak var myAddressesTableView: UITableView!
    var myAddressesArray:[AddressData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myAddressesTableView.layer.borderColor = #colorLiteral(red: 1, green: 0.6235294118, blue: 0, alpha: 1)
        self.myAddressesTableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        self.myAddressesTableView.dataSource = self
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
//MARK: - Extension: UITableViewDataSource

extension CustomerMyAddressesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myAddressesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressCell
        let addressData = self.myAddressesArray[indexPath.row]

        return cell
    }
}
