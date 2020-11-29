//
//  CountriesListViewModel.swift
//  CurrencyConverter
//
//  Created by Muneeb Ali on 22/11/2020.
//

import Foundation

typealias SelectedCountryClosure = (_ courencyName: String, _ countryName: String) -> Void


class CountriesListViewModel: BaseViewModel {
   
    //MARK: - Validation
    var countryListData: [String : String]?
    var searchListData = [String : String]()
    var isSearch = false
    var selectedCountryClosure : SelectedCountryClosure?
    
    
    //MARK: - UI Logic Methods
    func findSearchData(text: String) {
        
        if let listData = countryListData {
            for (key, value) in listData {
                if key.capitalized.contains(text.capitalized) {
                    searchListData[key] = value
                    
                } else if value.lowercased().contains(text.lowercased()) {
                    searchListData[key] = value
                }
            }
        }
        self.didFinishFetch?()
    }
    
}


//MARK: - API Methods
extension CountriesListViewModel {
    func fetchCountriesList() {
        isLoading = true
        
        CountriesListAPIs.getCountriesList { [weak self] (responceData, message) in
            
            self?.isLoading = false
            if responceData?.success ?? false {
                self?.countryListData = responceData?.currencies
                self?.didFinishFetch?()
                
            } else {
                self?.error = responceData?.error?.info
                return
            }
        }
    }
}
