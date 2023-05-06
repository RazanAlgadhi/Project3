//
//  UIViewController+Extension.swift
//  OnTheMapRaz
//
//  Created by pc on 02/05/2023.
//

import UIKit

extension UIViewController {
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        OnTheMapClient.logout {
            print("Successfully logged out")
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
