//
//  SendMessageViewController.swift
//  Bazaar-iOS
//
//  Created by Beste Goger on 25.01.2021.
//

import UIKit

class SendMessageViewController: UIViewController {
    
    var company:String!

    @IBOutlet weak var messageLabel: UITextField!
    @IBOutlet weak var frameView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.bringSubviewToFront(frameView)

        // Do any additional setup after loading the view.
    }
    

    @IBAction func sendMessage(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: "Message", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        
        let body = messageLabel.text ?? nil
        if (body != nil && body!.count > 0) {
            APIManager().sendMessage(receiver: self.company, body: body!) { (result) in
                switch result{
                case .success(_):
                    self.messageLabel.text = nil
                    let alertController = UIAlertController(title: "Alert!", message: "Your message is successfully sent. Go to \"My Messages\" to see the conversation", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.destructive, handler: {
                            action in
                            self.dismiss(animated: false, completion: nil)
                        }))
                    self.present(alertController, animated: true, completion: nil)
                case .failure(_):
                    let alertController = UIAlertController(title: "Alert!", message: "There was an error sending your message, please try again later.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                     self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
    }

    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
