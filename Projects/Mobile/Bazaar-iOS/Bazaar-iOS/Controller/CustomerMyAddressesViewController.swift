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
    var processType:UpdateOrAddAddress = .Add
    var addressCell:AddressCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myAddressesTableView.layer.borderColor = #colorLiteral(red: 1, green: 0.6235294118, blue: 0, alpha: 1)
        self.myAddressesTableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        self.myAddressesTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        processType = .Add
        APIManager().getCustomerAddresses { (result) in
            switch result{
            case .success(let myAddresses):
                self.myAddressesArray = myAddresses
                self.myAddressesTableView.reloadData()
            case .failure(_):
                let alertController = UIAlertController(title: "Alert!", message: "There was an error loading your addresses, please try again later.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                 self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func addAddressButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToAddAddress", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAddAddress"  {
            if processType == .Update{
            if let destinationVC = segue.destination as? AddNewAddressViewController {
                destinationVC.processType = .Update
                destinationVC.addressCell = self.addressCell
            }
            }else {
                if let destinationVC = segue.destination as? AddNewAddressViewController {
                    destinationVC.processType = .Add
                    destinationVC.addressCell = nil
                }
            }
        }
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
        cell = cell.setAddress(addressId: addressData.id, addressName: addressData.address_name, openAddress: addressData.address, country: addressData.country, city: addressData.city, postalCode: addressData.postal_code, latitude: addressData.latitude, longitude: addressData.longitude, user: 58)
        cell.delegate = self
        return cell
    }
}

//MARK: - AddressCellDelegate
extension CustomerMyAddressesViewController: AddressCellDelegate {
    func addressCellDidUpdateButtonPressed(cell: AddressCell) {
        self.processType = .Update
        self.addressCell = cell
        performSegue(withIdentifier: "goToAddAddress", sender: nil)
    }
    
    func addressCellDidDeleteButtonPressed(cell: AddressCell) {
        if let index = self.myAddressesArray.firstIndex(where: {$0.id == cell.addressId}){
            DispatchQueue.main.async {
                if let id = cell.addressId {
                    APIManager().removeCustomerAddress(addressId: id) { (result) in
                    }
                }
                self.myAddressesArray.remove(at: index)
                self.myAddressesTableView.reloadData()
            }
        }
    }
}
