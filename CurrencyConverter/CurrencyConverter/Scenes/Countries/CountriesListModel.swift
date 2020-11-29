//
//  CountriesListModel.swift
//  CurrencyConverter
//
//  Created by Muneeb Ali on 22/11/2020.
//

import Foundation
import Alamofire


//MARK: - Model
struct CountriesListModel: Codable {
    var success: Bool?
    var terms:String?
    var privacy: String?
    var currencies: [String: String]?
    var error: ResponceError?
}


struct ResponceError: Codable {
    var code: Int?
    var type: String?
    var info: String?
}



struct CountriesListAPIs {
    
    static func getCountriesList(completionHandler: @escaping (_ result: CountriesListModel?, _ message: String?) -> Void) {
        //MARK: - Check internet connectivity
        if !(Utility.isConnectedToInternet()){
            completionHandler(nil, ApiErrorMessage.NoNetwork)
            return
        }
        //MARK: - success closure for handling success response
        let successClosure: DefaultDataAPISuccessClosure = {
            (result) in
            do{
                let jsonDecoder = JSONDecoder()
                let dataSource = try jsonDecoder.decode(CountriesListModel.self, from: result)
                completionHandler(dataSource, nil)
            }
            catch{
                completionHandler(nil, ApiErrorMessage.ErrorOccured)
                print("🤦🏻‍♂️🤦🏻‍♂️🤦🏻‍♂️🤦🏻‍♂️ Json Mapping Error : 🤦🏻‍♂️🤦🏻‍♂️🤦🏻‍♂️🤦🏻‍♂️ " + error.localizedDescription)
            }
        }
        
        //MARK: - Failure closure for handling failure response
        let failureClosure:DefaultAPIFailureClosure = {error in
            completionHandler(nil,error.localizedDescription)
        }
        
        
        APIManager.sharedInstance.authenticationManagerAPI.serverRequest(type: .get, route: Route.CountryList.rawValue, success: successClosure, failure: failureClosure)
    }
}
