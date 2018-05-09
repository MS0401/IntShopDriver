//
//  SCDatePicker.swift
//  Helper App
//
//  Created by Stewart Crainie on 21/06/2016.
//  Copyright © 2016 Stewart Crainie. All rights reserved.
//

import UIKit
import Foundation

//Adding Comment to Github

@objc public protocol SCDatePickerDelegate: NSObjectProtocol {
    
    @objc optional func didSelectDate(_ dateString:String, date:Date)
   
}

@objc public protocol SCDateFieldDelegate: NSObjectProtocol {
    
    @objc optional func dateTextHasChanged(_ dateString:String, date:Date)
    
}

open class SCDatePicker: UIDatePicker {
    
    //DatePicker Mode
    public enum SCDatePickerType {
        case date, time, countdown
        
        public func dateType() -> UIDatePickerMode {
            switch self {
            case SCDatePickerType.date: return .date
            case SCDatePickerType.time: return .dateAndTime
            case SCDatePickerType.countdown: return .countDownTimer
            }
        }
    }

    //Delegate
    open var scDelegate: SCDatePickerDelegate?
    
    //Public Options
    open var scType: SCDatePickerType!
    
    
    // MARK: - NSObject
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureDatePicker()
        
        
    }
    
    //Layout Subviews
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        self.datePickerMode = .date//scType.dateType()

    }
    
    //Configure DatePicker
    fileprivate func configureDatePicker() {
        
        self.addTarget(self, action: #selector(SCDatePicker.handleDatePicker(_:)), for: UIControlEvents.valueChanged)
        
    }
    
    //MARK: Delegate - handle datepicker selection
    @objc fileprivate func handleDatePicker(_ sender: UIDatePicker) {
        
        if scDelegate != nil {
            scDelegate?.didSelectDate!(dateToString("EEE, dd MMM yyyy", date: sender.date), date: sender.date)
        }
        //EEE, dd MMM yyyy
        
    }
    
    //Date -> String (input string required)
    fileprivate func dateToString(_ convertTo:String, date:Date) -> String{
        
        let dateFormatter = DateFormatter()
        let currentDate = date
        dateFormatter.dateFormat = convertTo
        
        return dateFormatter.string(from: currentDate)
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
}

//DatePickerTexfield Class
open class DateFieldTextField: UITextField, SCDatePickerDelegate{
    
    //Init DatePicker
    let scDatePicker = SCDatePicker()
    
    //Public Options
    open var datetype: SCDatePicker.SCDatePickerType?

    //Toolbar
    open var doneButtonTint:UIColor?
    
    //Delegate
    open var dateDelegate: SCDateFieldDelegate?
    
    // MARK: - NSObject
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    //Layout Subviews
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        self.inputAccessoryView = configureToolBar()
        scDatePicker.scDelegate = self
        scDatePicker.scType = datetype
        scDatePicker.backgroundColor = UIColor(netHex: 0x2484C6)
        self.inputView = scDatePicker
        
    }
    
    //Date Selected
    open func didSelectDate(_ dateString: String, date: Date) {
        
        if dateDelegate != nil {
            self.text = dateString
            self.dateDelegate?.dateTextHasChanged!(dateString, date: date)
        }
    }
    
    //Configure Toolbar
    fileprivate func configureToolBar() -> UIToolbar {
        
        // toolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.barTintColor = UIColor(netHex: 0x2484C6)
        toolBar.sizeToFit()
    
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(DateFieldTextField.handleDatePickerDoneButton(_:)))
        
        //Custom Options
        doneButton.tintColor = doneButtonTint
        
        toolBar.setItems([space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        return toolBar
        
    }

    //MARK: Delegate - did select date
    @objc fileprivate func handleDatePickerDoneButton(_ sender:UIBarButtonItem) {
        if dateDelegate != nil {
            self.endEditing(true)
        }
    }

    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
