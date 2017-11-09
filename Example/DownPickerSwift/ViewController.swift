//
//  ViewController.swift
//  DownPickerSwift
//
//  Created by rbbbj on 10/28/2017.
//  Copyright (c) 2017 rbbbj. All rights reserved.
//

import UIKit
import DownPickerSwift

class ViewController: UIViewController {

    @IBOutlet var testTextField: UITextField!
    
    var firstPicker: DownPickerSwift?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDownPicker()
    }

    private func setupDownPicker() {
        let picker = ["R.E.M.", "Dire Straits", "Police", "Sex Pistols", "Pink Floyd"]
        firstPicker = DownPickerSwift(with: testTextField, with: picker)
    }
}

