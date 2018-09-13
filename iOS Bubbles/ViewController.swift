//
//  ViewController.swift
//  iOS Bubbles
//
//  Created by Victor Idongesit on 12/09/2018.
//  Copyright © 2018 Victor Idongesit. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var fishImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fishImageView = UIImageView(frame: CGRect(x: self.view.center.x - 100, y: self.view.center.y - 100, width: 200, height: 200))
        fishImageView.image = UIImage(named: "fish")
        self.view.addSubview(fishImageView)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(createBubble))
        singleTap.numberOfTapsRequired = 1
        fishImageView.isUserInteractionEnabled = true
        fishImageView.addGestureRecognizer(singleTap)
        
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(createBubble), userInfo: nil, repeats: true)
        goFishGo()
    }
    
    
    @objc
    func createBubble() {
        let bubbleImageView = UIImageView(image: UIImage(named: "bubble"))
        let size: CGFloat = CGFloat(randomFloatBetween(smallNumber: 5, and: 30))
        bubbleImageView.frame = CGRect(x: (self.fishImageView.layer.presentation()?.frame.maxX)! - 10, y: (self.fishImageView.layer.presentation()?.frame.origin.y)! + 100, width: size, height: size)
        self.view.addSubview(bubbleImageView)
        
        let zizZagPath = UIBezierPath()
        let oX: CGFloat = bubbleImageView.frame.origin.x
        let oY: CGFloat = bubbleImageView.frame.origin.y
        let eX: CGFloat = oX
        let eY: CGFloat = oY - CGFloat(randomFloatBetween(smallNumber: 50, and: 300))
        let t: CGFloat = CGFloat(randomFloatBetween(smallNumber: 20, and: 100))
        var cp1: CGPoint = CGPoint(x: oX - t, y: (oY + eY)/2)
        var cp2: CGPoint = CGPoint(x: oX + t, y: cp1.y)
        
        let r = arc4random() % 2
        if ( r == 1) {
            let temp = cp1
            cp1 = cp2
            cp2 = temp
        }
        
        zizZagPath.move(to: CGPoint(x: oX, y: oY))
        zizZagPath.addCurve(to: CGPoint(x: eX, y: eY), controlPoint1: cp1, controlPoint2: cp2)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            UIView.transition(with: bubbleImageView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                bubbleImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }, completion: { (finished) in
                CATransaction.commit()
                bubbleImageView.removeFromSuperview()
            })
        }
        
        let pathAnimation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "position")
        pathAnimation.duration = 2
        pathAnimation.path = zizZagPath.cgPath
        
        pathAnimation.fillMode = kCAFillModeForwards
        pathAnimation.isRemovedOnCompletion = false
        bubbleImageView.layer.add(pathAnimation, forKey: "movingAnimation")
    }
    
    func randomFloatBetween(smallNumber: Float, and bigNumber: Float) -> Float {
        let diff = bigNumber - smallNumber
        return Float(arc4random()) / 0xFFFFFFFF * diff + smallNumber
    }
    
    func goFishGo() {
        UIView.animate(withDuration: 5, animations: {
            self.fishImageView.frame = CGRect(x: self.view.frame.size.width + 200, y: self.view.center.y - 100, width: 200, height: 200)
        }) { (finished) in
            self.fishImageView.frame = CGRect(x: self.view.frame.origin.x - 200, y: self.view.center.y - 100, width: 200, height: 200)
            self.goFishGo()
        }
    }
}
