//
//  CustomizeButton.swift
//  On The Map
//
//  Created by Udumala, Mary on 4/3/17.
//  Copyright © 2017 Udumala, Mary. All rights reserved.
//

import UIKit

class CustomizeButton {
    
    static func customizeButtonsLook(button: UIButton) {
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.backgroundColor = UIColor.init(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0)
    }
    
}
