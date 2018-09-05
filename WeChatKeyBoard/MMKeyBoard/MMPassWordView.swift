//
//  MMKeyBoardView.swift
//  WeChatKeyBoard
//
//  Created by 马扬 on 2018/9/3.
//  Copyright © 2018年 mayang. All rights reserved.
//

import UIKit
import CoreGraphics
import QuartzCore



class MMPassWordView: UIView,UIKeyInput {

    /** 密码长度  默认为6*/
    fileprivate var passWordCount = 6
    /** 设置边款颜色 */
    fileprivate var lineColor : UIColor = UIColor.gray
    /** 设置边框宽度 */
    fileprivate var lineWidth : CGFloat = 1
    /** 设置黑点颜色 */
    fileprivate var fillColor: UIColor = UIColor.black
    /** 动画的颜色 */
    fileprivate var animationColor = UIColor.red
    /** 动画layout */
    fileprivate var animationLayer : CAShapeLayer?

    
    /** 输入完成自动收起键盘 */
    var isAutoHiddexKeyBoard  = true

    /** 代理 */
    fileprivate var delegate : MMPassWordDelete?


    /** 展示密码
     
     * @param count 密码长度
     * @param lineColor 分割线的颜色
     * @param lineWidth 分割线的宽度
     * @param fillColor 黑色远点的填充色
     * @param animationColor 动画的颜色
     */
    public class func show(delegate:MMPassWordDelete?,
                           count : Int = 6,
                           lineColor : UIColor = UIColor.gray,
                           lineWidth:CGFloat = 1,
                           fillColor:UIColor = UIColor.black,
                           animationColor : UIColor = UIColor.red
        ) -> MMPassWordView{
        let pw = MMPassWordView.init(frame: .zero)
        pw.passWordCount = count
        pw.lineColor = lineColor
        pw.lineWidth = lineWidth
        pw.fillColor = fillColor
        pw.delegate = delegate
        pw.animationColor = animationColor
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
        self.backgroundColor = UIColor.clear
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
        /** 绘制边框 */
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(self.lineWidth * 2)
        context?.setStrokeColor(self.lineColor.cgColor)
        context?.setFillColor(UIColor.white.cgColor)
        let bezier = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: 5)
        context?.addPath(bezier.cgPath)
        context?.drawPath(using: .eoFillStroke)

        /** 绘制线条 */
        let width = self.bounds.size.width / CGFloat(self.passWordCount)
        context?.setLineWidth(self.lineWidth)
        for i in 1 ..< self.passWordCount {
            context?.move(to: CGPoint.init(x: width * CGFloat(i), y: 0))
            context?.addLine(to: CGPoint.init(x: width * CGFloat(i), y: self.bounds.size.height))
            context?.closePath()
        }
        context?.drawPath(using: .stroke)
        /** 绘制底部的线 */
        if self.text.count == 6 || self.isFirstResponder{
            context?.move(to: CGPoint.init(x: 0, y: self.bounds.size.height - 1))
            context?.setStrokeColor(self.animationColor.cgColor)
            let count = self.text.count <= self.passWordCount ? self.text.count + 1 : self.text.count
            let x = CGFloat(count) * width
            context?.addLine(to: CGPoint.init(x: x, y: self.bounds.size.height - 1))
            context?.drawPath(using: .stroke)
        }

        if self.text.count < 1{ /** 没有输入 不绘制远点 */
            return
        }
        /** 绘制远点 */
        context?.setFillColor(self.fillColor.cgColor)
        for i in 1 ... self.text.count {
            let center = CGFloat(i) * width - width / 2.0
            context?.addArc(center: CGPoint.init(x: center, y: self.bounds.size.height / 2.0), radius: 5, startAngle: 0, endAngle: CGFloat(CGFloat.pi * 2), clockwise: true)
            context?.drawPath(using: .fill)
        }
    }

    fileprivate func startAnimation() -> Void{

        let bezire = UIBezierPath.init()

        bezire.move(to: CGPoint.init(x: 1, y: self.bounds.size.height - 1))
        bezire.addLine(to: CGPoint.init(x: 1, y: 1))
        bezire.addLine(to: CGPoint.init(x: self.bounds.size.width - 1, y: 1))
        bezire.addLine(to: CGPoint.init(x: self.bounds.size.width - 1, y: self.bounds.size.height - 1))
//        bezire.addLine(to: CGPoint.init(x: 1, y: self.bounds.size.height - 1))

        let animation = CABasicAnimation.init(keyPath: "strokeEnd")
        animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.duration = 1.5
        animation.fromValue = 0 as Any
        animation.toValue = 1 as Any
        animation.isRemovedOnCompletion = true
        animation.repeatCount = 100
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.lineWidth = 1
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = self.animationColor.cgColor
        shapeLayer.path = bezire.cgPath
        shapeLayer.add(animation, forKey: "loadingAnimation")
        self.animationLayer = shapeLayer
        self.layer.addSublayer(shapeLayer)
    }
    fileprivate func stopAnimation() -> Void{
        if self.animationLayer != nil {
            self.animationLayer?.removeAnimation(forKey: "loadingAnimation")
            self.animationLayer?.removeFromSuperlayer()
            self.animationLayer = nil
        }
    }




    //MARK:UIKeyInput
    var hasText: Bool = true
    /** 设定键盘为数字键盘 */
    var keyboardType: UIKeyboardType = .numberPad

    var text : String = ""

    func insertText(_ text: String) {
        if self.text.count >= self.passWordCount{
            /** 不允许收起键盘 */
            if self.delegate?.passwordDidInput?(pwView: self) == false{
                return
            }
            /** 允许收起键盘、并且允许自动收起键盘 */
            if self.isAutoHiddexKeyBoard{
                self.resignFirstResponder()
            }
//            self.delegate?.passwordCancel?(text: self.text)
            return
        }
        self.text = self.text + text
        self.setNeedsDisplay()
        if self.text.count >= self.passWordCount{ /** 用户输入完成 */
            self.startAnimation()
            if self.delegate?.passwordDidInput?(pwView: self) == false{ /** 输入完成 并且，不允许收起键盘 */
                self.delegate?.passwordCancel?(text: self.text)
                return
            }
            if self.isAutoHiddexKeyBoard{ /** 自动收起键盘 */
                self.resignFirstResponder()
            }
            self.delegate?.passwordCancel?(text: self.text)
            return
        }else{
            self.stopAnimation()
        }
    }

    func deleteBackward() {
        if self.text.count == 0 {
            return
        }
        self.text.remove(at: self.text.index(before: self.text.endIndex))
        self.setNeedsDisplay()
        self.stopAnimation()
    }

    @discardableResult
    override func becomeFirstResponder() -> Bool {
        if self.isFirstResponder{
            return true
        }
        if self.delegate?.passwordBeginInput?(pwView: self) == false{
            return false
        }
        self.setNeedsDisplay()
        return super.becomeFirstResponder()
    }
    @discardableResult
    override func resignFirstResponder() -> Bool {
        if self.text.count == 0{ /** 如果没有输入那么就重绘，去掉底部的线 */
            self.setNeedsDisplay()
        }
        return super.resignFirstResponder()
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
