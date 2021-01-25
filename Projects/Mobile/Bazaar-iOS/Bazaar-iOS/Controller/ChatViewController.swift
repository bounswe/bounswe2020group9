//
//  ChatViewController.swift
//  Bazaar-iOS
//
//  Created by Beste Goger on 25.01.2021.
//

import UIKit


class ChatViewController: UIViewController {
    
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var chatTableView: UITableView!
    
    var id:Int!
    var chatMessages:[ChatMessage] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APIManager().getMessages(id: self.id) { (result) in
            switch result{
            case .success(let messages):
                for msg in messages {
                    let date = msg.timestamp.formatDate
                    let isIncoming = !(msg.is_user1 == msg.am_I_user1)
                    if !self.chatMessages.isEmpty {
                        let i = self.chatMessages.endIndex
                        if((self.chatMessages[i-1].date == date) && (self.chatMessages[i-1].isIncoming == isIncoming)) {
                            self.chatMessages[i-1].text.append("\n" + msg.body)
                        } else {
                            self.chatMessages.append(ChatMessage(text:msg.body, isIncoming: isIncoming, date: date))
                        }
                    } else {
                        self.chatMessages.append(ChatMessage(text:msg.body, isIncoming: isIncoming, date: date))
                    }
                    
                }
                self.chatTableView.reloadData()
            case .failure(_):
                let alertController = UIAlertController(title: "Alert!", message: "There was an error loading your messages, please try again later.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                 self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableChatTableViewCell")
        self.chatTableView.reloadData()
        chatTableView.separatorStyle = .none
        self.chatTableView.backgroundColor = UIColor.systemBackground
    }

}


extension ChatViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTableView.dequeueReusableCell(withIdentifier: "ReusableChatTableViewCell", for: indexPath) as! ChatTableViewCell
        let chatMessage = chatMessages[indexPath.row]
        cell.chatMessage = chatMessage
        return cell
    }
    

}

