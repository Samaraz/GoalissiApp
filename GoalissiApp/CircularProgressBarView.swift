//
//  CircularProgressBarView.swift
//  GoalissiApp
//
//  Created by MAC on 11/08/2022.
//

import UIKit

class CircularProgressBarView: UIView {

    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var startPoint = CGFloat(-Double.pi / 2)
    private var endPoint = CGFloat(3 * Double.pi / 2)

    override init(frame: CGRect) {
            super.init(frame: frame)
        createCircularPath()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            createCircularPath()
        }
    
    
    func createCircularPath() {
            // created circularPath for circleLayer and progressLayer
            let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: 30, startAngle: startPoint, endAngle: endPoint, clockwise: true)
            // circleLayer path defined to circularPath
            circleLayer.path = circularPath.cgPath
            // ui edits
            circleLayer.fillColor = UIColor.clear.cgColor
            circleLayer.lineCap = .round
            circleLayer.lineWidth = 20.0
            circleLayer.strokeEnd = 1.0
            circleLayer.strokeColor = #colorLiteral(red: 0.1958445639, green: 0.1958445639, blue: 0.1958445639, alpha: 1)
            // added circleLayer to layer
            layer.addSublayer(circleLayer)
            // progressLayer path defined to circularPath
            progressLayer.path = circularPath.cgPath
            // ui edits
            progressLayer.fillColor = UIColor.clear.cgColor
            progressLayer.lineCap = .round
            progressLayer.lineWidth = 2.5
            progressLayer.strokeEnd = 0
            progressLayer.strokeColor = #colorLiteral(red: 0.1779021207, green: 1, blue: 0.694549985, alpha: 1)
            // added progressLayer to layer
            layer.addSublayer(progressLayer)
        }
    
    func progressAnimation(duration: TimeInterval) {
            // created circularProgressAnimation with keyPath
            let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
            // set the end time
            circularProgressAnimation.duration = duration
            circularProgressAnimation.toValue = 1.0
            circularProgressAnimation.fillMode = .forwards
            circularProgressAnimation.isRemovedOnCompletion = false
            progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
        }

}
