//
//  APIManager.swift
//  CurrencyConverter
//
//  Created by Muneeb Ali on 22/11/2020.
//

import UIKit

typealias DefaultAPIFailureClosure = (NSError) -> Void
typealias DefaultAPISuccessClosure = (Dictionary<String,AnyObject>) -> Void
typealias DefaultDataAPISuccessClosure = (Data) -> Void
typealias DefaultBoolResultAPISuccesClosure = (Bool) -> Void
typealias DefaultArrayResultAPISuccessClosure = (Dictionary<String,AnyObject>) -> Void
typealias DefaultArrayDictResultAPISuccessClosure = (Array<Dictionary<String,AnyObject>>) -> Void

typealias DefaultStreamSuccessClosure = (Data) -> Void
typealias DefaultStreamFailureClosure = (Dictionary<String,AnyObject>) -> Void


protocol APIErrorHandler {
    func handleErrorFromResponse(response: Dictionary<String,AnyObject>)
    func handleErrorFromERror(error:NSError)
}

final class APIManager: NSObject {
    static let sharedInstance = APIManager(token: "")
    var serverToken: String?
    private init(token: String) {
        self.serverToken = token
    }
    let authenticationManagerAPI = AuthenticationAPIManager()
}
