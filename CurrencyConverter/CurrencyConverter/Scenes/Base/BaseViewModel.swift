//
//  BaseViewModel.swift
//  CurrencyConverter
//
//  Created by Muneeb Ali on 22/11/2020.
//

import Foundation


typealias updateLoadingStatus = (_ status: Bool) -> Void
typealias showAlertClosure = (_ message: String) -> Void
typealias didFinishFetch = () -> Void


import Foundation


class BaseViewModel {
    // MARK: - Properties
    var error: String? {
        didSet { self.showAlertClosure?(error ?? "") }
    }
    var isLoading: Bool = false {
        didSet { self.loadingStatus?(isLoading) }
    }
    var infoMessage = ""
    
    
    // MARK: - Closures for callback
    var loadingStatus : updateLoadingStatus?
    var showAlertClosure : showAlertClosure?
    var didFinishFetch : didFinishFetch?
}
