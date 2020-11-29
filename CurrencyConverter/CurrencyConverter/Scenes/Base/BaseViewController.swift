//
//  BaseViewController.swift
//  CurrencyConverter
//
//  Created by Muneeb Ali on 21/11/2020.
//

import Foundation
import UIKit


class BaseViewController: UIViewController {
    
    //MARK: - Variables
    var leftBarButtonItem : UIBarButtonItem?
    var rightBarButtonItem : UIBarButtonItem?
    
    
    //MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = item
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    //MARK: - Helper Methods
    func showAlertWith(message: String) {
        let alert = UIAlertController(title: "Currency Converter", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

