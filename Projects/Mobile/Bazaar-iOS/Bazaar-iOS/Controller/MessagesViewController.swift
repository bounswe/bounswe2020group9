//
//  MessagesViewController.swift
//  Bazaar-iOS
//
//  Created by Beste Goger on 25.01.2021.
//

import UIKit

class MessagesViewController: UIViewController {
    
    @IBOutlet weak var conversationsTableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var conversationsInstance = Conversations.shared
    var selectedId:Int!
    
    var networkFailedAlert:UIAlertController = UIAlertController(title: "Error while retrieving conversations", message: "We encountered a problem while retrieving the conversations, please check your internet connection.", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        conversationsInstance.delegate = self
        createIndicatorView()
        let okButton = UIAlertAction(title: "Retry", style: .cancel, handler: { action in
           self.conversationsInstance.fetchConversations()
        })
        networkFailedAlert.addAction(okButton)
        conversationsTableView.register(UINib(nibName: "ConversationTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableConversationTableViewCell")
        let alertController = UIAlertController(title: "Alert!", message: "Message", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {_ in
            self.stopIndicator()
            DispatchQueue.main.async {
                self.conversationsTableView.isHidden = true
            }
        }))
        self.conversationsInstance.fetchConversations()
        if !(conversationsInstance.dataFetched) {
            startIndicator()
            self.conversationsInstance.fetchConversations()
        }
        self.view.bringSubviewToFront(conversationsTableView)
        self.conversationsTableView.reloadData()
        self.conversationsTableView.backgroundColor = UIColor.systemBackground
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            dismiss(animated: true, completion: nil)
        
            if let chatVC = segue.destination as? ChatViewController {
                let index = self.conversationsTableView.indexPathForSelectedRow!.row
                chatVC.id = conversationsInstance.conversations[index].id
            }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return self.conversationsTableView.indexPathForSelectedRow != nil
    }
    
}


extension MessagesViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.conversationsInstance.conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = conversationsTableView.dequeueReusableCell(withIdentifier: "ReusableConversationTableViewCell", for: indexPath) as! ConversationTableViewCell
        let conversation:ConversationData = conversationsInstance.conversations[indexPath.row]
        cell.companyNameLabel.text = conversation.company
        cell.lastMessageLabel.text = conversation.last_message_body
        cell.timeLabel.text = conversation.last_message_timestamp.formatDate
        if !conversation.is_visited {
            cell.newMessageIndicator.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "messagesToChatSegue", sender: nil)
        self.selectedId = conversationsInstance.conversations[indexPath.row].id
    }
    
}

extension MessagesViewController: ConversationsFetchDelegate {
    func allConversationsAreFetched() {
        stopIndicator()
        self.conversationsTableView.reloadData()
    }
    
    func conversationsCannotBeFetched() {
        startIndicator()
        presentAlert()
    }
    
    func presentAlert() {
        if conversationsInstance.apiFetchError {
            self.networkFailedAlert.message = "We couldn't connect to the network, please check your internet connection."
        }
        if conversationsInstance.jsonParseError {
            self.networkFailedAlert.message = "There is an internal problem in the system."
        }
        if !self.networkFailedAlert.isBeingPresented {
            self.present(networkFailedAlert, animated:true, completion: nil)
        }
    }
}

extension MessagesViewController {
    func startIndicator() {
        self.view.bringSubviewToFront(loadingView)
        loadingView.isHidden = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        conversationsTableView.isHidden = true
    }

    func createIndicatorView() {
        loadingView.isHidden = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        conversationsTableView.isHidden = true
    }
    
    func stopIndicator() {
        DispatchQueue.main.async {
            self.loadingView.isHidden = true
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.view.sendSubviewToBack(self.loadingView)
            self.conversationsTableView.isHidden = false
            self.conversationsTableView.isUserInteractionEnabled = true
            self.conversationsTableView.reloadData()
        }
    }
}


protocol ConversationsFetchDelegate {
    func allConversationsAreFetched()
    func conversationsCannotBeFetched()
    func presentAlert()
}

class Conversations {
    static let shared = Conversations()
    var conversations: [ConversationData]
    
    var delegate: ConversationsFetchDelegate?
    let dispatchGroup = DispatchGroup()
    var dataFetched = false {
        didSet{
            if self.dataFetched{
                delegate?.allConversationsAreFetched()
            } else {
                delegate?.conversationsCannotBeFetched()
            }
        }
    }
    var apiFetchError = false
    var jsonParseError = false
    
    init(){
        self.conversations = []
    }
    
    func fetchConversations() {
        dispatchGroup.enter()
        APIManager().getConversations(completionHandler: { result in
            switch result {
            case .success(let allConvs):
                self.dataFetched = true
                self.conversations = allConvs.conversations.filter{$0.user_type == 2}
                self.delegate?.allConversationsAreFetched()
            case .failure(_):
                self.dataFetched = false
                self.conversations = []
                self.delegate?.conversationsCannotBeFetched()
            }
        })
        

        dispatchGroup.leave()
        dispatchGroup.wait()
    }
}
