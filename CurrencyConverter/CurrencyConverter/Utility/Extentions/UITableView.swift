//
//  UITableView.swift
//  CurrencyConverter
//
//  Created by Muneeb Ali on 24/11/2020.
//

import Foundation
import UIKit

extension UITableView {
    
    func scrollToTop() {
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func scrollToBottom(){
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.numberOfRows(inSection:  self.numberOfSections-1), section:  self.numberOfSections-1)
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func scrollToSelectedRow(selectedRow: Int, selectedSection: Int) {
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: selectedRow, section: selectedSection)
            self.scrollToRow(at: indexPath, at: .none, animated: false)
        }
    }
}
