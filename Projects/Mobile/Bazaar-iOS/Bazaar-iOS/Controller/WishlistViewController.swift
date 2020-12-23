//
//  FavoritesViewController.swift
//  Bazaar-iOS
//
//  Created by alc on 12.11.2020.
//

import UIKit

class WishlistViewController: UIViewController {

    @IBOutlet var listsTableView: UITableView!
    @IBOutlet var loadingView: UIView!
    @IBOutlet var addListButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var addedList: CustomerListData?
    
    var editRowIndex: Int!
    
    var customerListsInstance = CustomerLists.shared
    
    var networkFailedAlert:UIAlertController = UIAlertController(title: "Error while retrieving lists", message: "We encountered a problem while retrieving the lists, please check your internet connection.", preferredStyle: .alert)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let isLoggedIn = UserDefaults.standard.value(forKey: K.isLoggedinKey) as? Bool{
            if isLoggedIn {
                listsTableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let isLoggedIn = UserDefaults.standard.value(forKey: K.isLoggedinKey) as? Bool{
            if isLoggedIn {
                self.customerListsInstance.fetchCustomerLists()
                listsTableView.reloadData()
            }else {
                let alertController = UIAlertController(title: "Alert!", message: "Message", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                alertController.message = "Please log in to see your lists!"
                self.present(alertController, animated: true, completion: nil)
                self.listsTableView.isHidden = true
            }
        }else {
            let alertController = UIAlertController(title: "Alert!", message: "Message", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            alertController.message = "Please log in to see your lists!"
            self.present(alertController, animated: true, completion: nil)
            self.listsTableView.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listsTableView.dataSource = self
        listsTableView.delegate = self
        customerListsInstance.delegate = self
        createIndicatorView()
        let okButton = UIAlertAction(title: "Retry", style: .cancel, handler: { action in
           self.customerListsInstance.fetchCustomerLists()
        })
        networkFailedAlert.addAction(okButton)
        listsTableView.register(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "ReusableListCell")
        let alertController = UIAlertController(title: "Alert!", message: "Message", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        if let isLoggedIn = UserDefaults.standard.value(forKey: K.isLoggedinKey) as? Bool{
            if !isLoggedIn {
                alertController.message = "Please log in to see your lists!"
                self.present(alertController, animated: true, completion: nil)
                self.listsTableView.isHidden = true
                return
            }else {
                self.customerListsInstance.fetchCustomerLists()
                if !(customerListsInstance.dataFetched) {
                    startIndicator()
                    self.customerListsInstance.fetchCustomerLists()
                }
                self.view.bringSubviewToFront(listsTableView)
                self.listsTableView.reloadData()
            }
        }else {
            alertController.message = "Please log in to see your lists!"
            self.present(alertController, animated: true, completion: nil)
            self.listsTableView.isHidden = true
            return
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            dismiss(animated: true, completion: nil)
    
        if segue.identifier == "listsToListDetailSegue" {
            if let listDetailVC = segue.destination as? ListDetailViewController {
                if self.addedList != nil {
                    listDetailVC.list = self.addedList
                    self.addedList = nil
                } else {
                    let indexPath = self.listsTableView.indexPathForSelectedRow
                    if indexPath != nil {
                        listDetailVC.list = customerListsInstance.customerLists[indexPath!.row]
                    }
                }
            }
        } else if segue.identifier == "toAddListSegue" {
            if let popoverVC = segue.destination as? AddListViewController {
                popoverVC.delegate = self
                if self.editRowIndex != nil {
                    popoverVC.listToEdit = customerListsInstance.customerLists[self.editRowIndex]
                    self.editRowIndex = nil
                }
            }
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "listsToListDetailSegue" {
            return self.listsTableView.indexPathForSelectedRow != nil || self.addedList != nil
        }
        return false
    }
    
    @IBAction func didAddListButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "toAddListSegue", sender: sender)
    }
    
}


extension WishlistViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.customerListsInstance.customerLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = listsTableView.dequeueReusableCell(withIdentifier: "ReusableListCell", for: indexPath) as! ListCell
        let list:CustomerListData = customerListsInstance.customerLists[indexPath.row]
        var pictures: [Int:[String]] = [:]
        pictures[list.id] = []
        for i in 0...9 {
            if (list.products.count - 1) < i {
                break
            }
            if let pic = list.products[i].picture {
                    pictures[list.id]?.append(pic)
            }
        }
        DispatchQueue.main.async {
            if list.products.count == pictures[list.id]?.count {
                cell.configCell(pictureUrls: pictures, listName: list.name, listID: list.id)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 3.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "listsToListDetailSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let list = CustomerLists.shared.customerLists[indexPath.row]
        let alertController = UIAlertController(title: "Alert!", message: "Message", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
                print("index path of delete: \(indexPath)")
            completionHandler(true)
            DispatchQueue.main.async {
                if let userId =  UserDefaults.standard.value(forKey: K.userIdKey) as? Int{
                    APIManager().deleteList(userId:userId, id: String(list.id)) { (result) in
                        switch result {
                        case .success(_):
                            alertController.message = "\(list.name) is successfully deleted"
                            self.present(alertController, animated: true, completion: nil)
                            self.customerListsInstance.customerLists.remove(at: indexPath.row)
                            self.listsTableView.reloadData()
                        case .failure(_):
                            alertController.message = "\(list.name) cannot be deleted"
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        delete.backgroundColor = #colorLiteral(red: 1, green: 0.6431372549, blue: 0.3568627451, alpha: 1)
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }
    

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //let product = self.list.products[indexPath.row]
        let alertController = UIAlertController(title: "Alert!", message: "Message", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        let edit = UIContextualAction(style: .destructive, title: "Edit") { (action, sourceView, completionHandler) in
                print("index path of edit: \(indexPath)")
            self.editRowIndex = indexPath.row
            self.performSegue(withIdentifier: "toAddListSegue", sender: nil)
        }
        edit.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [edit])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }
    
}

extension WishlistViewController: CustomerListsFetchDelegate {
    func allListsAreFetched() {
        stopIndicator()
        self.listsTableView.reloadData()
    }
    
    func listsCannotBeFetched() {
        startIndicator()
        presentAlert()
    }
    
    func presentAlert() {
        if customerListsInstance.apiFetchError {
            self.networkFailedAlert.message = "We couldn't connect to the network, please check your internet connection."
        }
        if customerListsInstance.jsonParseError {
            self.networkFailedAlert.message = "There is an internal problem in the system."
        }
        if !self.networkFailedAlert.isBeingPresented {
            self.present(networkFailedAlert, animated:true, completion: nil)
        }
    }
}

extension WishlistViewController {
    func startIndicator() {
        self.view.bringSubviewToFront(loadingView)
        loadingView.isHidden = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        listsTableView.isHidden = true
    }

    func createIndicatorView() {
        loadingView.isHidden = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        listsTableView.isHidden = true
    }
    
    func stopIndicator() {
        DispatchQueue.main.async {
            self.loadingView.isHidden = true
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.view.sendSubviewToBack(self.loadingView)
            self.listsTableView.isHidden = false
            self.listsTableView.isUserInteractionEnabled = true
            self.listsTableView.reloadData()
        }
    }
}


protocol CustomerListsFetchDelegate {
    func allListsAreFetched()
    func listsCannotBeFetched()
    func presentAlert()
}

class CustomerLists {
    static let shared = CustomerLists()
    var customerLists: [CustomerListData]
    private let saveKey = "CustomerLists"
    
    var delegate: CustomerListsFetchDelegate?
    let dispatchGroup = DispatchGroup()
    var dataFetched = false {
        didSet{
            if self.dataFetched{
                delegate?.allListsAreFetched()
            } else {
                delegate?.listsCannotBeFetched()
            }
        }
    }
    var apiFetchError = false
    var jsonParseError = false
    
    init(){
        self.customerLists = []
    }
    
    func fetchCustomerLists() {
        dispatchGroup.enter()
        if let userId = UserDefaults.standard.value(forKey: K.userIdKey) as? Int {
            APIManager().getCustomerLists(userId: userId, isCustomerLoggedIn: true, completionHandler: { result in
                switch result {
                    case .success(let lists):
                        self.dataFetched = true
                        self.customerLists = lists
                        self.delegate?.allListsAreFetched()
                    case .failure(_):
                        self.dataFetched = false
                        self.customerLists = []
                        self.delegate?.listsCannotBeFetched()
                }
            })
            
        }

        dispatchGroup.leave()
        dispatchGroup.wait()
    }
}
