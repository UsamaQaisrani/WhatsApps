//
//  TabBar.swift
//  WhatsApps
//
//  Created by Usama on 01/03/2021.
//

import UIKit
@IBDesignable class TabBar: UITabBar {
    
    var shapeLayer: CALayer?
    
    required init?(coder acoder: NSCoder) {
        super.init(coder: acoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        self.addShape()
    }
    
    func addShape(){
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        }
        else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
        
    }
    
    func createPath() -> CGPath{
        let height: CGFloat = 37.0
        let path = UIBezierPath()
        let centerWidth = self.frame.width/2
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: centerWidth - height * 2, y: 0))
        path.addCurve(to: CGPoint(x: centerWidth, y: height), controlPoint1: CGPoint(x: (centerWidth - 30), y: 0), controlPoint2: CGPoint(x: (centerWidth-35), y: height))
        path.addCurve(to: CGPoint(x: centerWidth + height * 2, y: 0), controlPoint1: CGPoint(x: centerWidth + 35, y: height), controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        return path.cgPath
    }

    
}
