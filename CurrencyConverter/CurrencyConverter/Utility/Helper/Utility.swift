//
//  Utility.swift
//  CurrencyConverter
//
//  Created by Muneeb Ali on 22/11/2020.
//

import Alamofire


final class Utility : NSObject {
    //MARK: - variables
    
    
    final class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }

    //MARK: - UIView Helping Methods
    final class func getTopViewController() -> UIViewController {
        var finalViewController = UIViewController()
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            finalViewController = topController
        }
        return finalViewController
    }
}
