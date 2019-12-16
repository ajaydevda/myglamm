//
//  paddingUIlabel.swift
//  MyGlamm
//
//  Created by APS on 14/12/19.
//  Copyright © 2019 icici. All rights reserved.
//

import UIKit

    
    @IBDesignable class paddingUIlabel: UILabel {
        
        @IBInspectable var topInset: CGFloat = 2.0
        @IBInspectable var bottomInset: CGFloat = 2.0
        @IBInspectable var leftInset: CGFloat = 10.0
        @IBInspectable var rightInset: CGFloat = 10.0
        
        override func drawText(in rect: CGRect) {
            let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
            super.drawText(in: rect.inset(by: insets))
        }
        
        override var intrinsicContentSize: CGSize {
            let size = super.intrinsicContentSize
            return CGSize(width: size.width + leftInset + rightInset,
                          height: size.height + topInset + bottomInset)
        }
    }


