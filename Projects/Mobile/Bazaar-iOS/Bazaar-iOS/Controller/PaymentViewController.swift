//
//  PaymentViewController.swift
//  Bazaar-iOS
//
//  Created by Beste Goger on 22.01.2021.
//

import UIKit
import DropDown

class PaymentViewController: UIViewController {

    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var addressInfoView: UIView!
    @IBOutlet weak var chooseAddressButton: UIButton!
    @IBOutlet weak var goAddressesButton: UIButton!
    @IBOutlet weak var cardInfoView: UIView!
    @IBOutlet weak var chooseCardButton: UIButton!
    @IBOutlet weak var goCardsButton: UIButton!
    @IBOutlet weak var termsView: UIView!
    @IBOutlet weak var contractTextView: UITextView!
    @IBOutlet weak var acceptTermsButton: RadioButton!
    
    var addressDropdown: DropDown?
    var cardsDropdown: DropDown?
    
    var totalPriceText: String!
    var deliveries:[Int:Int]!
    
    var termsAccepted: Bool?
    var creditCardsArray:[CreditCardData] = []
    var cards:[String] = []
    var addressesArray:[AddressData] = []
    var addresses:[String] = []
    var selectedAddressIndex:Int?
    
    var orders:[OrderData]!
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.backItem?.title = ""
        
        APIManager().getCreditCards { (result) in
            switch result{
            case .success(let creditCards):
                self.creditCardsArray = creditCards
                self.cards = ["Choose from Cards"] + (self.creditCardsArray.map { $0.card_name })
                self.cardsDropdown!.dataSource = self.cards
            case .failure(_):
                let alertController = UIAlertController(title: "Alert!", message: "There was an error loading your credit cards, please try again later.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                 self.present(alertController, animated: true, completion: nil)
            }
        }
        
        APIManager().getCustomerAddresses { (result) in
            switch result{
            case .success(let myAddresses):
                self.addressesArray = myAddresses
                self.addresses = ["Choose from Addresses"] + (self.addressesArray.map { $0.address_name })
                self.addressDropdown!.dataSource = self.addresses
            case .failure(_):
                let alertController = UIAlertController(title: "Alert!", message: "There was an error loading your addresses, please try again later.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                 self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let contractUrl = Bundle.main.url(forResource: "DistanceSellingAgreement", withExtension: "txt") {
            if let contract = try? String(contentsOf: contractUrl) {
                contractTextView.text = contract
            }
        }
        self.contractTextView.superview?.layer.borderColor = UIColor.black.cgColor
        
        totalPriceLabel.text = totalPriceText
        
        addressInfoView.layer.borderColor = #colorLiteral(red: 1, green: 0.6431372549, blue: 0.3568627451, alpha: 1)
        addressInfoView.layer.shadowColor = UIColor.black.cgColor
        cardInfoView.layer.borderColor = #colorLiteral(red: 1, green: 0.6431372549, blue: 0.3568627451, alpha: 1)
        cardInfoView.layer.shadowColor = UIColor.black.cgColor
        termsView.layer.borderColor = #colorLiteral(red: 1, green: 0.6431372549, blue: 0.3568627451, alpha: 1)
        termsView.layer.shadowColor = UIColor.black.cgColor
        
        
        addressDropdown = DropDown(anchorView: addressInfoView)
        addressDropdown!.dataSource = addresses
        addressDropdown!.direction = .bottom
        addressDropdown?.dismissMode = .automatic
        addressDropdown?.cancelAction = {
            let controlStates: Array<UIControl.State> = [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved]
               for controlState in controlStates {
                self.chooseAddressButton.setTitle(self.addresses[0], for: controlState)
               }
        }
        addressDropdown!.selectionAction = { (index, item) in
            let controlStates: Array<UIControl.State> = [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved]
               for controlState in controlStates {
                    self.chooseAddressButton.setTitle(item, for: controlState)
               }
        }
       
        cardsDropdown = DropDown(anchorView: cardInfoView)
        cardsDropdown!.direction = .bottom
        cardsDropdown?.cancelAction = {
            let controlStates: Array<UIControl.State> = [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved]
               for controlState in controlStates {
                self.chooseCardButton.setTitle(self.cards[0], for: controlState)
               }
        }
        cardsDropdown?.selectionAction = {  (index, item) in
            let controlStates: Array<UIControl.State> = [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved]
               for controlState in controlStates {
                    self.chooseCardButton.setTitle(item, for: controlState)
               }
            self.selectedAddressIndex = index
        }
        cardsDropdown?.dismissMode = .automatic
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func didAcceptPressed(_ sender: RadioButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.termsAccepted = true
        } else{
            self.termsAccepted = false
        }
    }
    
    @IBAction func didChooseAddressButtonPressed(_ sender: Any) {
        addressDropdown!.show()
    }
    
    @IBAction func didChooseCardButtonPressed(_ sender: Any) {
        cardsDropdown!.show()
    }
    
    @IBAction func didBuyButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: "Message", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        
        if let accepted = self.termsAccepted {
            if !accepted {
                alertController.message = "You need to accept \"Distance Selling Agreement\""
                self.present(alertController, animated: true, completion: nil)
            } else if chooseAddressButton.currentTitle == "Choose from Addresses" {
                alertController.message = "Please choose one of your saved addresses or add a new one."
                self.present(alertController, animated: true, completion: nil)
            } else if chooseCardButton.currentTitle == "Choose from Cards" {
                alertController.message = "Please choose one of your saved credit cards or add a new one."
                self.present(alertController, animated: true, completion: nil)
            } else{
                if let userId =  UserDefaults.standard.value(forKey: K.userIdKey) as? Int{
                    APIManager().placeOrder(userId: userId, products: deliveries, add_id: self.addressesArray[self.selectedAddressIndex!-1].id) { (result) in
                        switch result{
                        case .success(_):
                            let alertController = UIAlertController(title: "Alert!", message: "Your order is successfully placed.", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {
                                action in
                                self.navigationController?.popViewController(animated: true)
                            }))
                            self.present(alertController, animated: true, completion: nil)
                        case .failure(_):
                            let alertController = UIAlertController(title: "Alert!", message: "Order could not be placed successfully. Please be sure that you have entered valid information.", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                }
            }
            
        } else {
            alertController.message = "You need to accept \"Distance Selling Agreement\""
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let orderVC = segue.destination as? OrderDetailViewController {
            //orderVC.order_id = deliveries[0].
            //orderVC.orders = orders
        }
    }
    
}
