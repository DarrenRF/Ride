
//  RoundedCornerTextField.swift
//  ride
//
//  Created by Darren Fuller.
//  Copyright © 2020 Darren Fuller. All rights reserved.
//

import UIKit

var textRectOffset: CGFloat = 20

class RoundedCornerTextField: UITextField {

    override func awakeFromNib() {
        setupView()
    }
    
    func setupView(){
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 0 + textRectOffset, y: 0 + (textRectOffset / 2), width: self.frame.width - textRectOffset, height: self.frame.height + textRectOffset)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        return CGRect(x: 0 + textRectOffset, y: 0 + (textRectOffset / 2), width: self.frame.width - textRectOffset, height: self.frame.height + textRectOffset)
    }
}
