//
//  LoginButton.swift
//  OnTheMapRaz
//
//  Created by pc on 02/05/2023.
//

import UIKit

class LoginButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
        tintColor = UIColor.white
        backgroundColor = UIColor.redForButton
    }
}
