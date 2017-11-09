//
//  DownPickerSwift.swift
//  DownPickerSwiftTest
//
//  Created by Robertas Baronas on 07/10/2017.
//  Copyright © 2017 Robertas Baronas. All rights reserved.
//

import Foundation
import UIKit

open class DownPickerSwift: UIControl {
    
    public var shouldDisplayCancelButton = true
    
    @IBOutlet fileprivate var textField: UITextField!
    fileprivate lazy var textFieldPickerView = UIPickerView()
    fileprivate var dataArray = [String]()
    fileprivate let placeholder: String
    fileprivate var placeholderWhileSelecting: String
    fileprivate var toolbarDoneButtonText: String
    fileprivate var toolbarCancelButtonText: String
    fileprivate var toolbarStyle: UIBarStyle
    var previousSelectedString: String?
    
    public init(with tf: UITextField, with data: [String]) {
        textField = tf
        toolbarStyle = .default

        placeholder = "Tap to choose..."
        placeholderWhileSelecting = "Pick an option..."
        toolbarDoneButtonText = "Done"
        toolbarCancelButtonText = "Cancel"
        
//        // hide the caret and its blinking
//        [[textField valueForKey:@"textInputTraits"]
//            setValue:[UIColor clearColor]
//            forKey:@"insertionPointColor"];
        
        // set the placeholder
        textField.placeholder = placeholder

        // setup the arrow image
        var img = UIImage(named: "downArrow.png")  // Non-CocoaPods
        if img == nil {
            img = UIImage(named: "DownPickerSwift.bundle/downArrow.png") // CocoaPods
        }
        if img != nil {
            textField?.rightView = UIImageView(image: img)
        }
        textField?.rightView?.contentMode = .scaleAspectFit
        textField?.rightView?.clipsToBounds = true

        super.init(frame: .zero)
        
        // Set the data array (if present)
        if !data.isEmpty {
            setData(data: data)
        }
        
        textField.delegate = self
        showArrowImage(true)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public methods

extension DownPickerSwift {
    
    public func setData(data: [String]) {
        dataArray = data
    }
    
    public func getPickerView() -> UIPickerView {
        return textFieldPickerView
    }
    
    public func getTextField() -> UITextField {
        return textField
    }
    
    /**
     TRUE to show the rightmost arrow image, FALSE to hide it.
     @param b
     TRUE to show the rightmost arrow image, FALSE to hide it.
     */
    public func showArrowImage(_ b: Bool) {
        if b {
            textField?.rightViewMode = .always
        } else {
            textField?.rightViewMode = .never
        }
    }
    
    public func setArrow(with image: UIImage) {
        textField.rightView = UIImageView(image: image)
    }
    
    public func setPlaceholder(with str: String) {
        textField.placeholder = str;
        
    }
    
    public func setPlaceholderWhileSelecting(with str: String) {
        placeholderWhileSelecting = str
    }
    
    public func setAttributedPlaceholder(with attributedString: NSAttributedString) {
        textField.attributedPlaceholder = attributedString
    }
    
    public func setToolbarDoneButton(with text: String) {
        toolbarDoneButtonText = text
    }
    
    public func setToolbarCancelButton(with text: String) {
        toolbarCancelButtonText = text
    }
    
    public func setToolbar(with style: UIBarStyle) {
        toolbarStyle = style
    }
    
    public func getValue(at index: Int) -> String? {
        return dataArray.count > index ? dataArray[index] : nil
    }
    
    public func setValue(at index: Int) {
        if index >= 0 {
            pickerView(textFieldPickerView, didSelectRow: index, inComponent: 0)
        } else {
            setText(txt: nil)
        }
    }
}

// MARK: UIPickerViewDataSource

extension DownPickerSwift: UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArray.count
    }
}

// MARK: UIPickerViewDelegate

extension DownPickerSwift: UIPickerViewDelegate {
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataArray[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = dataArray[row]
        sendActions(for: .valueChanged)
    }
}

// MARK: UITextFieldDelegate

extension DownPickerSwift: UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        sendActions(for: .editingDidBegin)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textField.isUserInteractionEnabled = true
        sendActions(for: .editingDidEnd)
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if !dataArray.isEmpty {
            showPicker()
            return true
        }
        
        return false
    }
}

// MARK: Private methods

extension DownPickerSwift {
    
    fileprivate func showPicker() {
        previousSelectedString = textField.text
        
        textFieldPickerView.showsSelectionIndicator = true
        textFieldPickerView.dataSource = self
        textFieldPickerView.delegate = self
        
//                if textField?.text?.characters.count == 0 || !dataArray.contains((textField?.text)!) {
//                    if placeholderWhileSelecting {
//                        textField?.placeholder = placeholderWhileSelecting
//                    }
//                    // 0.1.31 patch: auto-select first item: it basically makes placeholderWhileSelecting useless, but
//                    // it solves the "first item cannot be selected" bug due to how the pickerView works.
//                    selectedIndex = 0
//                }
//                else {
//                    if dataArray.contains((textField?.text)!) {
//                        pickerView.selectRow((dataArray as NSArray).index(of: textField?.text ?? <#default value#>), inComponent: 0, animated: true)
//                    }
//                }
        
        // Setup toolbar
        let toolbar = UIToolbar()
        toolbar.barStyle = toolbarStyle
        toolbar.sizeToFit()
        let flexibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                                             target: nil,
                                                             action: nil)
        let doneButton = UIBarButtonItem(title: toolbarDoneButtonText,
                                         style: .done,
                                         target: self,
                                         action: #selector(self.doneClicked))
        if shouldDisplayCancelButton {
            let cancelButton = UIBarButtonItem(title: toolbarCancelButtonText,
                                               style: .plain,
                                               target: self,
                                               action: #selector(self.cancelClicked))
            toolbar.items = [cancelButton, flexibleSpace, doneButton]
        } else {
            toolbar.items = [flexibleSpace, doneButton]
        }
        
        textField.inputView = textFieldPickerView
        textField.inputAccessoryView = toolbar
    }
    
    @objc func cancelClicked() {
        textField.resignFirstResponder()
        if previousSelectedString?.count == 0 || !dataArray.contains(previousSelectedString!) {
            textField?.placeholder = placeholder
        }
        textField?.text = previousSelectedString
    }
    
    @objc func doneClicked() {
        textField.resignFirstResponder()
        if textField?.text?.count == 0 || !dataArray.contains((textField?.text)!) {
            setValue(at: -1)
            textField?.placeholder = placeholder
        }
        sendActions(for: .valueChanged)
    }
    
    /**
     Getter for selectedIndex property.
     @return
     The zero-based index of the selected item or -1 if nothing has been selected yet.
     */
    fileprivate func selectedIndex() -> Int {
        guard let text = textField.text else {
            return -1
        }
        
        guard let index = dataArray.index(of: text) else {
            return -1
        }
        
        return index
    }
    
    /**
     Setter for selectedIndex property.
     @param index
     Sets the zero-based index of the selected item using the setValueAtIndex method: -1 can be used to clear selection.
     */
    fileprivate func setSelectedIndex(index: Int) {
        setValue(at: index)
    }
    
    /**
     Getter for text property.
     @return
     The value of the selected item or NIL NIL if nothing has been selected yet.
     */
    fileprivate func text() -> String? {
        return textField.text
    }
    
    /**
     Setter for text property.
     @param txt
     The value of the item to select or NIL to clear selection.
     */
    fileprivate func setText(txt: String?) {
        guard let txt = txt else {
            textField?.text = nil
            return
        }
        
        if let index = dataArray.index(of: txt) {
            setValue(at: index)
        }
    }
}
