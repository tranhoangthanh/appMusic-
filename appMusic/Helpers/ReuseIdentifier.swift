//
//  ReuseIdentifier.swift
//  appMusic
//
//  Created by Trần Thành on 1/24/20.
//  Copyright © 2020 Trần Thành. All rights reserved.
//

import UIKit

protocol ReuseIdentifier {
  static var reuseIdentifier: String { get }
}

extension ReuseIdentifier {
  /// Return a suggested name that can be used as an cellIdentifier.
  static var reuseIdentifier: String {
    return String(describing: self)
  }
  
}

extension UIView: ReuseIdentifier {}

