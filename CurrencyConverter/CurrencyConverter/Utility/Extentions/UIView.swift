//
//  UIView.swift
//  CurrencyConverter
//
//  Created by Muneeb Ali on 21/11/2020.
//

import Foundation
import UIKit


extension UIView {
    
    //MARK: - variables
    
    
    //MARK: - IBInspectable
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        } set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
            self.clipsToBounds = true
        }
    }

    
    @IBInspectable var isRoundView: Bool {
        get {
            return self.isRoundView
            
        }
        set(isRoundView){
            if(isRoundView){
                self.layer.cornerRadius = self.frame.size.height / 2
            }else{
                self.layer.cornerRadius = 0
            }
            self.clipsToBounds = true
            self.layoutSubviews()
        }
    }
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------
        //MARK: - Animation
        func shadow(color: UIColor) {
            layer.shadowColor = color.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 3)
            layer.shadowOpacity = 0.5
            layer.shadowRadius = 20.0
            layer.masksToBounds = false
     
        }
    
    
    //-------------------------------------------------------------------------------------------------------------------------------------------
        //MARK: - Loading Methods
        func startLoading(radius: CGFloat = 50) {
            endEditing(true)
            let circleLayer = CAShapeLayer()
            
            let startAngle = CGFloat(-Double.pi / 2)
            let endAngle = startAngle + CGFloat(Double.pi * 2)
            let path = UIBezierPath(arcCenter: .zero, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            
            circleLayer.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
            circleLayer.path = path.cgPath
            
            circleLayer.lineWidth = 5
            circleLayer.fillColor = nil
            circleLayer.strokeColor = #colorLiteral(red: 0.3689999878, green: 0.4079999924, blue: 0.9530000091, alpha: 1)
            layer.addSublayer(circleLayer)
            
            circleLayer.add(CAAnimation.strokeEndAnimation(), forKey: "strokeEnd")
            circleLayer.add(CAAnimation.strokeStartAnimation(), forKey: "strokeStart")
            circleLayer.add(CAAnimation.rotationAnimation(), forKey: "rotation")
        }
        
        func stopLoading() {
            layer.sublayers?.popLast()?.removeFromSuperlayer()
        }
}
