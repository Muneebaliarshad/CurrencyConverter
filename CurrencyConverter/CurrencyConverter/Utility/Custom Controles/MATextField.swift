//
//  MATextField.swift
//  CurrencyConverter
//
//  Created by Muneeb Ali on 21/11/2020.
//

import UIKit


@IBDesignable
class MATextField: UITextField {
    
    //MARK: - Variables
    var bottomBorder: UIView?
    var padding: UIEdgeInsets?
    var pickerView: UIPickerView?
    var pickerData: [String]?
    var datePicker: UIDatePicker?
    
    
    //MARK: - Nib Methods
    override func awakeFromNib() {
        setBottomBorder()
        padding = UIEdgeInsets(top: 0, left: self.frame.height, bottom: 0, right: 0)
        delegate = self
    }
    
    
    //MARK: - IBInspectable
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateLeftImage()
        }
    }
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateLeftImage()
        }
    }
    
    
    //MARK: - Bottom Border
    fileprivate func setBottomBorder() {
        bottomBorder = UIView()
        self.translatesAutoresizingMaskIntoConstraints = false
        bottomBorder?.backgroundColor = UIColor.lightGray
        bottomBorder?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomBorder ?? UIView())
        
        //Mark: Set bottomBorder Anchors
        bottomBorder?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomBorder?.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        bottomBorder?.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        bottomBorder?.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    
    func updateLeftImage() {
        if let image = leftImage {
            leftViewMode = UITextField.ViewMode.always
            let iconContainerView = UIView(frame:CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height))
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            iconContainerView.addSubview(imageView)
            imageView.center = iconContainerView.convert(iconContainerView.center, from:iconContainerView.superview)
            imageView.tintColor = color
            leftView = iconContainerView
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }
    
    
    //MARK: - FirstResponder Methods
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        bottomBorder?.backgroundColor = color
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        color = #colorLiteral(red: 0.3764705882, green: 0.3764705882, blue: 0.3764705882, alpha: 1)
        bottomBorder?.backgroundColor = color
        textColor = #colorLiteral(red: 0.1450980392, green: 0.1450980392, blue: 0.1450980392, alpha: 1)
        return true
    }
    
    
    //MARK: - Padding Setting
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding ?? UIEdgeInsets())
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding ?? UIEdgeInsets())
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding ?? UIEdgeInsets())
    }
    
    
    //MARK: - Picker Method
    func setTextFieldAsPicker(_ data: [String]) {
        pickerView = UIPickerView()
        inputView = pickerView
        pickerData = data
        pickerView?.dataSource = self
        pickerView?.delegate = self
    }
    
    func  setTextFieldasDatePicker() {
        datePicker = UIDatePicker()
        inputView = datePicker
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
    }
    
    @objc func handleDatePicker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        text = dateFormatter.string(from: datePicker?.date ?? Date())
    }
}


//MARK: - UITextFieldDelegate Methods
extension MATextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if pickerView != nil {
            text = pickerData?[0]
        }
    }
    
}


//MARK: - UIPickerViewDataSource Methods
extension MATextField: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData?.count ?? 0
    }
    
}


//MARK: - UIPickerViewDataSource Methods
extension MATextField: UIPickerViewDelegate {
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData![row]
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        text = pickerData?[row]
    }
}
