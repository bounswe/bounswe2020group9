//
//  FavoritesViewController.swift
//  Bazaar-iOS
//
//  Created by alc on 12.11.2020.
//

import UIKit

class WishlistViewController: UIViewController {

    @IBOutlet var listsTableView: UITableView!
    @IBOutlet var addListButton: UIButton!
    
    var customerListsInstance = CustomerLists.shared
    
    var networkFailedAlert:UIAlertController = UIAlertController(title: "Error while retrieving lists", message: "We encountered a problem while retrieving the lists, please check your internet connection.", preferredStyle: .alert)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listsTableView.reloadData()
        /*
        if let isLoggedIn =  UserDefaults.standard.value(forKey: K.isLoggedinKey) as? Bool {
            if !isLoggedIn {
                self.disableTabbarItems([1])
            }else {
                self.enableTabbarItems([1])
            }
        }else {
            self.enableTabbarItems([1])
        }
        */
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listsTableView.dataSource = self
        listsTableView.delegate = self
        customerListsInstance.delegate = self
        listsTableView.register(UINib(nibName: "ListCell", bundle: nil), forCellReuseIdentifier: "ReusableListCell")
        self.customerListsInstance.fetchCustomerLists()
        if !(customerListsInstance.dataFetched) {
            self.customerListsInstance.fetchCustomerLists()
        }
        self.view.bringSubviewToFront(listsTableView)
    }
    
    
    
}

extension WishlistViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y != 0 {
            scrollView.contentOffset.y = 0
        }
    }
}

extension WishlistViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CustomerLists.shared.customerLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let list = CustomerLists.shared.customerLists[indexPath.row]
        let cell = listsTableView.dequeueReusableCell(withIdentifier: "ReusableListCell", for: indexPath) as! ListCell
        
        cell.listNameLabel.text = list.name
        
        for i in list.products {
            let theImageView = UIImageView()
            theImageView.translatesAutoresizingMaskIntoConstraints = false
            if let img = UIImage(named: i.picture ?? "") {
                theImageView.image = img
            }
            theImageView.frame = CGRect(x: 0, y: 0, width: cell.productImagesStack.frame.height, height: cell.productImagesStack.frame.height)
            theImageView.translatesAutoresizingMaskIntoConstraints = false
            let marginguide = cell.contentView.layoutMarginsGuide
            theImageView.heightAnchor.constraint(equalToConstant: marginguide.layoutFrame.height).isActive = true
            theImageView.widthAnchor.constraint(equalToConstant: marginguide.layoutFrame.height).isActive = true
            theImageView.contentMode = .scaleAspectFit
            theImageView.layer.cornerRadius = 20 //half of your width or height
            
            cell.productImagesStack.addArrangedSubview(theImageView)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 3.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //performSegue(withIdentifier: "listsToListDetailSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let list = CustomerLists.shared.customerLists[indexPath.row]
        let alertController = UIAlertController(title: "Alert!", message: "Message", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
                print("index path of delete: \(indexPath)")
            completionHandler(true)
            APIManager().deleteList(customer: UserDefaults.standard.value(forKey: K.user_id) as! String, id: String(list.id)) { (result) in
                switch result {
                case .success(_):
                    alertController.message = "\(list.name) is successfully deleted"
                    self.present(alertController, animated: true, completion: nil)
                    self.listsTableView.reloadData()
                case .failure(_):
                    alertController.message = "\(list.name) cannot be deleted"
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
            
        delete.backgroundColor = #colorLiteral(red: 1, green: 0.6431372549, blue: 0.3568627451, alpha: 1)
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }
}

extension WishlistViewController: CustomerListsFetchDelegate {
    func allListsAreFetched() {
        self.listsTableView.reloadData()
    }
    
    func listsCannotBeFetched() {
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
        APIManager().getCustomerLists(customer: UserDefaults.standard.value(forKey: K.user_id) as! String, isCustomerLoggedIn: true, completionHandler: { result in
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
        dispatchGroup.leave()
        dispatchGroup.wait()
    }
}
