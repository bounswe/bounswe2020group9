//
//  ChatTableViewCell.swift
//  Bazaar-iOS
//
//  Created by Beste Goger on 25.01.2021.
//

import UIKit

struct ChatMessage {
    var text: String
    let isIncoming: Bool
    let date: String
}


class ChatTableViewCell: UITableViewCell {

    let messageLabel = UILabel()
    let dateLabel = UILabel()
    let bubbleBackgroundView = UIView()
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    
    var chatMessage: ChatMessage! {
        didSet {
            bubbleBackgroundView.backgroundColor = chatMessage.isIncoming ? .darkGray : #colorLiteral(red: 1, green: 0.5462184466, blue: 0.1434018944, alpha: 1)
            messageLabel.textColor = .white
            dateLabel.textColor = chatMessage.isIncoming ? .lightGray : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
            
            messageLabel.text = chatMessage.text
            dateLabel.text = chatMessage.date
            
            if chatMessage.isIncoming {
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
            } else {
                leadingConstraint.isActive = false
                trailingConstraint.isActive = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = .clear
        bubbleBackgroundView.backgroundColor = .yellow
        bubbleBackgroundView.layer.cornerRadius = 12
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 0
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.numberOfLines = 0
        
        addSubview(bubbleBackgroundView)
        addSubview(messageLabel)
        addSubview(dateLabel)
        
        // lets set up some constraints for our label
        let constraints = [
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            dateLabel.bottomAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -10),
            dateLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            messageLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            bubbleBackgroundView.topAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -16),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -16),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 16),
            ]
        NSLayoutConstraint.activate(constraints)
        
        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        leadingConstraint = dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        leadingConstraint.isActive = false
        
        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        trailingConstraint = dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        trailingConstraint.isActive = true
    }

    
    
    
}


