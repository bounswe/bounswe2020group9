//
//  SearchViewController.swift
//  Bazaar-iOS
//
//  Created by alc on 12.11.2020.
//

import UIKit

class CategoriesViewController:UIViewController  {
    
    @IBOutlet weak var Product_TableView: UITableView!
    @IBOutlet weak var loading_View: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var SearchHistory_TableView: UITableView!
    @IBOutlet weak var Category_CollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()    }
}
