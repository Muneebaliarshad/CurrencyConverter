//
//  AuthenticationAPIManager.swift
//  CurrencyConverter
//
//  Created by Muneeb Ali on 22/11/2020.
//

import Foundation
import UIKit
import Alamofire


class AuthenticationAPIManager: APIManagerBase {
    
    fileprivate func getRouteAs(method: HTTPMethod, route: String, parameters: Parameters) -> URL {
        switch method {
        case .get:
            return GETURLfor(route: route, parameters: parameters)!
            
        case .post:
            return POSTURLforRoute(route: route)!
            
        default:
            return URL(string: "")!
        }
    }
    
    
    func serverRequest(type: HTTPMethod,
                       route: String,
                       success:@escaping DefaultDataAPISuccessClosure,
                       failure:@escaping DefaultAPIFailureClosure){
        
        
        let params = ["access_key": CurrencyLayerApiKey]
        
        serverRequestWith(route: getRouteAs(method: type, route: route, parameters: params),
                          parameters: params, requestType: type, success: success, failure: failure)
        
    }
    
}
