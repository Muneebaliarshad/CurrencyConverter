//
//  CountriesViewController.swift
//  CurrencyConverter
//
//  Created by Muneeb Ali on 22/11/2020.
//

import UIKit

class CountriesListViewController: BaseViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Variables
    let countryVM = CountriesListViewModel()
    
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setRatesUI()
    }
    
    
    //MARK: - Setup Methods
    fileprivate func setRatesUI() {
        title = "Country Selection"
        searchBar.shadow(color: .lightGray)
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        getCountriesList()
    }
    
    
    //MARK: - Helper Methods
    fileprivate func getCountriesList() {
        //On Loading
        countryVM.loadingStatus = { (status) in
            if status {
                self.view.startLoading()
            } else {
                self.view.stopLoading()
            }
        }
        
        //On Error
        countryVM.showAlertClosure = { (message) in
            self.showAlertWith(message: message)
        }
        
        //On API CAll End
        countryVM.didFinishFetch = {
            self.tableView.reloadData()
        }
        
        countryVM.fetchCountriesList()
    }
    
    
    //MARK: - IBActions
    @IBAction func currencySelectionButtonAction(_ sender: UIButton) {
    }
    
}


//MARK: - UITableViewDataSource Methods
extension CountriesListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if countryVM.isSearch {
            return countryVM.searchListData.count
        } else {
            return countryVM.countryListData?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "rateCell")
        
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        
        if countryVM.isSearch {
            cell.textLabel?.text = Array(countryVM.searchListData.keys)[indexPath.row]
            cell.detailTextLabel?.text = Array(countryVM.searchListData.values)[indexPath.row]
            
        } else {
            cell.textLabel?.text = Array(countryVM.countryListData!.keys)[indexPath.row]
            cell.detailTextLabel?.text = Array(countryVM.countryListData!.values)[indexPath.row]
            
        }
        
        return cell
    }
}



//MARK: - UITableViewDelegate Methods
extension CountriesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if countryVM.isSearch {
            countryVM.selectedCountryClosure?(Array(countryVM.searchListData.keys)[indexPath.row],
                                              Array(countryVM.searchListData.values)[indexPath.row])
            
        } else {
            countryVM.selectedCountryClosure?(Array(countryVM.countryListData!.keys)[indexPath.row],
                                              Array(countryVM.countryListData!.values)[indexPath.row])
        }
        
        navigationController?.popViewController(animated: true)
    }
}



//MARK: - UISearchBarDelegate Methods
extension CountriesListViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        countryVM.isSearch = false
        searchBar.endEditing(true)
        searchBar.text = ""
        countryVM.searchListData.removeAll()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        countryVM.isSearch = true
        countryVM.findSearchData(text: searchBar.text ?? "")
    }
    
}
