//
//  MMKeyBoardView.swift
//  WeChatKeyBoard
//
//  Created by 马扬 on 2018/9/3.
//  Copyright © 2018年 mayang. All rights reserved.
//

import UIKit
import CoreGraphics



class MMPassWordView: UIView,UIKeyInput {

    /** 密码长度  默认为6*/
    fileprivate var passWordCount = 6
    /** 设置边款颜色 */
    fileprivate var lineColor : UIColor = UIColor.gray
    /** 设置边框宽度 */
    fileprivate var lineWidth : CGFloat = 1
    /** 设置黑点颜色 */
    fileprivate var fillColor: UIColor = UIColor.black

    /** 代理 */
    fileprivate var delegate : MMPassWordDelete?


    /** 展示密码
     
     * @param count 密码长度
     * @param lineColor 分割线的颜色
     * @param lineWidth 分割线的宽度
     * @param fillColor 黑色远点的填充色
     */
    public class func show(delegate:MMPassWordDelete?,
                           count : Int = 6,
                           lineColor : UIColor = UIColor.gray,
                           lineWidth:CGFloat = 1,
                           fillColor:UIColor = UIColor.black
        ) -> MMPassWordView{
        let pw = MMPassWordView.init(frame: .zero)
        pw.passWordCount = count
        pw.lineColor = lineColor
        pw.lineWidth = lineWidth
        pw.fillColor = fillColor
        pw.delegate = delegate
        return pw
    }

    fileprivate override init(frame: CGRect) {
        super.init(frame: frame)
        self.createView()
    }

    override var canBecomeFirstResponder: Bool{
        get{
            return true
        }
    }

    fileprivate func createView(){
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.borderWidth = 1
        self.backgroundColor = UIColor.white
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.canBecomeFirstResponder{
            self.becomeFirstResponder()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(self.lineWidth)
        context?.setStrokeColor(self.lineColor.cgColor)
        context?.setFillColor(self.fillColor.cgColor)

        let width = self.bounds.size.width / CGFloat(self.passWordCount)
        for i in 1 ..< self.passWordCount {
            context?.move(to: CGPoint.init(x: width * CGFloat(i), y: 0))
            context?.addLine(to: CGPoint.init(x: width * CGFloat(i), y: self.bounds.size.height))
            context?.closePath()
        }
        context?.drawPath(using: .stroke)

        if self.text.count < 1{
            return
        }
        for i in 1 ... self.text.count {
            let center = CGFloat(i) * width - width / 2.0
            context?.addArc(center: CGPoint.init(x: center, y: self.bounds.size.height / 2.0), radius: 5, startAngle: 0, endAngle: CGFloat(CGFloat.pi * 2), clockwise: true)
            context?.drawPath(using: .fill)
        }

    }




    //MARK:UIKeyInput
    var hasText: Bool = true
    /** 设定键盘为数字键盘 */
    var keyboardType: UIKeyboardType = .numberPad

    var text : String = ""

    func insertText(_ text: String) {
        if self.text.count >= self.passWordCount{
            if self.delegate?.passwordDidInput?(pwView: self) == true{
                self.resignFirstResponder()
            }
            self.delegate?.passwordCancel?(text: self.text)
            return
        }
        self.text = self.text + text
        self.setNeedsDisplay()
        if self.text.count >= self.passWordCount{ /** 用户输入完成 */
            if self.delegate?.passwordDidInput?(pwView: self) == true{
                self.resignFirstResponder()
            }
            self.delegate?.passwordCancel?(text: self.text)
            return
        }
    }

    func deleteBackward() {
        if self.text.count == 0 {
            return
        }
        self.text.remove(at: self.text.index(before: self.text.endIndex))
        self.setNeedsDisplay()
    }

    @discardableResult
    override func becomeFirstResponder() -> Bool {
        if self.delegate?.passwordBeginInput?(pwView: self) == false{
            return false
        }
        return super.becomeFirstResponder()
    }

}
@objc protocol MMPassWordDelete : NSObjectProtocol {
    /** 密码输入是否允许 */
    @objc optional func passwordBeginInput(pwView : MMPassWordView) -> Bool;
    /** 是否允许密码输入完成 */
    @objc optional func passwordDidInput(pwView : MMPassWordView) -> Bool;
    /** 用户输入完成 */
    @objc optional func passwordCancel(text:String) -> Void
}
