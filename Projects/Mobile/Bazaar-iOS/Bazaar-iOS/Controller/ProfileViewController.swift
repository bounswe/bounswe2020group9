//
//  ProfileViewController.swift
//  Bazaar-iOS
//
//  Created by Beste Goger on 22.11.2020.
//

import Foundation


import UIKit

class ProfileViewController: UIViewController{
    
    @IBOutlet weak var profileMenu: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileMenu.delegate = self
        profileMenu.dataSource = self
        profileMenu.layer.cornerRadius = 10
        profileMenu.layer.borderColor = UIColor.orange.cgColor
        profileMenu.layer.borderWidth = 0.5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        if let selectionIndexPath = profileMenu.indexPathForSelectedRow {
                profileMenu.deselectRow(at: selectionIndexPath, animated: false)
            }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLayoutSubviews()
        let topInset = max((profileMenu.frame.height - profileMenu.contentSize.height) / 2.0, 0.0)
        profileMenu.contentInset = UIEdgeInsets(top: topInset, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "Menu Cell \(indexPath.row)", for: indexPath)
        let selectedView = UIView()
        selectedView.backgroundColor = #colorLiteral(red: 0.9402856827, green: 0.6186184287, blue: 0.1447118819, alpha: 0.4013809419)
        selectedView.layer.cornerRadius = 10
        cell.selectedBackgroundView = selectedView
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return profileMenu.frame.height / 7
    }
    
}



