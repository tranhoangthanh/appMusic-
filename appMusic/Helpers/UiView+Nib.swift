//
//  UiView+Nib.swift
//  appMusic
//
//  Created by Trần Thành on 1/24/20.
//  Copyright © 2020 Trần Thành. All rights reserved.
//
import UIKit

extension UIView {
  /// Return an UINib object from the nib file with the same name.
  class var nib: UINib? {
    return UINib(nibName: String(describing: self), bundle: nil)
  }
  
  class var viewFromNib: UIView? {
    let views = Bundle.main.loadNibNamed(String(describing: self), owner: self, options: nil)
    let view = views![0] as! UIView
    return view
  }
}
