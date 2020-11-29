//
//  RatesViewController.swift
//  CurrencyConverter
//
//  Created by Muneeb Ali on 21/11/2020.
//

import UIKit

class RatesViewController: BaseViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var selectedCountryView: UIView!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var amountTextField: MATextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - Variables
    let rateVM = RateViewModel()
    
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setRatesUI()
    }
    
    
    //MARK: - Setup Methods
    fileprivate func setRatesUI() {
        title = "Currency Rates"
        selectedCountryView.shadow(color: .lightGray)
        tableView.dataSource = self
        tableView.delegate = self
        getRateListData(true)
    }
    
    
    //MARK: - Helper Methods
    fileprivate func getRateListData(_ isFetchfromAPI: Bool) {
        //On Loading
        rateVM.loadingStatus = { (status) in
            if status {
                self.view.startLoading()
            } else {
                self.view.stopLoading()
            }
        }
        
        //On Error
        rateVM.showAlertClosure = { (message) in
            self.showAlertWith(message: message)
        }
        
        //On API CAll End
        rateVM.didFinishFetch = {
            self.tableView.scrollToTop()
            self.tableView.reloadData()
        }
        
        
        if isFetchfromAPI {
            rateVM.fetchRateList()
        } else {
            rateVM.currency = currencyLabel.text
            rateVM.amount = amountTextField.text
            rateVM.converRateList()
        }
    }
    
    
    //MARK: - IBActions
    @IBAction func currencySelectionButtonAction(_ sender: UIButton) {
        let countryListVC = UIStoryboard.storyBoard(withName: .Main).loadViewController(withIdentifier: .CountriesListViewController) as! CountriesListViewController
        navigationController?.pushViewController(countryListVC, animated: true)
        
        
        countryListVC.countryVM.selectedCountryClosure = { (currency, country) in
            self.currencyLabel.text = currency
            self.countryLabel.text = country
        }
    }
    
    @IBAction func submitButtonAction(_ sender: UIButton) {
        getRateListData(false)
    }
}


//MARK: - UITableViewDataSource Methods
extension RatesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rateVM.rateListData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "rateCell")
        
        cell.selectionStyle = .none
        cell.shadow(color: .lightGray)
        
        let dataKey = Array(rateVM.rateListData!.keys)[indexPath.row]
        cell.textLabel?.text = dataKey.replacingOccurrences(of: "USD", with: "")
        cell.detailTextLabel?.text = rateVM.rateListData?[dataKey]?.description
        
        return cell
    }
}



//MARK: - UITableViewDelegate Methods
extension RatesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
