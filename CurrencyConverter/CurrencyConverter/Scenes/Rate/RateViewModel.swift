//
//  RateViewModel.swift
//  CurrencyConverter
//
//  Created by Muneeb Ali on 21/11/2020.
//

import Foundation


class RateViewModel: BaseViewModel {
   
    //MARK: - Validation
    var rateListData: [String : Float]?
    var currency: String?
    var amount: String?
    
    
    //MARK: - UI Logic Methods
    func converRateList() {
        isLoading = true
        let usdAmount = (Float(amount ?? "0.0") ?? 0.0) / (rateListData?["USD\(currency ?? "")"] ?? 0.0)
        rateListData?.removeAll()
        
        if let data = UserDefaultsManager.getRateList() {
            for (key, value) in data {
                rateListData?[key] =  usdAmount * value
            }
        }
        
        isLoading = false
        didFinishFetch?()
        
        
    }
    
}


//MARK: - API Methods
extension RateViewModel {
    func fetchRateList() {
        isLoading = true
        
        RateListAPIs.getRateList { [weak self] (responceData, message) in
            
            self?.isLoading = false
            if responceData?.success ?? false {
                self?.rateListData = responceData?.quotes
                UserDefaultsManager.setRateList(list: self?.rateListData ?? [:])
                self?.didFinishFetch?()
                
            } else {
                self?.error = responceData?.error?.info
                return
            }
        }
    }
}
