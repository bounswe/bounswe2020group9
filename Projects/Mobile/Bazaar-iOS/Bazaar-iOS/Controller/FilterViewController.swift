//
//  FilterViewController.swift
//  Bazaar-iOS
//
//  Created by alc on 26.12.2020.
//

import UIKit
import MARKRangeSlider
import DropDown

class FilterViewController: UIViewController {

    @IBOutlet weak var priceParentView: UIView!
    @IBOutlet weak var reviewParentView: UIView!
    @IBOutlet weak var brandParentView: UIView!
    @IBOutlet weak var sortParentView: UIView!
    @IBOutlet weak var priceTitleLabel: UILabel!
    @IBOutlet weak var reviewTitleLabel: UILabel!
    @IBOutlet weak var brandTitleLabel: UILabel!
    @IBOutlet weak var sortTitleLabel: UILabel!
    @IBOutlet weak var priceRangeSlider: MARKRangeSlider!
    @IBOutlet weak var reviewRangeSlider: UISlider!
    @IBOutlet weak var chooseBrandButton: UIButton!
    @IBOutlet weak var chooseSortTypeButton: UIButton!
    
    var brandDropdown: DropDown?
    var sortDropdown: DropDown?
    var delegate: FilterViewControllerDelegate?
    
    let sortTypeToCodeMapping = [
        "Choose an option": "none",
        "Best Sellers": "bs",
        "Most Favorites": "mf",
        "Price: High to Low": "pr_des",
        "Price: Low to High": "pr_asc"]
    
    var brandNameToCodeMapping = Dictionary<String, String>()
    
    
    /*
     function that is automatically called every time before the view will appear on screen.
     used for setting the top navigation bar visible with no "Back" text.
     */
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.backItem?.title = ""
    }
    
    /*
     function that is automatically called when the view first appears on screen.
     used for setting the initial values for the views.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let brands = ["Choose a Brand"] + Array(Set(AllProducts.shared.allProducts.map{$0.brand}))
        for brand in brands {
            if brand == "Choose a Brand" {
                brandNameToCodeMapping[brand] = "none"
            } else {
                brandNameToCodeMapping[brand] = brand.replacingOccurrences(of: " ", with: "-")
            }
        }
        brandDropdown = DropDown(anchorView: brandParentView)
        brandDropdown!.dataSource = brands
        brandDropdown!.direction = .bottom
        brandDropdown?.dismissMode = .automatic
        brandDropdown?.cancelAction = {
            let controlStates: Array<UIControl.State> = [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved]
               for controlState in controlStates {
                    self.chooseBrandButton.setTitle(brands[0], for: controlState)
               }
        }
        brandDropdown!.selectionAction = { (index, item) in
            let controlStates: Array<UIControl.State> = [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved]
               for controlState in controlStates {
                    self.chooseBrandButton.setTitle(item, for: controlState)
               }
        }
        let sortTypes = ["Choose an option", "Best Sellers", "Most Favorites", "Price: High to Low", "Price: Low to High"]
    
        sortDropdown = DropDown(anchorView: sortParentView)
        sortDropdown!.dataSource = sortTypes
        sortDropdown!.direction = .bottom
        sortDropdown?.cancelAction = {
            let controlStates: Array<UIControl.State> = [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved]
               for controlState in controlStates {
                    self.chooseSortTypeButton.setTitle(sortTypes[0], for: controlState)
               }
        }
        sortDropdown?.selectionAction = {  (index, item) in
            let controlStates: Array<UIControl.State> = [.normal, .highlighted, .disabled, .selected, .focused, .application, .reserved]
               for controlState in controlStates {
                    self.chooseSortTypeButton.setTitle(item, for: controlState)
               }
        }
        sortDropdown?.dismissMode = .automatic
        
        let prices = Set(AllProducts.shared.allProducts.map{$0.price})
        priceRangeSlider.setMinValue(CGFloat(prices.min() ?? 0.0), maxValue: CGFloat(prices.max() ?? 20000.0))
        priceRangeSlider.changeColor(color:#colorLiteral(red: 0.9664689898, green: 0.6368434429, blue: 0.1475634575, alpha: 1))
        reviewRangeSlider.minimumValue = 0.0
        reviewRangeSlider.maximumValue = 5.0
    }
    
    /*
     function that is automatically called every time before the view will disappear from the screen.
     used for setting the top navigation bar hidden.
     */
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    /*
     function that is called when "Choose an Option" button for sort is pressed. Shows the dropdown options for sort.
     */
    @IBAction func chooseSortButtonPressed(_ sender: UIButton) {
        sortDropdown!.show()
    }
    
    /*
     function that is called when "Choose a Brand" button is pressed. Shows the dropdown options for brand filtering.
     */
    @IBAction func chooseBrandButtonPressed(_ sender: UIButton) {
        brandDropdown!.show()
    }

    /*
     function thst is called when the filter button is pressed.
     returns to SearchResultsViewController and shows the updated results.
     */
    @IBAction func filterButtonPressed(_ sender: UIButton) {
        if let returnedVC = self.delegate as? SearchResultsViewController {
            returnedVC.filterType = prepareFilterType()
            returnedVC.sortType = prepareSortType()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    /*
     function that updates the threshold value when the slider for review score is changed.
     */
    @IBAction func reviewSliderValueChanged(_ sender: UISlider) {
        reviewTitleLabel.text = "Review Score: \(Double(sender.value).rounded(toPlaces: 1))+"
    }
    
    /*
     function that updates the threshold values when the slider for price is changed.
     */
    @IBAction func priceSliderValueChanged(_ sender: MARKRangeSlider) {
        priceTitleLabel.text = "Price: ₺\(Int(sender.leftValue)) - ₺\(Int(sender.rightValue))"
    }
    
    /*
     function that maps the chosen filtering options to their corresponding code names for the API calls.
     */
    func prepareFilterType() -> String {
        var filter = ""
        var priceFilter = ""
        var reviewFilter = ""
        var brandFilter = ""
        if priceRangeSlider.leftValue != priceRangeSlider.minimumValue ||
            priceRangeSlider.rightValue != priceRangeSlider.maximumValue {
            priceFilter = "prc=\(Int(priceRangeSlider.leftValue))-\(Int(priceRangeSlider.rightValue))&"
            filter.append(priceFilter)
        }
        if reviewRangeSlider.value != 0 {
            reviewFilter = "pr=\(reviewRangeSlider.value)&"
            filter.append(reviewFilter)
        }
        if chooseBrandButton.currentTitle != "Choose a Brand" {
            brandFilter = "br="+brandNameToCodeMapping[chooseBrandButton.currentTitle!]!+"&"
            filter.append(brandFilter)
        }
        if filter.last == "&" {
            filter.removeLast()
        }
        if filter.count == 0 {
            filter = "none"
        }
        return filter
    }
    
    func prepareSortType() ->String {
        var sortFilter = ""
        sortFilter = sortTypeToCodeMapping[chooseSortTypeButton.currentTitle!] ?? "none"
        return sortFilter
    }
}

extension MARKRangeSlider {
    /*
     function that changes the color of the range image of the range slider.
     */
    func changeColor(color: UIColor) {
        self.rangeImage = UIImage(systemName: "rectangle.fill")?.withTintColor(color)
    }
}
protocol FilterViewControllerDelegate
{
     func filterViewControllerResponse(filterStr: String, sortStr: String)
}
