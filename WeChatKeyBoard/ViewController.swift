//
//  ViewController.swift
//  WeChatKeyBoard
//
//  Created by 马扬 on 2018/9/3.
//  Copyright © 2018年 mayang. All rights reserved.
//

import UIKit

class ViewController: UIViewController,MMPassWordDelete {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)

        let view = MMPassWordView.show(delegate: self,count: 6, lineColor: UIColor.init(red: (221 / 255.0), green:  (221 / 255.0), blue:  (221 / 255.0), alpha: 1), lineWidth: 1, fillColor: UIColor.black)
        self.view.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let height = NSLayoutConstraint.init(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44)
        let width = NSLayoutConstraint.init(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 270)
        view.addConstraints([height,width])

        let centerx = NSLayoutConstraint.init(item: view, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        self.view.addConstraint(centerx)
        let top = NSLayoutConstraint.init(item: view, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 200)
        self.view.addConstraint(top)


    }

    func passwordCancel(text: String) {
        print(text)
    }

    func passwordDidInput(pwView: MMPassWordView) -> Bool {
        print("输入结束")
        return true
    }
    func passwordBeginInput(pwView: MMPassWordView) -> Bool {
        print("输入开始")
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

