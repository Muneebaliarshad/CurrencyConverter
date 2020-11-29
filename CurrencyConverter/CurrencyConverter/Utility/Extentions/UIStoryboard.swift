//
//  UIStoryboard.swift
//  CurrencyConverter
//
//  Created by Muneeb Ali on 23/11/2020.
//

import UIKit


enum StoryboardNames : String {
    case Main = "Main"
}


enum NibNames : String {
    case RatesViewController = "RatesViewController",
         ConverterViewController = "ConverterViewController",
         CountriesListViewController = "CountriesListViewController"
}


extension UIStoryboard {
    
    //MARK: - Generic Public/Instance Methods
    func loadViewController(withIdentifier identifier: NibNames) -> UIViewController {
        return self.instantiateViewController(withIdentifier:  identifier.rawValue)
    }
    
    //MARK: - Class Methods to load Storyboards
    
    class func storyBoard(withName name: StoryboardNames) -> UIStoryboard {
        return UIStoryboard(name: name.rawValue , bundle: Bundle.main)
    }
    
}
