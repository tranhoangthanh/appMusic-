//
//  extension.swift
//  appMusic
//
//  Created by Trần Thành on 1/11/20.
//  Copyright © 2020 Trần Thành. All rights reserved.
//

import UIKit

extension UIViewController {
    func simpleAlert(title : String , msg : String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
