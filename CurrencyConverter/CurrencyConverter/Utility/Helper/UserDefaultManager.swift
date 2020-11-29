//
//  UserDefaultManager.swift
//  CurrencyConverter
//
//  Created by Muneeb Ali on 24/11/2020.
//

import Foundation


let DEFAULTS = UserDefaults.standard

final class UserDefaultsManager: NSObject {

    //MARK: - Variables
    

//------------------------------------------------------------------------------------------------------------------------------------------------------------
    //MARK: - User Data
    final class func setRateList(list: [String: Float]){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(list) {
            DEFAULTS.set(encoded, forKey: "RateList")
        }
    }

    
    
    class func getRateList() -> [String: Float]? {
        if let savedUser = DEFAULTS.object(forKey: "RateList") as? Data {
            let decoder = JSONDecoder()
            if let loadedUser = try? decoder.decode([String: Float].self, from: savedUser) {
                return loadedUser
            }
        }
        return [String: Float]()
    }

}


