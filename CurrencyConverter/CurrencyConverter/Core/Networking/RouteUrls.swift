//
//  RouteUrls.swift
//  CurrencyConverter
//
//  Created by Muneeb Ali on 22/11/2020.
//

import Foundation


let kBaseURL = "http://api.currencylayer.com"


enum Route: String {
    
    case CountryList = "/list"
    case LiveData = "/live"
    
    
    func url() -> String{
        return kBaseURL + self.rawValue
    }
}

