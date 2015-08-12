//
//  ViewController.swift
//  SocketIOJsonTestApp
//
//  Created by Johnny Verhoeff on 24-07-15.
//  Copyright © 2015 Johnny Verhoeff. All rights reserved.
//

import UIKit
import Foundation

import ParticleFilterKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    var mapView: MapView?
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var locationLabel: UILabel!
    
    var locationLabelText: String {
        get {
            if let (cell, prob) = self.mapView?.latestFilterData?.probableCellLocation {
                let formattedProb = String(format: "%0.2f", 100 * prob)
                return "You are in \(cell.name), with probability \(formattedProb) %."
            }
            return "I don't know where you are."
        }
    }
    
    var settings: Settings
    
    var socket: SocketIOClient
    
    required init(coder aDecoder: NSCoder) {
        settings = Settings()
        
        socket = SocketIOClient(socketURL: settings.connectionURL())
        
        
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        
        self.locationLabel.text = self.locationLabelText
        reset()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.currentDevice().orientation.isLandscape {
            self.settings.shouldRotate = false
        } else {
            self.settings.shouldRotate = true
        }
        setMapView()
    }
    
    @IBAction func Button(sender: UIButton) {
        self.emitClientParameters()
    }
    
    private func connectionTimeoutHandler() {
        let alert = UIAlertController(title: "Could not connect !", message: "Could not get response from server after \(self.settings.connectionTimeout) seconds.", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK!", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    private func setupSocketIOHandlers() {
        self.socket.on("mapData", callback: { (data: NSArray?, ackEmitter: AckEmitter? ) -> Void in
            println("mapData received")
            
            if let dictData = data?.firstObject as? NSDictionary {
                let map = Map(dictionary: dictData)
                self.settings.clientParams.mapType = MapType.fromString(map.mapType)
                self.initMapViewWithMap(map)
                self.mapView?.latestMap = map
                self.setMapView()
            }
        })
        
        self.socket.on("filterParamaters", callback: { (data: NSArray?, ackEmitter: AckEmitter?) -> Void in
            println("filterParameters received")
            
            if let dictData = data?.firstObject as? NSDictionary {
                let filter = ParticleFilter(dictionary: dictData)
                self.mapView?.latestFilterData = filter
                self.setMapView()
                
                if self.settings.shouldTrackProbableCell {
                    self.moveToMostProbableCell()
                }
                
                self.locationLabel.text = self.locationLabelText
            }
        })
    }
    
    private func reset() {
        self.socket = SocketIOClient(socketURL: settings.connectionURL())
        self.setupSocketIOHandlers()
        self.socket.connect(timeoutAfter: settings.connectionTimeout, withTimeoutHandler: self.connectionTimeoutHandler)
        self.emitClientParameters()
    }
    
    private func emitClientParameters() {
        // should be done with some sort of timer which looks at socket.connected ?? 
        self.socket.emit("clientParameters", settings.clientParams.toDictionary())
    }
    
    private func setMapView() {
        self.mapView?.shouldRotate = settings.shouldRotate
        self.mapView?.setNeedsDisplay()
    }
    
    // MARK: - Navigation
    
    @IBAction func cancelFromSettingsViewController(segue:UIStoryboardSegue) {
        println("cancel !")
    }
    
    @IBAction func saveFromSettingsViewController(segue:UIStoryboardSegue) {
        println("Save !")
        
        if let settingsViewController = segue.sourceViewController as? SettingsViewController {
            if let newSettings = settingsViewController.settings {
                let shouldReset = (self.settings.url != newSettings.url) || (self.settings.port != newSettings.port)
                
                let shouldRedrawMap = (self.settings.shouldRotate != newSettings.shouldRotate)
                let shouldMoveZoomView = newSettings.shouldTrackProbableCell
                
                let shouldResendClientParameters = self.settings.clientParams != newSettings.clientParams
                
                self.settings = newSettings
                
                if shouldReset {
                    self.reset()
                }
                
                if shouldRedrawMap {
                    setMapView()
                }
                
                if shouldMoveZoomView {
                    self.moveToMostProbableCell()
                }
                
                if shouldResendClientParameters {
                    emitClientParameters()
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let nav = segue.destinationViewController as? UINavigationController {
            if let settingsViewController = nav.topViewController as? SettingsViewController {
                settingsViewController.settings = self.settings
            }
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return mapView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        centerScrollViewContents()
    }
    
    func centerScrollViewContents() {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = mapView!.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        mapView!.frame = contentsFrame
    }
    
    private func initMapViewWithMap(map: Map) {
        
        let filterData = self.mapView?.latestFilterData
        
        var mapSize = CGSize()
        let scrollViewFrame = self.scrollView.frame.size
        let mulFacWidth = scrollViewFrame.width / map.width
        let mulFacHeight = scrollViewFrame.height / map.height
        let mulFac = CGFloat(5.0) * min(mulFacHeight, mulFacWidth)
        
        mapSize.width = mulFac * map.getWidthDependingOnRotation(self.settings.shouldRotate)
        mapSize.height = mulFac * map.getHeightDependingOnRotation(self.settings.shouldRotate)
        
        let frame = CGRect(origin: CGPoint(x: 0, y: 0), size: mapSize)
        
        if self.mapView == nil {
            self.mapView = MapView(frame: frame)
            self.scrollView.addSubview(mapView!)
            let rotateGestureRecognizer = UIRotationGestureRecognizer(target: self, action: "scrollViewRotateGesture:")
            scrollView.addGestureRecognizer(rotateGestureRecognizer)
            

        } else {
            self.mapView?.frame = frame
        }

        self.mapView!.latestFilterData = filterData
                
        self.initScrollView()
    }
    
    private func initScrollView() {
        let size = self.mapView?.frame.size
        self.scrollView.contentSize = size!

        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        
        let maxScale = max(scaleWidth, scaleHeight)
        let minScale = min(scaleWidth, scaleHeight)
        
        let zoomLevel = self.settings.shouldRotate ? maxScale : minScale
        
        scrollView.minimumZoomScale = zoomLevel
        scrollView.maximumZoomScale = zoomLevel
        scrollView.zoomScale = zoomLevel
        
        centerScrollViewContents()
    }
    
    func scrollViewRotateGesture(recognizer: UIRotationGestureRecognizer) {
        if recognizer.rotation >= CGFloat(M_PI / 2.0) || recognizer.rotation <= CGFloat(M_PI / -2.0) {
            recognizer.rotation = 0.0
            self.settings.shouldRotate = !self.settings.shouldRotate

            self.setMapView()
            
        }
        
    }
    
    func moveToMostProbableCell() {
        if let probableCellRect = self.mapView?.mostProbableCellRect {
            self.scrollView.zoomToRect(probableCellRect, animated: true)
        }
        
        
    }

}

