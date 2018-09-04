//
//  MMKeyBoardView.swift
//  WeChatKeyBoard
//
//  Created by 马扬 on 2018/9/4.
//  Copyright © 2018年 mayang. All rights reserved.
//

import UIKit

class MMKeyBoardView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        guard let nibs = Bundle.main.loadNibNamed("MMKeyBoardView", owner: nil, options: nil)?.last else {
            return
        }
        guard let xib = nibs as? MMKeyBoardView else {
            return
        }
        self.addSubview(xib)
        let top = NSLayoutConstraint.init(item: xib, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint.init(item: xib, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint.init(item: xib, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint.init(item: xib, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        self.addConstraints([top,bottom,left,right])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
