//
//  RateListModel.swift
//  CurrencyConverter
//
//  Created by Muneeb Ali on 24/11/2020.
//

import Foundation
import Alamofire


//MARK: - Model
struct RateListModel: Codable {
    var success: Bool?
    var terms: String?
    var privacy: String?
    var timestamp: Int?
    var source: String?
    var quotes: [String: Float]?
    var error: ResponceError?
}



struct RateListAPIs {
    
    static func getRateList(completionHandler: @escaping (_ result: RateListModel?, _ message: String?) -> Void) {
        //MARK: - Check internet connectivity
        if !(Utility.isConnectedToInternet()){
            completionHandler(nil, ApiErrorMessage.NoNetwork)
            return
        }
        //MARK: - success closure for handling success response
        let successClosure: DefaultDataAPISuccessClosure = { (result) in
            do{
                let jsonDecoder = JSONDecoder()
                let dataSource = try jsonDecoder.decode(RateListModel.self, from: result)
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
        
        
        APIManager.sharedInstance.authenticationManagerAPI.serverRequest(type: .get, route: Route.LiveData.rawValue, success: successClosure, failure: failureClosure)
    }
}
