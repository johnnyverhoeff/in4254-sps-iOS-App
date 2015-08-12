//
//  MapView.swift
//  SocketIOJsonTestApp
//
//  Created by Johnny Verhoeff on 24-07-15.
//  Copyright (c) 2015 Johnny Verhoeff. All rights reserved.
//

import UIKit
import ParticleFilterKit

/*@IBDesignable*/
class MapView: UIView {

    var latestMap: Map?
    var latestFilterData: ParticleFilter?
    
    var shouldRotate = false
    
    var mostProbableCellRect: CGRect?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.whiteColor()
    }

    override func drawRect(rect: CGRect) {
        if let map = latestMap {
            setStrokeColor()
            
            for cell in map.cells {
                var cellRect = scaleCGRect(cell.getCGRect())
                
                if shouldRotate {                    
                    cellRect = rotateCGRect(cellRect)
                }
                
                var textColor = UIColor.blackColor()
                
                if let probCell = latestFilterData?.probableCellLocation.0 {
                    if cell == probCell {
                        self.mostProbableCellRect = cellRect
                        textColor = UIColor.redColor()
                    }
                }
                
                let str = NSAttributedString(string: cell.name, attributes: [NSForegroundColorAttributeName : textColor])
                
                str.drawInRect(cellRect)
                
                setStrokeColor()
                var path = UIBezierPath(rect: cellRect)
                path.stroke()
            }
            
            for obstacle in map.obstacles {
                var obs = scaleCGRect(obstacle.getCGRect())
                if shouldRotate {
                    obs = rotateCGRect(obs)
                }
                var path = UIBezierPath(rect: obs)
                path.stroke()
            }
        }
        
        if let filter = latestFilterData {
            setStrokeColor()
            
            for particle in filter.particles {
                var p = scaleCGRect(particle.getCGRect())
                if shouldRotate {
                    p = rotateCGRect(p)
                }
                let rect = CGRect(x: p.origin.x, y: p.origin.y, width: 0.1, height: 0.1)
                var path = UIBezierPath(rect: rect)
                path.stroke()
            }
        }
    }
    
    private func setStrokeColor() {
        UIColor.blackColor().setStroke()
    }
    
    private func scaleCGRect(rect: CGRect) -> CGRect {
        if let map = latestMap {
            let longestSide = max(map.width, map.height)
            
            let mulFac = !shouldRotate ? bounds.width : bounds.height
            let mulFac2 = shouldRotate ? bounds.width : bounds.height
            
            let x = rect.origin.x / longestSide * mulFac
            let y = rect.origin.y / longestSide * mulFac
            let width = rect.width / longestSide * mulFac
            let height = rect.height / longestSide * mulFac
            
            return CGRect(x: x, y: y, width: width, height: height)
        } else {
            return rect
        }
    }
    
    private func rotateCGRect(rect: CGRect) -> CGRect {
        if let map = latestMap {
            let x = rect.origin.x
            let y = rect.origin.y
            
            let width = rect.width
            let height = rect.height
            
            
            
            
            //let originalBeginPoint = CGPoint(x: x, y: y)
            //let originalEndPoint = CGPoint(x: x + width, y: y + height)
            
            return CGRect(x: y, y: x, width: height, height: width)
        } else {
            return rect
        }
    }


}
